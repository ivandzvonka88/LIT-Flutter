import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Views/Auth/login.dart';
import 'package:lit_beta/Views/Auth/register.dart';
import 'package:lit_beta/Views/Auth/survey.dart';
import 'package:lit_beta/Views/Home/home.dart';
import 'package:lit_beta/Views/Lituations/create_lituation.dart';
import 'package:lit_beta/Views/Nav/bottom_navigator.dart';
import 'package:lit_beta/Views/Profile/settings.dart';
import 'package:lit_beta/Views/Profile/vibes.dart';
import 'package:lit_beta/Views/Profile/view_profile.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainPageRoute:
      return PageTransition(child: MainPage() , type: PageTransitionType.fade);
    case LoginPageRoute:
      return PageTransition(child: LoginPage() , type: PageTransitionType.leftToRight);
    case RegisterPageRoute:
      return PageTransition(child: RegisterPage() , type: PageTransitionType.rightToLeft);
    case HomePageRoute:
      var userid = settings.arguments;
      return PageTransition(child: BottomNavigationController(userID: userid) , type: PageTransitionType.bottomToTop);
    case SurveyPageRoute:
      var userid = settings.arguments;
      return PageTransition(child: SurveyPage(userID: userid) , type: PageTransitionType.fade);
    case VibesPageRoute:
      var visit = settings.arguments;
      return PageTransition(child: VibesPage(visit: visit,) , type: PageTransitionType.fade);
    case VisitProfilePageRoute:
      var visit = settings.arguments;
      return PageTransition(child: VisitProfilePage(visit: visit,) , type: PageTransitionType.fade);
    case SettingsPageRoute:
      var userID = settings.arguments;
      return PageTransition(child: SettingsPage(userID: userID,) , type: PageTransitionType.topToBottom);
    case CreateLituationPageRoute:
      var lituationVisit = settings.arguments;
      return PageTransition(child: CreateLituationPage(lv: lituationVisit,) , type: PageTransitionType.fade);
  }
}