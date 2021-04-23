import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model with ChangeNotifier {
  String modelId;
  int currentIndex = 0;

  Model() {
    SharedPreferences.getInstance().then((value) => setModelId(value.getString("modelId")));
  }

  setModelId(String id) async {
    if (id == null) return;
    modelId = id;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("modelId", modelId);
    currentIndex = (modelId != null) ? 1 : 0;
    notifyListeners();
  }
}

String serverUrl = "http://10.0.2.2:8000/";
int trainTimeoutDuration = 60;
int testTimeoutDuration = 3;
