// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  // String? imagePath;
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F9FB),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Icon(Icons.copy, size: 28),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xffEC360E),
              heroTag: null,
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Icon(Icons.reply, size: 34),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                        height: 55 + MediaQuery.of(context).viewInsets.top),
                    Text(
                      "Text Recognition",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff1738EB),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 30),
                    if (textScanning) const CircularProgressIndicator(),
                    if (!textScanning && imageFile == null)
                      InkWell(
                          onTap: () {},
                          child: Image(
                              width: 256,
                              height: 256,
                              fit: BoxFit.fill,
                              image: AssetImage('images/uploadfile.png'))),
                    if (imageFile != null) Image.file(File(imageFile!.path)),
                    Text(
                      scannedText,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff1738EB),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ))));
  }

  // void pickmedia(ImageSource source) async {
  //   XFile? file = await ImagePicker().pickImage(
  //       source: source, maxWidth: 256, maxHeight: 256, imageQuality: 100);
  //   if (file != null) {
  //     imagePath = file.path;
  //     setState(() {});
  //   }
  // }
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }
}
