import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model with ChangeNotifier {
  String modelId;

  Model() {
    SharedPreferences.getInstance().then((value) => setModelId(value.getString("modelId")));
  }

  setModelId(String id) async {
    modelId = id;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("modelId", modelId);
    notifyListeners();
  }
}

String serverUrl = "http://10.0.2.2:8000/";
