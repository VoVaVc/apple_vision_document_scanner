import 'dart:io';

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
  List<File> scannedFiles = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IOS Document Scanner Example'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
              print('Starting document scan...');
              try {
                final scannedFiles = await appleVisionDocumentScannerPlugin.scan();
                setState(() {
                  this.scannedFiles = scannedFiles;
                });
              } catch (e) {
                print('Error scanning documents: $e');
              }
            },
          child: const Icon(Icons.document_scanner),
        ),
        body: CarouselView(
    scrollDirection: Axis.vertical,
    itemExtent: double.infinity,
    children: [...scannedFiles.map((file) => Image.file(file))],
    )));
  }
}
