

import 'package:lit_beta/DBC/Auth.dart';

class VibeProvider {

  Auth db = Auth();
  final String userID;

  VibeProvider(this.userID);

  vibingStream(){
    return db.getVibing(userID);
  }

  vibedStream(){
    return db.getVibed(userID);
  }

  userStream(){
    return db.getUser(userID);
  }

  cancelVibed(String id){
    return db.removeVibed(userID, id);
  }
  cancelVibing(String id){
    return db.removeVibing(userID, id);
  }
  cancelVibeRequest(String id){
    return db.cancelPendingVibeRequest(userID, id);
  }

  acceptVibe(String id){
    return db.acceptPendingVibe(userID, id);
  }
  sendVibeRequest(String visitor ,  String userID){
    db.sendVibeRequest(visitor, userID);
  }
  getUserStreamByID(String id){
    return db.getUser(id);
  }

}