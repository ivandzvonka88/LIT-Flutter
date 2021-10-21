import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/Strings/settings.dart';

class User {
  String _email;
  String _pass;
  String _profileURL;
  List<String> _userImagesUrls;
  String _userID;
  String _userLocation;
  LatLng _userLocLatLng;
  UserVibe _userVibe;
  String _username;
  UserStatus _status;
  int _deviceToken;
  User(
      {String email,
        String pass,
        String profileURL,
        List<String> userImagesUrls,
        String userID,
        String userLocation,
        LatLng userLocLatLng,
        UserVibe userVibe,
        String username,
        UserStatus status,
        int deviceToken,
      }) {
    this._email = email;
    this._pass = pass;
    this._profileURL = profileURL;
    this._userImagesUrls = userImagesUrls;
    this._userID = userID;
    this._userLocation = userLocation;
    this._userVibe = userVibe;
    this._username = username;
    this._status = status;
    this._deviceToken = deviceToken;
  }

  String get email => _email;
  set email(String email) => _email = email;
  String get pass => _email;
  set pass(String pass) => _pass = pass;
  String get profileURL => _profileURL;
  set profileURL(String profileURL) => _profileURL = profileURL;
  List<String> get userImagesUrls => _userImagesUrls;
  set userImagesUrls(List<String> userImagesUrls) => _userImagesUrls = userImagesUrls;
  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get userLocation => _userLocation;
  set userLocation(String userLocation) => _userLocation = userLocation;
  UserVibe get userVibe => _userVibe;
  set userVibe(UserVibe userVibe) => _userVibe = userVibe;
  String get username => _username;
  set username(String username) => _username = username;
  UserStatus get status => _status;
  set status(UserStatus status) => _status = status;
  LatLng get userLocLatLng => _userLocLatLng;
  set userLocLatLng(LatLng userLocLatLng) => _userLocLatLng = userLocLatLng;
  set deviceToken(int deviceToken) => _deviceToken = deviceToken;
  int get deviceToken => _deviceToken;

  User.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _profileURL = json['profileURL'];
    _userImagesUrls = json['userImagesUrls'];
    _userID = json['userID'];
    _deviceToken = json['deviceToken'];
    _userLocation = json['userLocation'];
    _userLocLatLng = json['userLocLatLng'];
    _userVibe = json['userVibe'] != null
        ? new UserVibe.fromJson(json['userVibe'])
        : null;
    _status = json['status'] != null
        ? new UserStatus.fromJson(json['status'])
        : null;
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this._email;
    data['profileURL'] = this._profileURL;
    data['userImagesUrls'] = this._userImagesUrls;
    data['userID'] = this._userID;
    data['deviceToken'] = this._deviceToken;
    data['userLocation'] = this._userLocation;
    data['userLocLatLng'] = GeoPoint(this._userLocLatLng.latitude , this._userLocLatLng.longitude);
    if (this._userVibe != null) {
      data['userVibe'] = this._userVibe.toJson();
    }
    if (this._status != null) {
      data['status'] = this._status.toJson();
    }
    data['username'] = this._username;
    return data;
  }
}

class UserVibe {
  String _birthday;
  String _gender;
  String _clout;
  String _lituationPrefs;
  String _preference;
  String _bio;

  UserVibe(
      {String birthday,
        String gender,
        String clout,
        String lituationPrefs,
        String preference,
        String bio}) {
    this._birthday = birthday;
    this._gender = gender;
    this._clout = clout;
    this._lituationPrefs = lituationPrefs;
    this._preference = preference;
    this._bio = bio;
  }

  String get birthday => _birthday;
  set birthday(String birthday) => _birthday = birthday;
  String get gender => _gender;
  set gender(String gender) => _gender = gender;
  String get clout => _clout;
  set clout(String clout) => _clout = clout;
  String get lituationPrefs => _lituationPrefs;
  set lituationPrefs(String lituationPrefs) => _lituationPrefs = lituationPrefs;
  String get preference => _preference;
  set preference(String preference) => _preference = preference;
  String get bio => _bio;
  set bio(String bio) => _bio = bio;

  UserVibe.fromJson(Map<String, dynamic> json) {
    _birthday = json['birthday'];
    _gender = json['gender'];
    _clout = json['clout'];
    _lituationPrefs = json['lituationPrefs'];
    _preference = json['preference'];
    _bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this._birthday;
    data['gender'] = this._gender;
    data['clout'] = this._clout;
    data['lituationPrefs'] = this._lituationPrefs;
    data['preference'] = this._preference;
    data['bio'] = this._bio;
    return data;
  }
}

class UserStatus {
  String _user_id;
  DateTime _time;
  String _status;
  LatLng _currentLocation;
  String _updateMessage;
  String _accumulatedClout; //managed as int
  List<String> _achievements;

