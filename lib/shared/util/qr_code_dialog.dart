import 'package:flutter/widgets.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog_platform_interface.dart';

class QrBarCodeScannerDialog {
  Future<String?> getPlatformVersion() {
    return QrBarCodeScannerDialogPlatform.instance.getPlatformVersion();
  }

  void getScannedQrBarCode(
      {BuildContext? context, required Function(String?) onCode}) {
    QrBarCodeScannerDialogPlatform.instance
        .scanBarOrQrCode(context: context, onScanSuccess: onCode,);
  }
}
