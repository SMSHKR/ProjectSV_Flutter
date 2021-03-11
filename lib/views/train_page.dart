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
  List<File> files = List();

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
    // print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    model.setModelId(jsonResponse['model']);
    Toast.show("Train Succeed", context);
  }

  _pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true
    );
    if (result != null) {
      setState(() {
        List<File> filesResult = result.paths.map((path) => File(path)).toList();
        files.addAll(filesResult);
      });
      // print(files.toString());
    }
  }

  Widget _decideListView() {
    if (files.isEmpty) {
      return Text("Please tap + at bottom right to select images.");
    }
    return ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Colors.red,
              alignment: Alignment(0.9, 0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                files.removeAt(index);
              });
            },
            child: Card(
                child: ListTile(
                  leading: Image.file(files[index]),
                  title: Text(files[index].path.split('/').last),
                  trailing: Icon(Icons.arrow_back),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Image.file(files[index]),
                        );
                      }
                    );
                  },
                ),
              ),
          );
        }
    );
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
        child: _decideListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(),
        tooltip: "Add Signature to Train",
        child: Icon(Icons.add),
      ),
    );
  }
}
