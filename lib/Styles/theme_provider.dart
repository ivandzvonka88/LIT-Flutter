
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_beta/Utils/SharedPrefsHelper.dart';

import 'app_themes.dart';

class ThemeNotifier with ChangeNotifier{
    ThemeData _theme = t1;
    ThemeNotifier(this._theme);

    getTheme() => _theme;

    setTheme(ThemeData theme) async {
        _theme = theme;
        notifyListeners();
    }

}