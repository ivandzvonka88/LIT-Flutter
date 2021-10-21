
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lit_beta/Models/Vibes.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Models/User.dart' as UserModel;
import 'package:lit_beta/Strings/settings.dart';

import 'DBA.dart';

class Auth implements DBA {
  final FirebaseAuth dbAuth = FirebaseAuth.instance;
  final FirebaseFirestore dbRef = FirebaseFirestore.instance;
  final FirebaseStorage dbMediaRef = FirebaseStorage.instance;

  @override
  Future<User> getCurrentUser() async {
   return dbAuth.currentUser;
  }

  @override
  Future<bool> isVerified() async {
    return dbAuth.currentUser.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    dbAuth.currentUser.sendEmailVerification();
  }

  @override
  Future<void> signOut() async {
    return dbAuth.signOut();
  }
  @override
  Future<String> signIn(String email, String password) async {
    String userID = '';
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
          .then((value){
        updateStatus('online');
        userID = value.user.uid;
      });
    } on FirebaseAuthException catch (e){
      userID = handleAuthException(e);
    }
    return userID;
  }

  Future<TaskSnapshot> changeUserProfileImage(String userID , File image){
    dbMediaRef.ref().child('userProfiles').child(userID).putFile(image).then((taskSnapshot){
      //TODO Update to .error update check
      if(taskSnapshot.ref != null){
        taskSnapshot.ref.getDownloadURL().then((value){
          final newProfileUrl = value;
          dbRef.collection("users").doc(userID).set({'profileURL': newProfileUrl},SetOptions(merge: true)).then((_){

          });
        });
      }
      return taskSnapshot;
    });
  }
  void updateStatus(String status) async {
       dbRef.collection(db_users_collection).doc(dbAuth.currentUser.uid).update({'status.status' : status});
  }


  @override
  Future<String> signUp(String email , String password) async {
    try{
    User u = (await dbAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return u.uid;
    } on FirebaseAuthException catch (e){
     return handleAuthException(e);
    }
  }

  Stream<DocumentSnapshot> getUser(String userID) {
    return dbRef.collection('users').doc(userID).snapshots();
  }

  Stream<DocumentSnapshot> getVibing(String userID){
    return dbRef.collection('vibing').doc(userID).snapshots();
  }

  Stream<DocumentSnapshot> getVibed(String userID){
    return dbRef.collection('vibed').doc(userID).snapshots();
  }

  Future<void> updateUserClout(String userID, int newClout){
    int clout;
    dbRef.collection(db_users_collection).doc(userID).get().then((value){
      clout = int.parse(value.data()['userVibe']['clout']);
      newClout = clout + newClout;
    }).then((value){
      dbRef.collection(db_users_collection).doc(userID).update({'userVibe.clout': newClout.toString()});
    });
  }

  Future<DocumentSnapshot>  getLituationCategories() async {
    return  dbRef.collection("lituationCategories").doc("categories").get();
  }

  Future<void> updateUserBirthday(String userID , String val) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userVibe.birthday': val});
  }
  Future<void> updateUserThemePreferences(String userID , String val) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userVibe.lituationPrefs': val});
  }
  Future<void> updateUserGender(String userID , String val) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userVibe.gender': val});
  }
  Future<void> updateUserPreference(String userID , String val) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userVibe.preference': val});
  }
  Future<QuerySnapshot> searchUser(String username) async {
    return dbRef.collection('users').where('username', isEqualTo: username).get();
  }
  Future<QuerySnapshot> getUsers() async {
    return dbRef.collection("users").get();
  }
  Future<void> updateUserLocation(String userID , String val , LatLng point) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userLocation' : val}).then((value){
      updateUserLocationLatLng(userID, point);
    });
  }
  Future<void> updateUserLocationLatLng(String userID , LatLng val) async {
    GeoPoint g = GeoPoint(val.latitude, val.longitude);
    dbRef.collection("users").doc(userID).update({'userLocLatLng' : g});
  }

  //Settings Functions
  Future<void> setVibeVisibility(String userID , String val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'vibe_visibility': val});
  }
  Future<void> setLituationVisibility(String userID , String val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'lituatiom_visibility': val});
  }
  Future<void> setActivityVisibility(String userID , String val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'activity_visibility': val});
  }
  Future<void> setLocationVisibility(String userID , String val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'location_visibility': val});
  }
  Future<void> setLituationNotifications(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'lituation_notifications': val});
  }
  Future<void> setInvitationNotifications(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'invitation_notifications': val});
  }
  Future<void> updateUsername(String userID , String newName) async {
    dbRef.collection("users").doc(userID).update({'username' : newName});
  }
  Future<void> setGeneralNotifications(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'general_notifications': val});
  }
  Future<void> setChatNotifications(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'chat_notifications': val});
  }
  Future<void> setVibeNotifications(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'vibe_notifications': val});
  }
  Future<void> enableAdultLituations(String userID , bool val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'adult_lituations': val});
  }
  Future<void> setUserTheme(String userID , String val) async {
    dbRef.collection(db_user_settings_collection).doc(userID).update({'theme': val});
  }
  Future<void> updateUserBio(String userID , String val) async {
    dbRef.collection(db_users_collection).doc(userID).update({'userVibe.bio': val});
  }
  Future<void> updateUserAttendancePreference(String userID , String newAttendancePreference) async {
    dbRef.collection("users").doc(userID).update({'userVibe.preference' : newAttendancePreference});
  }

