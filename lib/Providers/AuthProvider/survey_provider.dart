import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/DBC/Auth.dart';

class SurveyProvider{
  Auth db = Auth();
  String userID;
  SurveyProvider(String userID){
    this.userID = userID;
  }
  Future<void> updateUserBirthday(String val){
    db.updateUserBirthday(userID, val);
  }
  Future<void> updateUserThemePreference(String val){
    db.updateUserThemePreferences(userID, val);
  }
  Future<void> updateUserGender(String val){
    db.updateUserGender(userID, val);
  }
  Future<void> updateUserPreference(String val){
    db.updateUserPreference(userID, val);
  }
  Future<DocumentSnapshot> getCategories(){
    return db.getLituationCategories();
  }
  Future<void> updateUserLocation(String val , LatLng loc){
    db.updateUserLocation(userID, val , loc);
  }

}