  UserStatus(
      {String user_id,
        DateTime time,
        String status,
        LatLng currentLocation,
        String  updateMessage,
        String accumulatedClout,
        List<String> achievements,
      }) {
    this._user_id;
    this._time;
    this._status;
    this._currentLocation;
    this._updateMessage;
    this._accumulatedClout;
    this._achievements;
  }

  String get user_id => _user_id;
  set user_id(String user_id) => _user_id = user_id;
  DateTime get time => _time = _time;
  set time(DateTime time) => _time = time;
  String get status => _status;
  set status(String status) => _status = status;
  LatLng get currentLocation => _currentLocation;
  set currentLocation(LatLng status) => _currentLocation = currentLocation;
  String get updateMessage => _updateMessage;
  set accumulatedClout(String accumulatedClout) => _accumulatedClout = accumulatedClout;
  String get accumulatedClout => _accumulatedClout;
  set updateMessage(String updateMessage) => _updateMessage = updateMessage;
  List<String> get achievements => _achievements;
  set achievements(List<String> achievements) => _achievements = achievements;

  UserStatus.fromJson(Map<String, dynamic> json) {
    _user_id = json['userID'];
    _time = json['time'];
    _status = json['status'];
    _currentLocation = json['currentLocation'];
    _updateMessage = json['updateMessage'];
    _accumulatedClout = json['accumulatedClout'];
    _achievements = json['achievements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this._user_id;
    data['time'] = this._time;
    data['status'] = this._status;
    data['currentLocation'] = this._currentLocation;
    data['updateMessage'] = this._updateMessage;
    data['accumulatedClout'] = this._accumulatedClout;
    data['achievements'] = this._achievements;
    return data;
  }

}

class UserSettings {
  String userID;
  String vibe_visibility;
  String lituation_visibility;
  String activity_visibility;
  String location_visibility;
  bool lituation_notifications;
  bool invitation_notifications;
  bool general_notifications;
  bool chat_notifications;
  bool vibe_notifications;
  bool adult_lituations;
  String theme;


  UserSettings(
      {String userID,
        String vibe_visibility,
        String lituation_visibility,
        String activity_visibility,
        String location_visibility,
        bool lituation_notifications,
        bool invitation_notifications,
        bool general_notifications,
        bool chat_notifications,
        bool vibe_notifications,
        bool adult_lituations,
        String theme,
      }) {
    this.userID = userID;
    this.vibe_visibility = vibe_visibility;
    this.lituation_visibility = lituation_visibility;
    this.activity_visibility = activity_visibility;
    this.location_visibility = location_visibility;
    this.lituation_notifications = lituation_notifications;
    this.chat_notifications = chat_notifications;
    this.vibe_notifications = vibe_notifications;
    this.adult_lituations = adult_lituations;
    this.invitation_notifications = invitation_notifications;
    this.general_notifications = general_notifications;
    this.theme = theme;


  }

  String get _userID => userID;
  set _userID(String userID) => userID = userID;
  String get _lituation_visibility => lituation_visibility;
  set _lituation_visibility(String lituation_visibility) => lituation_visibility = lituation_visibility;
  String get _activity_visibility => activity_visibility;
  set _activity_visibility(String activity_visibility) => activity_visibility = activity_visibility;
  String get _vibe_visibility => vibe_visibility;
  set _vibe_visibility(String vibe_visibility) => vibe_visibility = vibe_visibility;
  String get _location_visibility => location_visibility;
  set _location_visibility(String location_visibility) => location_visibility = location_visibility;
  String get _themes => theme;
  set _theme(String theme) => theme = theme;
  bool get _lituation_notifications => lituation_notifications;
  set _lituation_notifications(bool lituation_notifications) => lituation_notifications = lituation_notifications;
  bool get _vibe_notifications => vibe_notifications;
  set _vibe_notifications(bool vibe_notifications) => vibe_notifications = vibe_notifications;
  bool get _chat_notifications => chat_notifications;
  set _chat_notifications(bool chat_notifications) => chat_notifications = chat_notifications;
  bool get _adult_lituations => adult_lituations;
  set _adult_lituations(bool adult_lituations) => adult_lituations = adult_lituations;
  bool get _invitation_notifications => adult_lituations;
  set _invitation_notifications(bool invitation_notifications) => invitation_notifications = invitation_notifications;
  bool get _general_notifications => general_notifications;
  set _general_notifications(bool general_notifications) => general_notifications = general_notifications;

