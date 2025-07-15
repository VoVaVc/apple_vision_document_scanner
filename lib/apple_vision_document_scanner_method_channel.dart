import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apple_vision_document_scanner_platform_interface.dart';

enum AppleVisionDocumentScannerMethods {
  scan,
  destroy,
}

/// An implementation of [AppleVisionDocumentScannerPlatform] that uses method channels.
class MethodChannelAppleVisionDocumentScanner extends AppleVisionDocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apple_vision_document_scanner');

  @override
  Future<List<File>> scan() async {
    final imagePaths = await methodChannel.invokeMethod<List<String>>(AppleVisionDocumentScannerMethods.scan.name) ?? [];
    final imageFiles = imagePaths.map((path) => File(path)).toList();
    return imageFiles;
  }

  @override
  Future<void> destroy() async {
    await methodChannel.invokeMethod<List<String>>(AppleVisionDocumentScannerMethods.destroy.name);
    return;
  }
}
