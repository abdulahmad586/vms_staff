import 'package:flutter/material.dart';

import 'qr_scannerview.dart';

class QrBarCodeScannerDialog {
  Future<void> getScannedQrBarCode({
    required BuildContext context,
    required Function(String?) onCode,
  }) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerView()),
    );

    onCode(result);
  }
}
