import 'package:flutter/material.dart';
import 'package:projectsv_flutter/global.dart';
import 'package:projectsv_flutter/views/test_page.dart';
import 'package:projectsv_flutter/views/train_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _widgets = <Widget>[
    TrainPage(),
    TestPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Model>(
        create: (_) => Model(),
        builder: (context, widget) {
          Model model = context.watch<Model>();
          return Scaffold(
            bottomNavigationBar: model.modelId != null
                ? BottomNavigationBar(
                    currentIndex: model.currentIndex,
                    onTap: (value) => setState(() {
                      model.currentIndex = value;
                    }),
                    items: <BottomNavigationBarItem>[
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
            body: _widgets.elementAt(model.currentIndex),
          );
        });
  }
}
