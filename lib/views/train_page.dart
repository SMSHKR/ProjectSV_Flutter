import 'package:flutter/material.dart';

class TrainPage extends StatefulWidget {
  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Train Model"),
      ),
      body: Center(
        child: Text("Train Page"),
      ),
    );
  }
}
