import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Strings/settings.dart';

class ProfileProvider{
  Auth db = Auth();
  final String userID;

  ProfileProvider(this.userID);

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
  updateUserBio(String desc) async {
   await db.updateUserBio(userID, desc).then((value){
     return;
   });
  }

  updateAttendancePreference(String val){
    db.updateUserAttendancePreference(userID , val);
  }
  updateVibeVisibility(String newVal){
    db.setVibeVisibility(userID, newVal);
  }
  updateLituationsVisibility(String newVal){
    db.setLituationVisibility(userID, newVal);
  }
  updateActivityVisibility(String newVal){
    db.setActivityVisibility(userID, newVal);
  }
  updateLocationVisibility(String newVal){
    db.setLocationVisibility(userID, newVal);
  }
  updateChatNotifications(bool newVal) {
    db.setChatNotifications(userID, newVal);
  }
  updateLituationNotifications(bool newVal){
    db.setLituationNotifications(userID, newVal);
  }
  updateInvitationNotifications(bool newVal){
    db.setInvitationNotifications(userID, newVal);
  }
  updateUserLocation(String location , LatLng locationLatLng){
    db.updateUserLocation(userID , location , locationLatLng);
  }
  updateVibeNotifications(bool newVal){
    db.setVibeNotifications(userID, newVal);
  }
  updateShowAdultLituations(bool newVal){
    db.enableAdultLituations(userID, newVal);
  }
  updateUsername(String newUsername){
    db.updateUsername(userID, newUsername);
  }
  updateGeneralNotifications(bool newVal){
    db.setGeneralNotifications(userID, newVal);
  }
  updateUserTheme(String newVal){
    db.setUserTheme(userID, newVal);
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

  getUserStreamByID(String id){
    return db.getUser(id);
  }

  cancelVibeRequest(String id){
    return db.cancelPendingVibeRequest(userID, id);
  }
  acceptPendingVibe(String id){
    return db.acceptPendingVibe(userID, id);
  }
  cancelRSVP(String userID , String lID){
    return db.cancelRSVP(userID, lID);
  }
  acceptRSVP(String userID , String lID){
    return db.approveRSVP(userID, lID);
  }
  vibedStream() {
    return db.getVibed(userID);
  }

  removeLituation(String lID, String listName){
    switch(listName){
      case 'upcoming lituations':{
        //EZDialog(dialogTitle , dialogMessage , confirmOrCancelRSVPButtons(lID) , context).show();
       return db.removeUpcomingLituation(userID ,lID);
      }
      case 'past lituations':{
        return db.removePastLituation(userID, lID);
      }
      case 'watched lituations':{
        return db.removeWatchedLituation(userID, lID);
      }
      case 'drafted lituations':{
        return db.removeDraft(userID, lID);
      }
      case 'pending lituations':{
        return db.removePendingLituation(userID, lID);
      }
      default:{
        return;
      }
    }
  }
   updateUserProfileImage(File profileImage) {
    return db.changeUserProfileImage(userID, profileImage);
  }
   resetUserSettingsToDefault(){
    db.resetSettingToDefault(userID);
  }
}