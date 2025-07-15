import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apple_vision_document_scanner_method_channel.dart';

abstract class AppleVisionDocumentScannerPlatform extends PlatformInterface {
  /// Constructs a AppleVisionDocumentScannerPlatform.
  AppleVisionDocumentScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppleVisionDocumentScannerPlatform _instance = MethodChannelAppleVisionDocumentScanner();

  /// The default instance of [AppleVisionDocumentScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppleVisionDocumentScanner].
  static AppleVisionDocumentScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppleVisionDocumentScannerPlatform] when
  /// they register themselves.
  static set instance(AppleVisionDocumentScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<File>> scan() {
    throw UnimplementedError('scan() has not been implemented.');
  }

  Future<void> destroy() {
    throw UnimplementedError('destroy() has not been implemented.');
  }
}
