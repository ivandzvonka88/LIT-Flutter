import 'package:flutter/material.dart';

class ThemeResolver{
    Color _primaryColor;
    MaterialColor _secondaryColor;
    Color _backgroundColor;
    Color _foregroundColor;
    Color _buttonColor;
    Color _primaryTextColor;
    Color _secondaryTextColor;
    Color _accentColor;
    Color _buttonTextColor;
    MaterialColor _textInfoColor;
    BuildContext context;

    ThemeResolver(this.context);

    Color get primaryColor => Theme.of(context).primaryColorLight;

    Color get secondaryColor => Theme.of(context).primaryColorDark;

    Color get backgroundColor => Theme.of(context).backgroundColor;

    Color get foregroundColor => Theme.of(context).scaffoldBackgroundColor;

    Color get buttonColor => Theme.of(context).buttonColor;

    Color get primaryTextColor => Theme.of(context).buttonColor;

    Color get secondaryTextColor => Theme.of(context).primaryColorLight;

    Color get accentColor => Theme.of(context).accentColor;

    Color get buttonTextColor => Theme.of(context).primaryColorDark;

    Color get textInfoColor => Theme.of(context).dividerColor;
}
