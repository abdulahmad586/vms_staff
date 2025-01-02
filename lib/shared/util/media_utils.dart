import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:media_thumbnail/media_thumbnail.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaUtils {
  static const String MEDIA_TYPE_UNKNOWN = 'unknown';
  static const String MEDIA_TYPE_PICTURE = 'photo';
  static const String MEDIA_TYPE_VIDEO = 'video';
  static const String MEDIA_TYPE_AUDIO = 'audio';

  static List<String> picturesExt = ["jpg", "jpeg", "png", "gif", "bmp"];
  static List<String> audioExt = ["m4a", "flac", "mp3", "aac", "wav", "wma"];
  static List<String> videoExt = ["flv", "mp4", "3gp", "wmv", "mkv", "avi"];

  static String determineType(String path) {
    String ext = path.substring(path.lastIndexOf(".") + 1, path.length);
    if (picturesExt.contains(ext)) {
      return MEDIA_TYPE_PICTURE;
    } else if (videoExt.contains(ext)) {
      return MEDIA_TYPE_VIDEO;
    } else if (audioExt.contains(ext)) {
      return MEDIA_TYPE_AUDIO;
    }
    return MEDIA_TYPE_UNKNOWN;
  }

  static Future<Uint8List?> generateThumbnailFromLocal(String filePath,
      {int maxWidth = 128, int quality = 25}) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: maxWidth,
      quality: quality,
    );
    return uint8list;
  }

  static Future<Uint8List?> generateThumbnailFromNetwork(String fileUrl,
      {int maxWidth = 128, int quality = 25}) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: fileUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: maxWidth,
      quality: quality,
    );
    return uint8list;
  }

  static Future<String> generateThumbnail(String mediaPath) async {
    try {
      final thumbnailPath =
          "${Directory.systemTemp.path}/${"${mediaPath.substring(mediaPath.lastIndexOf("/") + 1, mediaPath.lastIndexOf("."))}_thumb"}.jpg";
      if (!await File(thumbnailPath).exists()) {
        await MediaThumbnail.videoThumbnail(mediaPath, thumbnailPath);
        // print("SUCCESS GENERATING THUMB $thumbnailPath");
      }
      return mediaPath;
    } catch (e) {
      // print("ERROR GENERATING THUMB $e");
    }

    return mediaPath;
  }

  static Future<String> audioFileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return await blobToBase64(bytes, mime: "audio/aac");
  }

  static Future<String> wavToBase64(String filePath) async {
    File file = File(filePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<String> blobToBase64(Uint8List fileBlob,
      {String mime = "image/jpeg"}) async {
    // fileBlob = await FlutterImageCompress.compressWithList(fileBlob, quality: 75);
    return 'data:$mime;base64,${base64Encode(fileBlob)}';
    // return 'data:image/jpeg;base64,${base64Encode(fileBlob).substring(0,15)}';
  }
}
