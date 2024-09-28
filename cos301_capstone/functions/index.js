const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors");
const vision = require("@google-cloud/vision");
const {onObjectFinalized} = require("firebase-functions/v2/storage");
const {getStorage} = require("firebase-admin/storage");
const logger = require("firebase-functions/logger");
const visionClient = new vision.ImageAnnotatorClient();

admin.initializeApp();
const db = admin.firestore();
const GOOGLE_MAPS_API_KEY = "AIzaSyAK92a9EH6D2_HL14GhePhna0B3ovYkyQA";

const corsHandler = cors({origin: true});

exports.getVets = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const location = req.query.location;
    const radius = req.query.radius;
    const type = req.query.type || "veterinary_care";
    const googleMapsUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    const params = {
      location: location,
      radius: radius,
      type: type,
      key: GOOGLE_MAPS_API_KEY,
    };

    try {
      const response = await axios.get(googleMapsUrl, {params});
      res.status(200).send(response.data);
    } catch (error) {
      console.error("Error fetching data from Google Maps API:", error);
      res.status(500).send({error: "Failed to fetch data"});
    }
  });
});

exports.imageLabeling = onObjectFinalized(async (object) => {
  const filePath = object.data.name;  // Use object.data.name to get the file path
  const bucketName = object.data.bucket;

  console.log('Received object:', object);  // Log the entire object
  console.log(`Processing image at: ${filePath}`);

  if (!filePath) {
    console.error("File path is undefined. Skipping Firestore update.");
    return;
  }

  try {
    // Perform label detection using Google Cloud Vision API
    const [result] = await visionClient.labelDetection(`gs://${bucketName}/${filePath}`);
    const labels = result.labelAnnotations.map(label => label.description);

    console.log(`Labels detected: ${labels}`);

    // Ensure labels array is not empty
    if (!labels || labels.length === 0) {
      console.error("No labels detected or labels array is empty.");
      return;
    }

    // Define the regular expression pattern
    const regExp = new RegExp('posts/[^_]+_([^_]+)_\\d+');

    // Apply the pattern to the filePath
    const match = regExp.exec(filePath);

    if (match && match[1]) {
      const postId = match[1];
      console.log(`Extracted postId: ${postId}`);

      // Update the post document with the labels
      await admin.firestore().collection('posts').doc(postId).update({
        labels: labels,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Labels updated in Firestore for post: ${postId}`);
    } else {
      console.log("File is not a post. Saving labels to a new Firestore document.");

      // Save the labels to Firestore in a new document
      await admin.firestore().collection('images').add({
        filePath: filePath,  // Ensure filePath is valid
        labels: labels,      // Ensure labels are valid
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Labels saved to Firestore for image: ${filePath}`);
    }
  } catch (error) {
    console.error("Error during image labeling or Firestore save:", error);
  }
});

exports.safeSearchImageOnUpload = onObjectFinalized(async (object) => {
  const filePath = object.name;  // Path to the uploaded image in Firebase Storage
  const bucketName = object.bucket;

  // Perform SafeSearch detection using Google Cloud Vision API
  const [result] = await visionClient.safeSearchDetection(`gs://${bucketName}/${filePath}`);
  const safeSearch = result.safeSearchAnnotation;

  // Check SafeSearch results for inappropriate content
  const isAdultContent = safeSearch.adult === 'LIKELY' || safeSearch.adult === 'VERY_LIKELY';
  const isViolentContent = safeSearch.violence === 'LIKELY' || safeSearch.violence === 'VERY_LIKELY';
  const isRacyContent = safeSearch.racy === 'LIKELY' || safeSearch.racy === 'VERY_LIKELY';
  const isInappropriate = isAdultContent || isViolentContent || isRacyContent;

  // Store SafeSearch results in Firestore
  await db.collection('images').add({
    filePath: filePath,      // Path to the image in Firebase Storage
    safeSearch: safeSearch,  // Store detailed SafeSearch data
    isInappropriate: isInappropriate,  // Boolean flag for inappropriate content
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Optionally: delete or mark the image as inappropriate
  if (isInappropriate) {
    console.log(`Image ${filePath} flagged as inappropriate:`, safeSearch);

    // Optionally: Delete the image from Firebase Storage
    const storage = admin.storage().bucket(bucketName);
    await storage.file(filePath).delete();

    // Or: Notify the user or log the issue for moderation review
    console.log(`Deleted image ${filePath} due to inappropriate content.`);
  } else {
    console.log(`Image ${filePath} passed SafeSearch check.`);
  }
});

// Handle unhandled promise rejections
process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection at:", promise, "reason:", reason);
  // Application specific logging, throwing an error, or other logic here
});

// Handle uncaught exceptions
process.on("uncaughtException", (error) => {
  console.error("Uncaught Exception:", error);
  // Application specific logging, throwing an error, or other logic here
});