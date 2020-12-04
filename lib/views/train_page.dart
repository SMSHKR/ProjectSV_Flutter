import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projectsv_flutter/global.dart';
import 'package:provider/provider.dart';

class TrainPage extends StatefulWidget {
  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  void _sendForTrain(Model model) async {
    final id = Random().nextInt(9999);
    model.setModelId(id);
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
        onPressed: () {},
        tooltip: "Add Signature to Train",
        child: Icon(Icons.add),
      ),
    );
  }
}
