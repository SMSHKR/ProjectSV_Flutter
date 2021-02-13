import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  String modelId;
  setModelId(String id) async {
    modelId = id;
    notifyListeners();
  }
}

String serverUrl = "http://10.0.2.2:8000/";
