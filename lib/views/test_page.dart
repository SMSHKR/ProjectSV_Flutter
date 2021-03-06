import 'dart:io';

import 'package:projectsv_flutter/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectsv_flutter/views/result_page.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'result_page.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File imageFile;
  ImagePicker _picker = ImagePicker();

  _openGallery(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      this.setState(() {
        if (imageFile != null)
          imageFile.delete();
        imageFile = File(image.path);
      });
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    if (image != null) {
      this.setState(() {
        if (imageFile != null)
          imageFile.delete();
        imageFile = File(image.path);
      });
    }
    Navigator.of(context).pop();
  }

  _sendForTest(String model) async {
    if (imageFile == null) {
      Toast.show("Please select image first", context);
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl + 'test/'));
    request.fields["model"] = model;
    request.files.add(await http.MultipartFile.fromPath("image", imageFile.path));
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(request: request)));
    setState(() {
      imageFile.delete();
      imageFile = null;
      imageCache.clear();
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
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
      return Image.file(
        imageFile,
        width: 400,
        height: 400,
      );
    else
      return Icon(
        Icons.image_not_supported_outlined,
        size: 200,
        color: Colors.grey[350],
      );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Signature"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: "Send selected signature to train model",
            onPressed: () => setState(() {
              _sendForTest(model.modelId);
            }),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              ElevatedButton(
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
