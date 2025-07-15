// import 'package:flutter_test/flutter_test.dart';
// import 'package:apple_vision_document_scanner/apple_vision_document_scanner.dart';
// import 'package:apple_vision_document_scanner/apple_vision_document_scanner_platform_interface.dart';
// import 'package:apple_vision_document_scanner/apple_vision_document_scanner_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAppleVisionDocumentScannerPlatform
//     with MockPlatformInterfaceMixin
//     implements AppleVisionDocumentScannerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final AppleVisionDocumentScannerPlatform initialPlatform = AppleVisionDocumentScannerPlatform.instance;

//   test('$MethodChannelAppleVisionDocumentScanner is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAppleVisionDocumentScanner>());
//   });

//   test('getPlatformVersion', () async {
//     AppleVisionDocumentScanner appleVisionDocumentScannerPlugin = AppleVisionDocumentScanner();
//     MockAppleVisionDocumentScannerPlatform fakePlatform = MockAppleVisionDocumentScannerPlatform();
//     AppleVisionDocumentScannerPlatform.instance = fakePlatform;

//     expect(await appleVisionDocumentScannerPlugin.getPlatformVersion(), '42');
//   });
// }
