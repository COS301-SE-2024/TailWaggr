import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class ImageApi {
  // Image moderation function for web
  Future<Map<String, dynamic>> uploadImage(PlatformFile platformFile) async {
    // Use the actual PicPurify URL (you might need CORS proxy for testing in browsers)
    var picpurifyUrl = 'https://cors-anywhere.herokuapp.com/https://www.picpurify.com/analyse/1.1'; // CORS proxy used for testing, remove if not needed
    var request = http.MultipartRequest('POST', Uri.parse(picpurifyUrl));

    // Add the necessary fields for the API request
    request.fields['API_KEY'] = 'Dv08sITGmtiEaVbDDcpHlVVztctmqmDf'; // Replace with your actual API key
    request.fields['task'] = 'porn_moderation,drug_moderation,gore_moderation,suggestive_nudity_moderation,weapon_moderation,drug_moderation'; // Tasks for moderation
    request.fields['origin_id'] = 'xxxxxxxxx';  // Optional, replace with unique ID if needed
    request.fields['reference_id'] = 'yyyyyyyy';  // Optional, use as needed

    // Add the image data as bytes
    request.files.add(http.MultipartFile.fromBytes(
      'file_image',
      platformFile.bytes!,  // Use the bytes from the PlatformFile
      filename: platformFile.name  // Ensure the correct filename is passed
    ));

    try {
      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        print(response);
        // Get the response data
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);
        print(jsonResponse);
        return jsonResponse;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return {'error': 'Failed to upload image'};
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }
}
