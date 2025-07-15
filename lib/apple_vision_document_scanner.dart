
import 'dart:io';

import 'apple_vision_document_scanner_platform_interface.dart';

class AppleVisionDocumentScanner {
  Future<List<File>> scan() {
    return AppleVisionDocumentScannerPlatform.instance.scan();
  }

  Future<void> destroy() {
    return AppleVisionDocumentScannerPlatform.instance.destroy();
  }
}
