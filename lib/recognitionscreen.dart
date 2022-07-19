// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unnecessary_null_comparison

// import 'dart:html';
import 'dart:io';
// import 'package:ocrapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F9FB),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {},
              child: Icon(Icons.copy, size: 28),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xffEC360E),
              heroTag: null,
              onPressed: () {
                pickmedia();
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
                    (imagePath != null)
                        ? Image.file(File(imagePath!))
                        : InkWell(
                            onTap: () {},
                            child: Image(
                                width: 256,
                                height: 256,
                                fit: BoxFit.fill,
                                image: AssetImage('images/uploadfile.png'))
                            // : FileImage(pickedImage) as ImageProvider),
                            ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Lorem ipsum",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff1738EB),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ))));
  }

  void pickmedia() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      imagePath = file.path;
      setState(() {});
    }
  }
}
