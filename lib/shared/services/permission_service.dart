import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPermission() async {
    bool granted = true;
    final Map<Permission, PermissionStatus> statuses = await <Permission>[
      Permission.camera,
      Permission.microphone,

      //add more permission to request here.
    ].request();

    if (statuses[Permission.camera]!.isDenied) {
      //check each permission status after.
      granted = false;
      debugPrint('Camera permission is denied.');
    }

    if (statuses[Permission.microphone]!.isDenied) {
      //check each permission status after.
      granted = false;
      debugPrint('Microphone permission is denied.');
    }
    return granted;
  }
}
