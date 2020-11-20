import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(new MaterialApp(
    title: "Test Camera",
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  File imageFile;
  ImagePicker _picker = ImagePicker();

  _openGallery(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(image.path);
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(image.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Camera"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _decideImageView() {
    if (imageFile != null)
      return Image.file(imageFile, width: 400, height: 400,);
    else
      return Text("No Image Selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              RaisedButton(
                onPressed: () => _showChoiceDialog(context),
                child: Text("Select Image"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