/*

if user is not in vibing and user is not pending: add user to pending vibing of visited, and add visited to pending vibes
* if pending vibe: remove user from visited pendingVibing and removed visited from user pendingVibed
* if already vibed: remove user from visited pending vibing and remove visited from user vibed
* handles send, cancel and remove
* */
  Future<void> sendVibeRequest(String visitor , String visited) async{
    var vd = [visited];
    var vo = [visitor];
    //we add them to the list of pending vibes
    dbRef.collection('vibing').doc(visited).get().then((value){
      List pending = List.from(value.data()['pendingVibing']);
      List vibes = List.from(value.data()['vibing']);
      if(!pending.contains(visitor) && !vibes.contains(visitor)){
        dbRef.collection('vibing').doc(visited).update(
            {'pendingVibing': FieldValue.arrayUnion(vo)}).then((value) {
          dbRef.collection('vibed').doc(visitor).update(
              {"pendingVibes": FieldValue.arrayUnion(vd)});
        });
      }else{
        if(pending.contains(visitor)){
          dbRef.collection('vibing').doc(visited).update({'pendingVibing': FieldValue.arrayRemove(vo)}).then((value){
            dbRef.collection('vibed').doc(visitor).update({"pendingVibes": FieldValue.arrayRemove(vd)});
          });
        }
        if(vibes.contains(visitor)){
          dbRef.collection('vibing').doc(visited).update({'vibing': FieldValue.arrayRemove(vo)}).then((value){
            dbRef.collection('vibed').doc(visitor).update({'vibed': FieldValue.arrayRemove(vd)});
            updateClout(visited, -3);
          });
        }
      }
    });
  }

  Future<void> addToPendingVibes(String user , String vibeID) async {
      dbRef.collection("vibed").doc(user).update({'pendingVibes': FieldValue.arrayUnion([vibeID])}).then((value){
        dbRef.collection("vibing").doc(vibeID).update({'pendingVibing': FieldValue.arrayUnion([user])});
        return;
      });
  }

 Future<void> removePendingVibe(String user ,  String vibeID) async {
    dbRef.collection("vibed").doc(user).update({'pendingVibes': FieldValue.arrayRemove([vibeID])}).then((value){
      dbRef.collection("vibing").doc(vibeID).update({'pendingVibing': FieldValue.arrayRemove([user])});
      return;
    });
 }

  Future<void> updateClout(String userID , int cloutAmt) async {
    int newClout;
    dbRef.collection("users").doc(userID).get().then((val){
      newClout = int.parse(val.data()['userVibe']['clout']);
      newClout = newClout + cloutAmt;
    }).then((value){
      dbRef.collection("users").doc(userID).update({'userVibe.clout' : newClout.toString()});
    });
  }
  Stream<DocumentSnapshot> getUserLituations(String userID){
    return dbRef.collection('users_lituations').doc(userID).snapshots();
  }
  Stream<DocumentSnapshot> getUserSettings(String userID){
    return dbRef.collection('users_settings').doc(userID).snapshots();
  }
  Stream<dynamic> getAllLituations(){
    return dbRef.collection('lituations').snapshots();
  }
  Stream<DocumentSnapshot> getLituationByID(String lituationID){
    return dbRef.collection('lituations').doc(lituationID).snapshots();
  }



  //USER LITUATIONS FUNCTIONS
  Future<void> removeDraft(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"drafts": FieldValue.arrayRemove(data)});
  }
  Future<void> removeUserLituation(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"lituations": FieldValue.arrayRemove((data))});
  }
  Future<void> removePastLituation(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"pastLituations": FieldValue.arrayRemove((data))});
  }
  Future<void> removeUpcomingLituation(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"upcomingLituations": FieldValue.arrayRemove((data))});
  }
  Future<void> removeWatchedLituation(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"observedLituations": FieldValue.arrayRemove((data))});
  }

  Future<void> removePendingLituation(String userId , String lID) async {
    var data = [lID];
    dbRef.collection('users_lituations').doc(userId).update({"pendingLituations": FieldValue.arrayRemove((data))});
  }

