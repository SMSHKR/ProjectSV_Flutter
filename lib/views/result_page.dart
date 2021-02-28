import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ResultPage extends StatelessWidget {

  final Response response;

  ResultPage({Key key, @required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
      ),
      body: Center(
        child: Text("Test Result"),
      ),
    );
  }
}