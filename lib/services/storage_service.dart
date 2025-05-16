import 'dart:io';
import 'package:agrirent/config/supabase_config.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static const String BUCKET_NAME = 'equipment-images';
  static final _uuid = Uuid();

  static Future<String> uploadImage(File imageFile) async {
    try {
      final session = SupabaseConfig.supabase.auth.currentSession;
      if (session == null) {
        throw Exception('Authentication required');
      }

      final fileExt = path.extension(imageFile.path);
      final fileName = '${session.user.id}/${_uuid.v4()}$fileExt';

      await SupabaseConfig.supabase
          .storage
          .from(BUCKET_NAME)
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      final imageUrl = SupabaseConfig.supabase
          .storage
          .from(BUCKET_NAME)
          .getPublicUrl(fileName);

      return imageUrl;
    } on StorageException catch (e) {
      print('Storage Exception: ${e.message}, Status: ${e.statusCode}');
      throw Exception('Failed to upload image: $e');
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    try {
      final List<String> imageUrls = [];
      
      for (final imageFile in imageFiles) {
        final imageUrl = await uploadImage(imageFile);
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      final session = SupabaseConfig.supabase.auth.currentSession;
      if (session == null) {
        throw Exception('Authentication required');
      }

      final uri = Uri.parse(imageUrl);
      final fileName = path.basename(uri.path);
      final userId = session.user.id;

      final fullPath = '$userId/$fileName';

      await SupabaseConfig.supabase
          .storage
          .from(BUCKET_NAME)
          .remove([fullPath]);
    } on StorageException catch (e) {
      print('Storage Exception: ${e.message}, Status: ${e.statusCode}');
      throw Exception('Failed to delete image: $e');
    } catch (e) {
      print('Error deleting image: $e');
      throw Exception('Failed to delete image: $e');
    }
  }

  static Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (final imageUrl in imageUrls) {
        await deleteImage(imageUrl);
      }
    } catch (e) {
      print('Error deleting images: $e');
      throw Exception('Failed to delete images: $e');
    }
  }
} 