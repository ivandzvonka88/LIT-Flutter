import 'package:flutter/material.dart';

Color textColorDark= const Color(0xff1c1c1c);
Color textColorLight= Colors.white;
final darkTheme = ThemeData(
    primaryColorDark: Colors.black,
    primaryColorLight: const Color(0xFFb8460d),
    primarySwatch: Colors.deepOrange,
    splashColor:  Colors.deepOrange,
    buttonColor:  const Color(0xFFb8460d),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor:  const Color(0xFF484848),
    accentColor: const Color(0xFFE3824D),
    accentIconTheme: IconThemeData(color: Color(0xFFEC9566)),
    dividerColor: Colors.white,
    textSelectionColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFF171717),
    textTheme: TextTheme(
        button: TextStyle(fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //button text
        bodyText1: TextStyle(fontSize: 12.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        bodyText2: TextStyle(fontSize: 14.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        headline1: TextStyle(fontSize: 10.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400),
        headline2: TextStyle(fontSize: 12.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline3: TextStyle(fontSize: 14.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline4: TextStyle(fontSize: 16.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline5: TextStyle(fontSize: 18.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline6: TextStyle(fontSize: 24.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w600),
        subtitle1: TextStyle(color: const Color(0xffeb5b2f),fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //input labels
        subtitle2: TextStyle(color: const Color(0xffeb5b2f),fontSize: 14 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400) //input labels
    ),
    primaryTextTheme: TextTheme(
        button: TextStyle(fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //button text
        bodyText1: TextStyle(fontSize: 10.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        bodyText2: TextStyle(fontSize: 12.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        headline1: TextStyle(fontSize: 8.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400),
        headline2: TextStyle(fontSize: 10.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline3: TextStyle(fontSize: 12.5 , color: Colors.white, fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline4: TextStyle(fontSize: 13.5 , color: Colors.white, fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline5: TextStyle(fontSize: 16.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline6: TextStyle(fontSize: 18.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w600),
        subtitle1: TextStyle(color: Colors.red,fontSize: 10.5 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //input labels
        subtitle2: TextStyle(color: const Color(0xffeb5b2f),fontSize: 20.0 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400) //
    )
);

final BLHTheme = ThemeData(
    primaryColorDark: Colors.black,
    primaryColorLight: const Color(0xFFb8460d),
    primarySwatch: Colors.deepOrange,
    splashColor:  Colors.deepOrange,
    buttonColor:  const Color(0xFFb8460d),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor:  const Color(0xFF484848),
    accentColor: const Color(0xFFE3824D),
    accentIconTheme: IconThemeData(color: Color(0xFFEC9566)),
    dividerColor: Colors.white,
    textSelectionColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFF171717),
    textTheme: TextTheme(
        button: TextStyle(fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //button text
        bodyText1: TextStyle(fontSize: 12.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        bodyText2: TextStyle(fontSize: 14.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        headline1: TextStyle(fontSize: 10.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400),
        headline2: TextStyle(fontSize: 12.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline3: TextStyle(fontSize: 14.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline4: TextStyle(fontSize: 16.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline5: TextStyle(fontSize: 18.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline6: TextStyle(fontSize: 24.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w600),
        subtitle1: TextStyle(color: const Color(0xffeb5b2f),fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //input labels
        subtitle2: TextStyle(color: const Color(0xffeb5b2f),fontSize: 14 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400) //input labels
    ),
    primaryTextTheme: TextTheme(
        button: TextStyle(fontSize: 16 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //button text
        bodyText1: TextStyle(fontSize: 10.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        bodyText2: TextStyle(fontSize: 12.5 , fontFamily: 'Itim-Regular', color: const Color(0xffeb5b2f)),
        headline1: TextStyle(fontSize: 8.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400),
        headline2: TextStyle(fontSize: 10.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline3: TextStyle(fontSize: 12.5 , color: Colors.white, fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline4: TextStyle(fontSize: 13.5 , color: Colors.white, fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline5: TextStyle(fontSize: 16.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w500),
        headline6: TextStyle(fontSize: 18.5 , color: const Color(0xffeb5b2f), fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w600),
        subtitle1: TextStyle(color: Colors.red,fontSize: 10.5 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400), //input labels
        subtitle2: TextStyle(color: const Color(0xffeb5b2f),fontSize: 20.0 , fontFamily: 'Itim-Regular' , fontWeight: FontWeight.w400) // //
    )
);


//light theme
final t1 = ThemeData(
    backgroundColor:  const Color(0xfff5f5f5), //main background
    scaffoldBackgroundColor:  Colors.white, //secondary background
    textSelectionColor:  const Color(0xff1c1c1c) ,//primary text (data, info etc)
    primaryColor: const Color(0xFFb8460d), //contrast background
    buttonColor: const Color(0xFFb8460d),
    splashColor:  Colors.deepOrangeAccent,
    dividerColor: Colors.black,
    accentColor: const Color(0xFFb8460d),
    errorColor: Colors.redAccent,
    indicatorColor: Colors.blueAccent,

    dialogBackgroundColor: Colors.white,
    hintColor: Colors.deepOrange,
    secondaryHeaderColor: Colors.deepOrange,
    textTheme: TextTheme(
        button: TextStyle(fontSize: 16.5 , fontFamily: 'Helvetica' , fontWeight: FontWeight.w500), //button text
        bodyText1: TextStyle(fontSize: 12.5 , fontFamily: 'Helvetica'),
        bodyText2: TextStyle(fontSize: 14.5 , fontFamily: 'Helvetica'),
        headline1: TextStyle(fontSize: 10.5 , fontFamily: 'Helvetica'),
        headline2: TextStyle(fontSize: 12.5 , fontFamily: 'Helvetica'),
        headline3: TextStyle(fontSize: 14.5 , fontFamily: 'Helvetica' , color: textColorDark),
        headline4: TextStyle(fontSize: 16.5 , fontFamily: 'Helvetica'),
        headline5: TextStyle(fontSize: 18.5 , fontFamily: 'Helvetica'),
        headline6: TextStyle(fontSize: 24.5 , fontFamily: 'Helvetica'),
        subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), //input labels
        subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400) //input labels
    ),
);

//dark theme
final t2 = ThemeData(
    backgroundColor: const Color(0xFF121212), //main background
    scaffoldBackgroundColor: const Color(0xFF212121),//secondary background
    textSelectionColor:  const Color(0xfff5f5f5),//primary text (data, info etc)
    //#914d19
    primaryColor: const Color(0xFFE65100), //contrast background
    buttonColor:const Color(0xFF424242,),
    splashColor:  Colors.deepOrangeAccent,
    dividerColor: Colors.white,
    accentColor: const Color(0xFFAA460d),
    errorColor: Colors.redAccent,
    indicatorColor: Colors.blueAccent,

    dialogBackgroundColor: Colors.white,
    hintColor: Colors.white70,
    secondaryHeaderColor: Colors.deepOrange,
    textTheme: TextTheme(
        button: TextStyle(fontSize: 16.5 , fontFamily: 'Helvetica'), //button text
        bodyText1: TextStyle(fontSize: 12.5 ),
        bodyText2: TextStyle(fontSize: 14.5 ),
        headline1: TextStyle(fontSize: 10.5),
        headline2: TextStyle(fontSize: 12.5),
        headline3: TextStyle(fontSize: 14.5 , color: textColorLight),
        headline4: TextStyle(fontSize: 16.5),
        headline5: TextStyle(fontSize: 18.5),
        headline6: TextStyle(fontSize: 24.5),
        subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), //input labels
        subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400) //input labels
    ),
);
