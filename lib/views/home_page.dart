import 'package:flutter/material.dart';
import 'package:projectsv_flutter/global.dart';
import 'package:projectsv_flutter/views/test_page.dart';
import 'package:projectsv_flutter/views/train_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  List<Widget> _widgets = <Widget> [
    TrainPage(),
    TestPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: modelId != null
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (value) { setState(() { _currentIndex = value; }); },
              items: <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                  icon: Icon(Icons.model_training),
                  label: "Train",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: "Test",
                )
              ],
            )
          : null,
      body: _widgets.elementAt(_currentIndex),
    );
  }
}
