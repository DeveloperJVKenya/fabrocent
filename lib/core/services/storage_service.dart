import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_logger.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ─── Profile photos ───────────────────────────────────────────────────────

  static Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    AppLogger.sync('Uploading profile photo for userId=$userId');
    try {
      final ref = _storage.ref().child('profile_photos/$userId/avatar.jpg');
      final task = await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await task.ref.getDownloadURL();
      AppLogger.sync('✅ Profile photo uploaded — url=${url.substring(0, 60)}...');
      return url;
    } catch (e, st) {
      AppLogger.error('STORAGE', 'Profile photo upload failed for userId=$userId', e, st);
      rethrow;
    }
  }

  static Future<void> deleteProfilePhoto(String userId) async {
    AppLogger.sync('Deleting profile photo for userId=$userId');
    try {
      await _storage.ref().child('profile_photos/$userId/avatar.jpg').delete();
      AppLogger.sync('✅ Profile photo deleted');
    } catch (e) {
      AppLogger.warn('STORAGE', 'Could not delete profile photo (may not exist): $e');
    }
  }

  // ─── CSV exports ──────────────────────────────────────────────────────────

  static Future<String> uploadExport({
    required String userId,
    required String filename,
    required String csvContent,
  }) async {
    AppLogger.sync('Uploading CSV export "$filename" for userId=$userId');
    try {
      final ref = _storage.ref().child('exports/$userId/$filename');
      final bytes = csvContent.codeUnits;
      final task = await ref.putData(
        Uint8List.fromList(bytes),
        SettableMetadata(contentType: 'text/csv'),
      );
      final url = await task.ref.getDownloadURL();
      AppLogger.sync('✅ CSV export uploaded — $filename (${bytes.length} bytes)');
      return url;
    } catch (e, st) {
      AppLogger.error('STORAGE', 'CSV export upload failed for $filename', e, st);
      rethrow;
    }
  }
}

final storageServiceProvider = Provider<StorageService>((_) => StorageService());
