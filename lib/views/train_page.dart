import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectsv_flutter/global.dart';
import 'package:projectsv_flutter/views/train_loading_page.dart';
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
  List<File> files = [];

  _sendForTrain(Model model) async {
    if (files == null || files.length < 3) {
      Toast.show("Please choose 3 or more images", context);
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl + 'train/'));
    request.fields["old_model"] = model.modelId ?? "0";
    request.fields["model"] = Uuid().v1();
    for (File file in files) {
      request.files.add(await http.MultipartFile.fromPath("images", file.path));
    }
    try {
      bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TrainLoadingPage(request: request, model: model,)));
      if (!result) throw Exception();
      FilePicker.platform.clearTemporaryFiles();
      imageCache.clear();
      Toast.show("Train Succeed", context);
    } catch (_) {
      Toast.show("Error occurred, please try again", context, duration: 3);
    }
  }

  _pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true
    );
    if (result != null) {
      setState(() {
        Set<String> filesResult = result.paths.map((path) => path).toSet();
        files.forEach((element) {
          filesResult.add(element.path);
        });
        files.clear();
        filesResult.forEach((element) {
          files.add(File(element));
        });
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
                files[index].delete();
                files.removeAt(index);
                imageCache.clear();
              });
            },
            child: Card(
                child: ListTile(
                  leading: Image.file(files[index], width: 60,),
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
