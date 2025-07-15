import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apple_vision_document_scanner/apple_vision_document_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appleVisionDocumentScannerPlugin = AppleVisionDocumentScanner();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: CupertinoButton(
            child: Text('Scan Documents'),
            onPressed: () async {
              try {
                final scannedFiles = await appleVisionDocumentScannerPlugin.scan();
                // Handle the scanned files (e.g., display them, save them, etc.)
                print('Scanned files: $scannedFiles');
              } catch (e) {
                print('Error scanning documents: $e');
              }
            },
        ),
      ),
    ));
  }
}
