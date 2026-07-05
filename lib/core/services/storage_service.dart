import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'supabase_service.dart';

class StorageService {
  static final _picker = ImagePicker();

  static Future<XFile?> pickFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
  }

  static Future<XFile?> pickFromCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
  }

  static Future<String?> uploadTicketImage({
    required File file,
    required String fileName,
  }) async {
    try {
      await SupabaseService.client.storage
          .from('ticket-images')
          .upload(fileName, file);

      return SupabaseService.client.storage
          .from('ticket-images')
          .getPublicUrl(fileName);
    } catch (e) {
      print(e);
      return null;
    }
  }
}