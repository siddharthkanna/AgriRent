import 'dart:io';
import 'package:agrirent/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadFirebase {
  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> imageUrls = [];
    final user = SupabaseConfig.currentUser;

    if (user == null) {
      print("User is not authenticated");
      return imageUrls;
    }

    try {
      for (File imageFile in imageFiles) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final bytes = await imageFile.readAsBytes();
        
        final response = await SupabaseConfig.supabase.storage
            .from('equipment-images')
            .uploadBinary(
              'users/${user.id}/images/$fileName.jpg',
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
              ),
            );

        if (response.isNotEmpty) {
          final imageUrl = SupabaseConfig.supabase.storage
              .from('equipment-images')
              .getPublicUrl('users/${user.id}/images/$fileName.jpg');
          imageUrls.add(imageUrl);
        }
      }
    } catch (error) {
      print("Error uploading images: $error");
    }

    return imageUrls;
  }
}
