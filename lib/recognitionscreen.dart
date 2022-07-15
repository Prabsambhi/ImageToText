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
  late File pickedImage;
  optionsdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.gallery),
                child: Text("Gallery")),
            SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.camera),
                child: Text("Camera")),
            SimpleDialogOption(
                onPressed: () => Navigator.pop(context), child: Text("Cancel"))
          ],
        );
      },
    );
  }

  pickimage(ImageSource source) async {
    final image = await ImagePicker().getImage(source: source);
    setState(() {
      pickedImage = File(image!.path);
    });
  }

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
              onPressed: () {},
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
                    InkWell(
                      onTap: () => optionsdialog(context),
                      child: Image(
                          width: 256,
                          height: 256,
                          fit: BoxFit.fill,
                          image: pickedImage == null
                              ? AssetImage('images/uploadfile.png')
                              : FileImage(pickedImage) as ImageProvider),
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
}
