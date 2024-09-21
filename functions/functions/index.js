const functions = require('firebase-functions');
const express = require('express');
const axios = require('axios');
const cors = require('cors');
const FormData = require('form-data');  // Use form-data for Node.js

const app = express();
app.use(cors());  // Enable CORS
app.use(express.json());  // To parse JSON body

app.post('/proxy', async (req, res) => {
  try {
    const { API_KEY, task, origin_id, reference_id, file_image, filename } = req.body;
    //log fields
    console.log('API_KEY:', API_KEY);
    console.log('task:', task);
    console.log('origin_id:', origin_id);
    console.log('reference_id:', reference_id);
    console.log('file_image:', file_image);
    console.log('filename:', filename);

    if (!file_image) {
      return res.status(400).json({ error: 'No file provided' });
    }

    // Convert base64 to Buffer
    const imageBuffer = Buffer.from(file_image, 'base64');

    // Prepare the form data
    const formData = new FormData();
    formData.append('API_KEY', API_KEY);
    formData.append('task', task);
    formData.append('origin_id', origin_id || '');
    formData.append('reference_id', reference_id || '');
    formData.append('file_image', imageBuffer, { filename: filename, contentType: 'image/jpeg' });  // Properly handle Buffer with metadata

    // Send the request to PicPurify
    const response = await axios.post('https://www.picpurify.com/analyse/1.1', formData, {
      headers: formData.getHeaders(),
    });

    //print response
    console.log('PicPurify response:', response.data);
    // Return PicPurify's response
    res.json(response.data);
  } catch (error) {
    console.error('Error communicating with PicPurify:', error.message);
    res.status(500).json({ error: 'Error communicating with PicPurify' });
  }
});

// Export the app as a Firebase Function
exports.api = functions.https.onRequest(app);
