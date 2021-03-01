import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResultPage extends StatelessWidget {

  final Map<String, dynamic> response;

  ResultPage({Key key, @required this.response}) : super(key: key);

  Widget _decideResultIcon() {
    return response['vote'] ?
        Icon(
          Icons.check,
          color: Colors.green,
          size: 160,
        ) :
        Icon(
          Icons.error,
          color: Colors.red,
          size: 160,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _decideResultIcon(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 180, 0, 0),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 100,
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
                percent: response['fake_ratio'],
                backgroundColor: Colors.green,
                progressColor: Colors.red,
              ),
            )
          ],
        )
      ),
    );
  }
}