  UserSettings.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    vibe_visibility = json['vibe_visibility'];
    lituation_visibility = json['lituation_visibility'];
    activity_visibility = json['activity_visibility'];
    location_visibility = json['location_visibility'];
    lituation_notifications = json['lituation_notifications'];
    chat_notifications = json['chat_notifications'];
    general_notifications = json['general_notifications'];
    invitation_notifications = json['invitation_notifications'];
    vibe_notifications = json['vibe_notifications'];
    adult_lituations = json['adult_lituations'];
    theme = json['theme'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['vibe_visibility'] = this.vibe_visibility;
    data['lituation_visibility'] = this.lituation_visibility;
    data['activity_visibility'] = this.activity_visibility;
    data['location_visibility'] = this.location_visibility;
    data['lituation_notifications'] = this.lituation_notifications;
    data['chat_notifications'] = this.chat_notifications;
    data['general_notifications'] = this.general_notifications;
    data['invitation_notifications'] = this.invitation_notifications;
    data['vibe_notifications'] = this.vibe_notifications;
    data['adult_lituations'] = this.adult_lituations;
    data['theme'] = this.theme;
    return data;
  }

}
class UserActivity {
  String userID;
  List<String>  pendingVibes;
  List<String>  pendingVibeRequests;
  List<String> likedPosts;
  List<String> interactedUsers;
  List<UserLituationVisit> visitedLituations;

  UserActivity(
      {String userID,
        List<String> pendingVibes,
        List<String> pendingVibeRequests,
        List<String> likedPosts,
        List<String> interactedUsers,
        List<UserLituationVisit> visitedLituations,
      }) {
    this.userID = userID;
    this.pendingVibes = pendingVibes;
    this.pendingVibes = pendingVibeRequests;
    this.likedPosts = likedPosts;
    this.interactedUsers = interactedUsers;
    this.visitedLituations = visitedLituations;
  }

  String get _userID => userID;
  set _userID(String userID) => userID = userID;
  List<String> get _pendingVibes => pendingVibes;
  set _pendingVibes(List<String> pendingVibes) => pendingVibes = pendingVibes;
  List<String> get _pendingVibeRequests => pendingVibeRequests;
  set _pendingVibeRequests(List<String> pendingVibeRequests) => pendingVibeRequests = pendingVibeRequests;
  List<String> get _likedPosts => likedPosts;
  set _likedPosts(List<String> likedPosts) => likedPosts = likedPosts;
  List<String> get _interactedUsers => interactedUsers;
  set _interactedUsers(List<String> interactedUsers) => interactedUsers = interactedUsers;
  List<UserLituationVisit> get _visitedLituations => visitedLituations;
  set _visitedLituations(List<UserLituationVisit> visitedLituations) => visitedLituations = visitedLituations;

  UserActivity.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    pendingVibes = json['pendingVibes'];
    likedPosts = json['likedPosts'];
    interactedUsers = json['interactedUsers'];
    pendingVibeRequests = json['pendingVibeRequests'];
    visitedLituations = json['visitedLituations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['pendingVibes'] = this.pendingVibes;
    data['likedPosts'] = this.likedPosts;
    data['interactedUsers'] = this.interactedUsers;
    data['pendingVibeRequests'] = this.pendingVibeRequests;
    data['visitedLituations'] = this.visitedLituations;
    return data;
  }
}

class UserLituationVisit {
  String rating;
  String visitID;
  DateTime visitTime;
  Map<String , LatLng> lituationLocation;
  List<String> verifications;
  List<String> interactedVibes;


  UserLituationVisit(
      {
        String rating,
        String visitID,
        DateTime visitTime,
        Map<String , LatLng> vistedLituation,
        List<String> verifications,
        List<String> interactedVibes,
      }
      ) {
    this.rating = rating;
    this.visitID = visitID;
    this.visitTime = visitTime;
    this.lituationLocation = vistedLituation;
    this.verifications = verifications;
    this.interactedVibes = interactedVibes;
  }

  String get _rating => rating;
  set _rating(String rating) => rating = rating;
  String get _visitID => visitID;
  set _visitID(String visitID) => visitID = visitID;
  DateTime get _visitTime => visitTime;
  set _visitTime(DateTime visitTime) => visitTime = visitTime;
  Map<String , LatLng> get _visitedLituation => lituationLocation;
  set _visitedLituation(Map<String , LatLng> visitedLituation) => visitedLituation = visitedLituation;
  List<String> get _verifications => verifications;
  set _verifications( List<String> verifications) => verifications = verifications;
  List<String> get _interactedVibes => interactedVibes;
  set _interactedVibes(List<String> interactedVibes) => interactedVibes = interactedVibes;


