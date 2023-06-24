// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  // String? imagePath;
  FlutterTts flutterTts = FlutterTts();
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";
  List<String> sentences = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(248, 249, 251, 1),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  speakText(scannedText);
                },
                child: Icon(Icons.speaker, size: 28),
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    imageFile = null;
                    scannedText = "";
                    sentences = [];
                  });
                },
                child: Icon(Icons.clear, size: 28),
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                child: Icon(Icons.camera, size: 28),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                        height: 55 + MediaQuery.of(context).viewInsets.top),
                    Text(
                      "Text Recognition",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 103, 125, 255),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 30),
                    if (textScanning) const CircularProgressIndicator(),
                    if (!textScanning && imageFile == null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                            onTap: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Image(
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                                image: AssetImage('images/uploadfile.png'))),
                      ),
                    if (imageFile != null)
                      Container(
                          height: 400,
                          width: 400,
                          child: Image.file(File(imageFile!.path))),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                      color: Color.fromARGB(255, 231, 247, 255),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          scannedText,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 31, 31, 31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
  void speakText(String text) async {
    await flutterTts.speak(text);
  }

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
        scannedText += line.text + ' ';
      }
    }

    sentences = scannedText.split('. ');

    for (String sentence in sentences) {
      scannedText += sentence + '.\n';
    }
    textScanning = false;
    setState(() {});
  }
}
