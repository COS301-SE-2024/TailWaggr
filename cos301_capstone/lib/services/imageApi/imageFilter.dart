import 'package:file_picker/file_picker.dart';
import 'imageApi.dart';  // Your Image API service

class ImageFilter {
  Future<Map<String, dynamic>> moderateImage(PlatformFile selectedFile) async {
    try {
      // Call image moderation API
      ImageApi imageApi = ImageApi();
      var moderationResult = await imageApi.uploadImage(selectedFile);

      if (moderationResult.containsKey('error')) {
        print('Image moderation failed: ${moderationResult['error']}');
        return {'status': 'error', 'message': 'Image moderation failed'};
      } else {
        // Parse moderation results
        bool pornContent = moderationResult['porn_moderation']['porn_content'];
        bool drugContent = moderationResult['drug_moderation']['drug_content'];
        bool goreContent = moderationResult['gore_moderation']['gore_content'];
        bool suggestiveNudity = moderationResult['suggestive_nudity_moderation']['suggestive_nudity_content'];
        bool weaponContent = moderationResult['weapon_moderation']['weapon_content'];

        // Generate warning message if any inappropriate content is found
        String warningMessage = "The image contains inappropriate content: \t";
        bool hasInappropriateContent = false;

        if (pornContent) {
          warningMessage += "• Pornographic content.\n";
          warningMessage += "Looks like you're in the wrong place for OnlyFans content!\n";
          hasInappropriateContent = true;
        }
        if (drugContent) {
          warningMessage += "• Drug-related content.\n";
          warningMessage += "Are you trying to sell drugs on TailWaggr?\n If you need help with substance abuse, please reach out to a professional.\n Here are some helplines: 0800 12 13 14 or 0800 21 22 23\n";
          hasInappropriateContent = true;
        }
        if (goreContent) {
          warningMessage += "• Violent or gory content.\n";
          warningMessage += "In the case of self-harm, please reach out to someone for help.\nHere are some helplines: 0800 12 13 14 or 0800 21 22 23, or visit https://www.sadag.org/\n";
          hasInappropriateContent = true;
        }
        if (suggestiveNudity) {
          warningMessage += "• Suggestive nudity.\n";
          warningMessage += "Sir/madam you're in the wrong place for advertising your onlyfans content\nPlease keep it PG-13, this is a family-friendly app.\n";
          hasInappropriateContent = true;
        }
        if (weaponContent) {
          warningMessage += "• Weapons or dangerous objects.\n";
          warningMessage += "Are you trying to start a war on TailWaggr?\nPlease keep it peaceful, we're all friends here, no need for weapons.\n";
          hasInappropriateContent = true;
        }

        if (hasInappropriateContent) {
          return {
            'status': 'fail',
            'message': warningMessage,
            'content': {
              'porn': pornContent,
              'drugs': drugContent,
              'gore': goreContent,
              'nudity': suggestiveNudity,
              'weapon': weaponContent
            }
          };
        } else {
          // No issues detected
          return {'status': 'pass', 'message': 'Image is clean and safe to upload.'};
        }
      }
    } catch (e) {
      print('Error moderating image: $e');
      return {'status': 'error', 'message': 'An unexpected error occurred'};
    }
  }
}
