import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ImageApi {
  Future<Map<String, dynamic>> uploadImage(PlatformFile platformFile) async {
    var localFunctionUrl = 'https://us-central1-tailwaggr.cloudfunctions.net/api/proxy';

    // Convert file to base64
    String base64Image = base64Encode(platformFile.bytes!);

    // Prepare request body
    var requestBody = {
      'API_KEY': 'Dv08sITGmtiEaVbDDcpHlVVztctmqmDf',
      'task': 'porn_moderation,drug_moderation,gore_moderation,suggestive_nudity_moderation,weapon_moderation,drug_moderation',
      'origin_id': 'some_origin_id',
      'reference_id': 'some_reference_id',
      'file_image': base64Image,  // Send base64 image
      'filename': platformFile.name, // Send the filename
    };
    
    try {
      var response = await http.post(
        Uri.parse(localFunctionUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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
