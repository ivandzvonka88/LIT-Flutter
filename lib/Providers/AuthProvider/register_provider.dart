import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Models/Vibes.dart';
import 'package:lit_beta/Strings/settings.dart';

class RegisterProvider{
  Auth db = Auth();
  Future<String> registerNewUser(String email , String password , String username) async {
    User u = new User();
    u.email = email;
    u.pass = password;
    u.profileURL = 'https://firebasestorage.googleapis.com/v0/b/litt-a9ee1.appspot.com/o/userProfiles%2Flitlogo.png?alt=media&token=cfbc6f00-eec7-46d6-9365-5783d7c8ef3f';
    u.userImagesUrls = [];
    u.userLocation = '';
    u.userLocLatLng = LatLng(0, 0);
    u.userVibe = initNewVibe();
    u.username = username;
    //USERID and DEVICE TOKEN SET ON INIT
    await db.signUp(email , password).then((value){
      u.userID = value;
      if(value.contains('ERROR')){
        return value;
      }
      db.completeRegistration(u);
      return value;
    }); //register user
    return u.userID;
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