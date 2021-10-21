import 'dart:io';

import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Strings/settings.dart';

class ViewProfileProvider{
  Auth db = Auth();
  final String userID;

  ViewProfileProvider(this.userID);

  userStream() {
    return db.getUser(userID);
  }

  bool validDescription(String desc){
    if(desc != null)
      return true;
    return false;
  }

  userSettingsStream(){
    return db.getUserSettings(userID);
  }
  logoutUser(){
    db.signOut();
  }

  sendVibeRequest(String id){
    db.sendVibeRequest(id, userID);
  }

  userLituationsStream(){
    return db.getUserLituations(userID);
  }
  getLituationStream(String lID){
    return db.getLituationByID(lID);
  }
  allLituationsStream(){
    return db.getAllLituations();
  }
  vibingStream() {
    return db.getVibing(userID);
  }
  getVisitorVibingStream(String id) {
    return db.getVibing(id);
  }
  getUserStreamByID(String id){
    return db.getUser(id);
  }

  cancelVibeRequest(String id){
    return db.cancelPendingVibeRequest(id, userID);
  }

  vibedStream() {
    return db.getVibed(userID);
  }

}