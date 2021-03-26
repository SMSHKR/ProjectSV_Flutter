import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:toast/toast.dart';

import '../global.dart';

class ResultPage extends StatefulWidget {

  final MultipartRequest request;

  ResultPage({Key key, @required this.request}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultPageState(request: request);
}

class _ResultPageState extends State<ResultPage> {

  final MultipartRequest request;

  _ResultPageState({@required this.request});

  Future<Response> _streamResponse() async {
    final streamedResponse = await request.send().timeout(Duration(seconds: testTimeoutDuration));
    return Response.fromStream(streamedResponse).timeout(Duration(seconds: testTimeoutDuration));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
      ),
      body: FutureBuilder(
          future: _streamResponse(),
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.hasData) {
              var response = snapshot.data;
              if (response.statusCode != 200)
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pop(context);
                  Toast.show("Error occurred, if this keep happening try re-train model", context, duration: 3);
                });
              else {
                Map<String, dynamic> jsonResponse = jsonDecode(response.body);
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        jsonResponse['vote'] ?
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 160,
                        ) :
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 160,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 180, 0, 0),
                          child: LinearPercentIndicator(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            lineHeight: 40,
                            leading: Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            trailing: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            linearStrokeCap: LinearStrokeCap.butt,
                            animation: true,
                            percent: jsonResponse['fake_ratio'],
                            backgroundColor: Colors.green,
                            progressColor: Colors.red,
                          ),
                        )
                      ],
                    )
                );
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pop(context);
                Toast.show("Error occurred, if this keep happening try re-train model", context, duration: 3);
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
      ),
    );
  }
}