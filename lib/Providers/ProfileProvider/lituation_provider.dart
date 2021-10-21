import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Models/Lituation.dart';

class LituationProvider {
  Auth db = Auth();
  final String lID;
  final String userID;

  LituationProvider(this.lID , this.userID);

  lituationStream(){}

  Future<DocumentSnapshot> getCategories(){
    return db.getLituationCategories();
  }
  getUserStreamByID(String id){
    return db.getUser(id);
  }
  Future<dynamic> searchUser(String username) async {
    List<String> results = [];
   var users = [];
   var friends = await friendList();
    await db.getUsers().then((value){
      for(var d in value.docs){
        if(d.data()['username'].toString().toLowerCase().contains(username.toLowerCase())){
          if(!results.contains(d.data()[userID])){
            if(friends.contains(d.data()[userID])){
              results.add(d.data()['userID']);
              users.add(d);
            }
          }
        }
      }
    });
    return users;
  }

  Future<List<String>> friendList() async {
    List<String> friends = [];
    List users = await db.getVibed(userID).toList();
    users.add(await db.getVibing(userID).toList());
    for(var u in users){
      if (!friends.contains(u.data()['userID'])){
        friends.add(u.data()['userID']);
      }
    }
    return friends;

  }
  Lituation initNewLituation(){
    Lituation l = new Lituation();
    l.capacity = 'N/A';
    l.date = DateTime.now();
    l.end_date = DateTime.now();
    l.dateCreated = DateTime.now();
    l.description = '';
    l.title = '';
    l.entry = 'Open';
    l.hostID = userID;
    l.eventID = lID;
    l.fee = 'free';
    l.location = '';
    l.locationLatLng = new LatLng(0, 0);
    l.themes = '';
    l.status = 'New';
    l.clout = 0;
    l.invited = [];
    l.musicGenres = [];
    l.requirements = [];
    l.specialGuests = [];
    l.observers = [];
    l.vibes = [];
    l.thumbnailURLs = [];

    return l;
  }
  String validateLituation(Lituation l){
    if(l.title == '' || l.title == null){
      return 'You must enter a valid title for your Lituation.';
    }
    if(l.capacity == null){
      return 'Select the capacity for your Lituation.';
    }
    if(l.date == null){
      return 'Select a valid start date for your Lituation.';
    }
    if(l.end_date == null){
      return 'Select an end time for your Lituation.';
    }
    if(l.description == '' || l.description == null){
      return 'You must enter a proper \n description of your Lituation.';
    }
    if(l.entry == '' || l.entry == null){
      return 'You must select an Entry type for your Lituation.';
    }
    if(l.location == '' && l.locationLatLng == LatLng(0,0)){
      return 'Enter a valid address for your Lituation.';
    }
    if(l.themes == '' || l.themes == null){
      return 'You must provide at least one theme \nfor your Lituation.';
    }
    if(l.status == null || l.status == ''){
      l.status = 'New';
    }
    if(l.clout == null){
      l.clout = 0;
    }
    if(l.invited == null){
      l.invited = [];
    }
    if(l.musicGenres == null){
      l.musicGenres = [];
    }
    if(l.requirements == null){
      l.requirements = [];
    }
    if(l.specialGuests == null){
      l.specialGuests = [];
    }
    if(l.observers == null){
      l.observers = [];
    }
    if(l.vibes == null){
      l.vibes = [];
    }
    if(l.thumbnailURLs == null){
      l.thumbnailURLs = [];
    }
    return 'valid';
  }
}