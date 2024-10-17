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
const STOCK_IMAGE = "gs://tailwaggr.appspot.com/charlesdeluvio-DziZIYOGAHc-unsplash.jpg";
const STOCK_IMAGE_BUCKET = "tailwaggr.appspot.com";
const STOCK_IMAGE_PATH = "charlesdeluvio-DziZIYOGAHc-unsplash.jpg";
const storage = getStorage();
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
  const filePath = object.data.name;
  const bucketName = object.data.bucket;

  console.log('Received object for safe search:', object);
  console.log(`Processing image at: ${filePath}`);

  if (!filePath) {
    console.error("File path is undefined. Skipping Firestore update.");
    return;
  }

  try {
    // Perform safe search detection using Google Cloud Vision API
    const [result] = await visionClient.safeSearchDetection(`gs://${bucketName}/${filePath}`);
    const safeSearch = result.safeSearchAnnotation;

    console.log(`Safe search results:`, safeSearch);
    // Check if the image is safe
    const isSafe = (safeSearch.adult === 'VERY_UNLIKELY' || safeSearch.adult === 'UNLIKELY' || safeSearch.adult === 'POSSIBLE') &&
                    (safeSearch.violence === 'VERY_UNLIKELY' || safeSearch.violence === 'UNLIKELY' || safeSearch.violence === 'POSSIBLE') &&
                    (safeSearch.racy === 'VERY_UNLIKELY' || safeSearch.racy === 'UNLIKELY' || safeSearch.racy === 'POSSIBLE');
    // Define the regular expression pattern
    if (isSafe) return;
    const regExp = new RegExp('posts/[^_]+_([^_]+)_\\d+');

    // Apply the pattern to the filePath
    const match = regExp.exec(filePath);

    if (match && match[1]) {
      const postId = match[1];
      console.log(`Extracted postId: ${postId}`);

      if (isSafe) {
        // Update the post document with the safe search results
        await admin.firestore().collection('posts').doc(postId).update({
          safeSearch: safeSearch,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log(`Safe search results updated in Firestore for post: ${postId}`);
      } else {
        // Delete the image and the post if the image is not safe
        await admin.storage().bucket(bucketName).file(filePath).delete();
        await admin.firestore().collection('posts').doc(postId).delete();

        console.log(`Unsafe image and associated post deleted for post: ${postId}`);
      }
    } else {
      console.log("File is not a post. Replacing image with a stock image.");

      // Replace the image with a stock image
      await storage.bucket(STOCK_IMAGE_BUCKET).file(STOCK_IMAGE_PATH).copy(storage.bucket(bucketName).file(filePath));

      console.log(`Image replaced with stock image for file: ${filePath}`);

      // Save the safe search results to Firestore in a new document
      await admin.firestore().collection('images').add({
        filePath: filePath,  // Ensure filePath is valid
        safeSearch: safeSearch,  // Ensure safeSearch results are valid
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Safe search results saved to Firestore for image: ${filePath}`);
    }
  } catch (error) {
    console.error("Error during safe search detection or Firestore save:", error);
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