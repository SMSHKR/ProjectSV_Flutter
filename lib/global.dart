import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  int modelId;
  setModelId(int id) async {
    modelId = id;
    notifyListeners();
  }
}
