const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors");

admin.initializeApp();

const GOOGLE_MAPS_API_KEY = "AIzaSyAK92a9EH6D2_HL14GhePhna0B3ovYkyQA";

const corsHandler = cors({origin: true});

exports.getVets = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const location = req.query.location;
    const radius = req.query.radius;
    const type = req.query.type || "animal_hospital";
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