  UserLituationVisit.fromJson(Map<String, dynamic> json) {
    visitID = json['visitID'];
    visitTime = json['visitTime'];
    lituationLocation = json['visitedLituation'];
    verifications = json['verifications'];
    interactedVibes = json['interactedVibes'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitID'] = this.visitID;
    data['visitTime'] = this.visitTime;
    data['visitedLituation'] = this.lituationLocation;
    data['verifications'] = this.verifications;
    data['interactedVibes'] = this.interactedVibes;
    data['rating'] = this.rating;
    return data;
  }

}

class Invitation {
  String senderID;
  String recipient;
  String lituationID;
  String message;


  AddressModel(
      {
        String senderID,
        String recipient,
        String lituationID,
        String message,
      }) {
    this.senderID = senderID;
    this.recipient = recipient;
    this.lituationID = lituationID;
    this.message = message;
  }

  String get _senderID => senderID;
  set _senderID(String senderID) => senderID = senderID;
  String get _recipient => recipient;
  set _recipient(String recipient) => recipient = recipient;
  String get _lituationID => lituationID;
  set _address(String lituationID) => lituationID = lituationID;
  String get _message => message;
  set _message(String message) => message = message;

}

class AddressModel {
  String address;
  LatLng point;


  AddressModel(
      {String address,
        LatLng point,
      }) {
    this.address = address;
    this.point = point;
  }

  String get _address => address;
  set _address(String address) => address = address;
  LatLng get _point => point;
  set _point(LatLng point) => point = point;

}


class UserLituations {
  String _userID;
  List<String> _drafts;
  List<String> _lituations;
  List<String> _pastLituations;
  List<String> _upcomingLituations;
  List<String> _pendingLituations;
  List<String> _observedLituations;
  List<String> _recommendedLituations;
  List<String> _invitations;

  //Invitations are indicated by the sender id and lituation id, seperated by a colon.
  //e.g user_id:lituation_id



  UserLituations(
      { String userID,
        List<String> drafts,
        List<String> lituations,
        List<String> pastLituations,
        List<String> upcomingLituations,
        List<String> pendingLituations,
        List<String> observedLituations,
        List<String> recommendedLituations,
        List<String> invitations,
      }) {
    this._userID = userID;
    this._drafts = drafts;
    this._lituations = lituations;
    this._pastLituations = pastLituations;
    this._upcomingLituations = upcomingLituations;
    this._pendingLituations = pendingLituations;
    this._observedLituations = observedLituations;
    this._recommendedLituations = recommendedLituations;
    this._invitations = invitations;
  }

  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  List<String> get drafts => _drafts;
  set drafts(List<String> drafts) => _drafts = drafts;
  List<String> get lituations => _lituations;
  set lituations(List<String> lituations) => _lituations = lituations;
  List<String> get pastLituations => _pastLituations;
  set pastLituations(List<String> pastLituations) => _pastLituations = pastLituations;
  List<String> get upcomingLituations => _upcomingLituations;
  List<String> get pendingLituations => _pendingLituations;
  set upcomingLituations(List<String> upcomingLituations) => _upcomingLituations = upcomingLituations;
  set pendingLituations(List<String> pendingLituations) => _pendingLituations = pendingLituations;
  List<String> get observedLituations => _observedLituations;
  set observedLituations(List<String> observedLituations) => _observedLituations = observedLituations;
  List<String> get recommendedLituations => _recommendedLituations;
  set recommendedLituations(List<String> recommendedLituations) => _recommendedLituations = recommendedLituations;
  List<String> get invitations => _invitations;
  set invitations(List<String> invitations) => _invitations = invitations;

  UserLituations.fromJson(Map<String, dynamic> json) {
    _userID = json['userID'];
    _drafts = json['drafts'];
    _lituations = json['lituations'];
    _pastLituations = json['pastLituations'];
    _upcomingLituations = json['upcomingLituations'];
    _pendingLituations = json['pendingLituations'];
    _recommendedLituations = json['recommendedLituations'];
    _invitations = json['invitations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this._userID;
    data['drafts'] = this._drafts;
    data['lituations'] = this._lituations;
    data['pastLituations'] = this._pastLituations;
    data['upcomingLituations'] = this._upcomingLituations;
    data['pendingLituations'] = this._pendingLituations;
    data['observedLituations'] = this._observedLituations;
    data['recommendedLituations'] = this._recommendedLituations;
    data['invitations'] = this._invitations;
    return data;
  }

}

class LituationVisit{
  String userID;
  String lituationID;
  String lituationName;

  LituationVisit(
      {  String userID,
        String lituationID,
        String lituationName,
      }) {
    this.userID = userID;
    this.lituationID = lituationID;
    this.lituationName = lituationName;

  }

}

class UserVisit{
  String visitorID;
  String visitedID;
  String visitNote;

  UserVisit(
      {  String visitorID,
        String visitedID,
        String visitNote,
      }) {
    this.visitorID = visitorID;
    this.visitedID = visitedID;
    this.visitNote = visitNote;

  }

}