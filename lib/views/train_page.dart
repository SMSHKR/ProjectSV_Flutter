import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectsv_flutter/global.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class TrainPage extends StatefulWidget {
  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  List<File> files;

  _sendForTrain(Model model) async {
    if (files == null || files.isEmpty) {
      Toast.show("No image selected", context);
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl + 'train/'));
    request.fields["old_model"] = model.modelId ?? "0";
    request.fields["model"] = Uuid().v1();
    for (File file in files) {
      request.files.add(await http.MultipartFile.fromPath("images", file.path));
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    model.setModelId(jsonResponse['model']);
  }

  _pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true
    );
    if (result != null) {
      files = result.paths.map((path) => File(path)).toList();
      print(files.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Train Model"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: "Send selected signature to train model",
            onPressed: () => setState(() {
              _sendForTrain(model);
            }),
          )
        ],
      ),
      body: Center(
        child: Text("Train Page\nModel: ${model.modelId}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(),
        tooltip: "Add Signature to Train",
        child: Icon(Icons.add),
      ),
    );
  }
}
