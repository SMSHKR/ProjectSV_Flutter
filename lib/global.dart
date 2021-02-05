import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  int modelId;
  setModelId(int id) async {
    modelId = id;
    notifyListeners();
  }
}

String serverUrl = "http://10.0.2.2:8000/upload/";