//VIBE Queries
  Future<void> acceptPendingVibe(String userID , String vibeID) async {
    var u = [vibeID];
    var m = [userID];
    cancelPendingVibeRequest(vibeID , userID).then((value) =>{
      dbRef.collection('vibing').doc(userID).update({'vibing': FieldValue.arrayUnion(u)}).then((value){
        dbRef.collection('vibed').doc(vibeID).update({'vibed': FieldValue.arrayUnion(m)});
        updateClout(userID, 5);
      })
    });
  }

  //Removes a user's RSVP from 'pending' list in a Lituation (view usages in : viewLituation.dart)
  Future<void> cancelRSVP(String userID , String lID){
    var u = [userID];
    var l = [lID];
    dbRef.collection('lituations').doc(lID).get().then((value){
      if(List.from(value.data()['pending']).contains(userID)){
        dbRef.collection('lituations').doc(lID).update({'pending': FieldValue.arrayRemove(u)}).then((value){
          dbRef.collection('users_lituations').doc(userID).update({'pendingLituations': FieldValue.arrayRemove(l)}).then((value){
            //TODO send disapproval message
          });
        });
      }
    });
  }

  Future<void> removeVibed(String visitor , String visited) async{
    var u = [visitor];
    var v = [visited];
    dbRef.collection('vibed').doc(visitor).update({"vibed": FieldValue.arrayRemove(v)}).then((value){
      dbRef.collection('vibing').doc(visitor).update({"vibing": FieldValue.arrayRemove(u)}).then((value){
        return;
      });
    });
  }

  //unvibe
  Future<void> removeVibing(String visitor , String visited) async{
    var u = [visitor];
    var v = [visited];
    dbRef.collection('vibing').doc(visitor).update({"vibing": FieldValue.arrayRemove(v)}).then((value){
      dbRef.collection('vibed').doc(visitor).update({"vibed": FieldValue.arrayRemove(u)}).then((value){
        return;
      });
    });
  }

  //adds user to lituation
  Future<void> approveRSVP(String userID , String lID){
    var u = [userID];
    var l = [lID];
    dbRef.collection('lituations').doc(lID).get().then((value){
      if(List.from(value.data()['pending']).contains(userID)){
        dbRef.collection('lituations').doc(lID).update({'pending': FieldValue.arrayRemove(u)}).then((value){
          dbRef.collection('lituations').doc(lID).update({'vibes': FieldValue.arrayUnion(u)}).then((value) {
            dbRef.collection('users_lituations').doc(userID).update({'pendingLituations': FieldValue.arrayRemove(l)}).then((value){
              dbRef.collection('users_lituations').doc(userID).update({'upcomingLituations': FieldValue.arrayUnion(l)}).then((value){
                //TODO send approval message
              });
            });
          });
        });
      }
    });
  }

  Future<void> cancelPendingVibeRequest(String userID , String vibeID) async {
    var u = [vibeID];
    var m = [userID];
    dbRef.collection('vibing').doc(userID).update({"pendingVibing": FieldValue.arrayRemove(u)}).then((value){
      dbRef.collection('vibed').doc(vibeID).update({"pendingVibes": FieldValue.arrayRemove(m)});
      dbRef.collection('vibed').doc(userID).update({"pendingVibes": FieldValue.arrayRemove(u)}).then((value){
        dbRef.collection('vibing').doc(vibeID).update({"pendingVibing": FieldValue.arrayRemove(m)});
      });
    });
  }


  Future<void> completeRegistration(UserModel.User u) async {
    String id = u.userID;
    await dbRef.collection('users').doc(id).set(u.toJson()).then((value){
      dbRef.collection(db_vibed_collection).doc(id).set(initNewUserVibed(id).toJson()).then((value){
        dbRef.collection(db_vibing_collection).doc(id).set(initNewUserVibing(id).toJson()).then((value){
          dbRef.collection(db_user_lituations_collection).doc(id).set(initNewUserLituations(id).toJson()).then((value){
            dbRef.collection(db_user_settings_collection).doc(id).set(initNewUserSettings(id).toJson()).then((value) {
              dbRef.collection(db_user_activity_collection).doc(id).set(initNewUserActivity(id).toJson()).then((value){
                return;
              });
            });
          });
        });
      });
    });
  }

  Future<void> resetSettingToDefault(String userID){
    dbRef.collection(db_user_settings_collection).doc(userID).set(initNewUserSettings(userID).toJson());
  }


  String handleAuthException(FirebaseAuthException e){
    print(e.code);
    switch(e.code){
      case "ERROR_INVALID_EMAIL":
        return auth_invalid_email_error_code;
        break;
      case "ERROR_WRONG_PASSWORD":
        return auth_wrong_password_error_code;
        break;
      case "ERROR_USER_NOT_FOUND":
        return auth_no_user_error_code;
        break;
      case "ERROR_USER_DISABLED":
        return auth_user_diabled_error_code;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return auth_too_many_request_error_code;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return auth_operation_not_allowed_error_code;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return auth_email_exists_error_code;
        break;
      default:
        return auth_operation_not_allowed_error_code;
    }
    }

    /*Register helper functions
    Help init user quickly with default*/

  UserModel.UserStatus initNewStatus(String userID){
    UserModel.UserStatus s = new  UserModel.UserStatus();
    s.user_id = userID;
    s.time = DateTime.now();
    s.status = 'Hello World';
    s.currentLocation = LatLng(0, 0);
    s.updateMessage = '';
    s.accumulatedClout = '';
    s.achievements = ['En-LIT-ened'];
    return s;
  }

  UserModel.UserActivity initNewUserActivity(String userID){
    UserModel.UserActivity ua = new  UserModel.UserActivity();
    ua.userID = userID;
    ua.interactedUsers = [];
    ua.likedPosts = [];
    ua.visitedLituations = [];
    ua.pendingVibes = [];
    return ua;
  }
  UserModel.UserLituations initNewUserLituations(String userID){
    UserModel.UserLituations u = new  UserModel.UserLituations();
    u.userID = userID;
    u.drafts = [];
    u.lituations = [];
    u.pastLituations = [];
    u.upcomingLituations = [];
    u.pendingLituations = [];
    u.observedLituations = [];
    u.recommendedLituations = [];
    u.invitations = [];
    return u;
  }
  Vibed initNewUserVibed(String userID){
    Vibed v = new Vibed();
    v.userID = userID;
    v.vibed = [];
    v.vibedCount = v.vibed.length.toString();
    v.pendingVibes = [];
    return v;
  }
  Vibing initNewUserVibing(String userID){
    Vibing v = new Vibing();
    v.userID = userID;
    v.vibing = [];
    v.vibingCount = v.vibing.length.toString();
    v.pendingVibing = [];
    return v;
  }
  UserModel.UserSettings initNewUserSettings(String userID){
    UserModel.UserSettings s = new  UserModel.UserSettings();
    s.userID = userID;
    s.vibe_visibility = PrivacySettings.PRIVATE;
    s.lituation_visibility = PrivacySettings.PRIVATE;
    s.activity_visibility = PrivacySettings.PRIVATE;
    s.location_visibility = PrivacySettings.PRIVATE;
    s.lituation_notifications = false;
    s.invitation_notifications = false;
    s.general_notifications = false;
    s.chat_notifications = false;
    s.vibe_notifications = false;
    s.adult_lituations = false;
    s.theme = "auto";
    return s;
  }
  }


