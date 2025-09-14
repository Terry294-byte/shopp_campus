import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // Cloudinary configuration - Replace these with your actual values
  // You can get these from your Cloudinary dashboard
  static const String cloudName = 'dcfcpbcoo'; // Replace with your Cloudinary cloud name
  static const String uploadPreset = 'profile_uploads'; // Replace with your upload preset
  static const String apiKey = 'your_api_key'; // Replace with your Cloudinary API key
  static const String apiSecret = 'your_api_secret'; // Replace with your Cloudinary API secret

  // Upload profile image to Cloudinary using HTTP
  static Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      final String uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add upload preset
      request.fields['upload_preset'] = uploadPreset;

      // Add public ID for the image
      request.fields['public_id'] = 'profile_images/$uid';

      // Add folder
      request.fields['folder'] = 'profile_images';

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        // Return the secure URL of the uploaded image
        return jsonResponse['secure_url'];
      } else {
        print('Upload failed: ${jsonResponse['error']['message']}');
        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  // Delete profile image from Cloudinary
  static Future<bool> deleteProfileImage(String uid) async {
    try {
      final String publicId = 'profile_images/$uid';
      final String deleteUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';

      // Create the authentication signature (simplified for upload preset)
      // For production, you should generate a proper signature using API secret
      var response = await http.post(
        Uri.parse(deleteUrl),
        body: {
          'public_id': publicId,
          'upload_preset': uploadPreset,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Delete failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting from Cloudinary: $e');
      return false;
    }
  }
}
