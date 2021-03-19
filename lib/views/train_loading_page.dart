import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';

import '../global.dart';

class TrainLoadingPage extends StatefulWidget {

  final MultipartRequest request;
  final Model model;

  TrainLoadingPage({Key key, @required this.request, @required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrainLoadingPageState(request: request, model: model);
}

class _TrainLoadingPageState extends State<TrainLoadingPage> {

  final MultipartRequest request;
  final Model model;

  _TrainLoadingPageState({@required this.request, @required this.model});

  Future<Response> _streamResponse() async {
    final streamedResponse = await request.send().timeout(Duration(seconds: trainTimeoutDuration));
    return Response.fromStream(streamedResponse).timeout(Duration(seconds: trainTimeoutDuration));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: FutureBuilder(
              future: _streamResponse(),
              builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
                if (snapshot.hasData) {
                  bool result = false;
                  if (snapshot.data.statusCode == 200) {
                    Map<String, dynamic> jsonResponse = jsonDecode(snapshot.data.body);
                    model.setModelId(jsonResponse['model']);
                    result = true;
                  }
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.pop(context, result);
                  });
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.pop(context, false);
                  });
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60.0,
                        height: 60.0,
                      )
                    ],
                  ),
                );
              }
          )
      ),
    );
  }
}