import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{

  // ignore: constant_identifier_names
  static const THEMESTATUS =  "THEME_STATUS";

  bool _darkTheme = false;
  bool get getIsdark => _darkTheme;

  setDarkTheme(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    prefs.setBool(THEMESTATUS, value);
    _darkTheme = value;

    notifyListeners();
  }


  Future <bool> getTheme() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _darkTheme = prefs.getBool(THEMESTATUS) ?? false;
      notifyListeners();

      return _darkTheme;
    }  
}