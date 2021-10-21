import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Models/Vibes.dart';
import 'package:lit_beta/Strings/settings.dart';

class LoginProvider{
  Auth db = Auth();
  Future<String> signUserIn(String email , String password) async {
    await db.signIn(email, password).then((value){
      return value;
    });
  }

  Future<fb.User> currentUser() async {
     var t =  await db.getCurrentUser();
     return t;
  }

  UserVibe initNewVibe(){
    UserVibe uv = new UserVibe();
    uv.birthday = '';
    uv.gender = '';
    uv.clout = '250';
    uv.lituationPrefs = '';
    uv.preference = '';
    uv.bio = '';
    return uv;
  }

}