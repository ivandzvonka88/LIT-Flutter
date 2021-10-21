import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Lituation {
  String _capacity;
  DateTime _date;
  DateTime _end_date;
  DateTime _dateCreated;
  String _description;
  String _title;
  String _entry;
  String _eventID;
  String _hostID;
  String _fee;
  String _location;
  LatLng _locationLatLng;
  List<String> _musicGenres;
  List<String> _requirements;
  String _themes;
  String _status;
  int _clout;
  List<String> _specialGuests;
  List<String> _observers;
  List<String> _invited;
  List<String> _vibes;
  List<String> _pending;
  List<String> _thumbnailURLs;

  Lituation({
    String capacity,
    DateTime date,
    DateTime end_date,
    DateTime dateCreated,
    String description,
    String title,
    String entry,
    String eventID,
    String hostID,
    String fee,
    String location,
    LatLng locationLatLng,
    List<String> musicGenres,
    List<String> requirements,
    String themes,
    String status,
    int clout,
    List<String> specialGuests,
    List<String> observers,
    List<String> vibes,
    List<String> invited,
    List<String> pending,
    List<String> thumbnailURLs,
  }) {
    this._capacity = capacity;
    this._date = date;
    this._end_date = end_date;
    this._dateCreated = dateCreated;
    this._description = description;
    this._title = title;
    this._entry = entry;
    this._eventID = eventID;
    this._hostID = hostID;
    this._fee = fee;
    this._location = location;
    this._locationLatLng = locationLatLng;
    this._status = status;
    this._musicGenres = musicGenres;
    this._requirements = requirements;
    this._themes = themes;
    this._clout = clout;
    this._specialGuests = specialGuests;
    this._observers = observers;
    this._vibes = vibes;
    this._invited = invited;
    this._thumbnailURLs = thumbnailURLs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['capacity'] = this._capacity;
    data['date'] = Timestamp.fromDate(this._date);
    data['end_date'] = Timestamp.fromDate(this._end_date);
    data['dateCreated'] = Timestamp.fromDate(this._dateCreated);
    data['description'] = this._description;
    data['title'] = this._title;
    data['entry'] = this._entry;
    data['hostID'] = this._hostID;
    data['eventID'] = this._eventID;
    data['status'] = this._status;
    data['fee'] = this._fee;
    data['clout'] = this._clout;
    data['location'] = this._location;
    data['locationLatLng'] =
        GeoPoint(this._locationLatLng.latitude, this._locationLatLng.longitude);
    data['musicGenres'] = this._musicGenres;
    data['requirements'] = this._requirements;
    data['themes'] = this._themes;
    data['specialGuests'] = this._specialGuests;
    data['observers'] = this._observers;
    data['vibes'] = this._vibes;
    data['invited'] = this._invited;
    data['pending'] = this._pending;
    data['thumbnail'] = this._thumbnailURLs;

    return data;
  }


  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  DateTime get dateCreated => _dateCreated;
  DateTime get end_date => _end_date;
  set dateCreated(DateTime value) {
    _dateCreated = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  LatLng get locationLatLng => _locationLatLng;

  set locationLatLng(LatLng value) {
    _locationLatLng = value;
  }

  set end_date(DateTime value) {
    _end_date = value;
  }

  String get capacity => _capacity;

  set capacity(String value) {
    _capacity = value;
  }

  String get entry => _entry;

  set entry(String value) {
    _entry = value;
  }

  String get eventID => _eventID;

  set eventID(String value) {
    _eventID = value;
  }

  String get hostID => _hostID;

  set hostID(String value) {
    _hostID = value;
  }

  int get clout => _clout;

  set clout(int value) {
    _clout = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  List<String> get musicGenres => _musicGenres;

  set musicGenres(List<String> value) {
    _musicGenres = value;
  }

  List<String> get requirements => _requirements;

  set requirements(List<String> value) {
    _requirements = value;
  }

  String get themes => _themes;

  set themes(String value) {
    _themes = value;
  }

  String get fee => _fee;

  set fee(String value) {
    _fee = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  List<String> get specialGuests => _specialGuests;

  set specialGuests(List<String> value) {
    _specialGuests = value;
  }

  List<String> get vibes => _vibes;
  List<String> get invited => _invited;

  set vibes(List<String> value) {
    _vibes = value;
  }

  set invited(List<String> value) {
    _invited = value;
  }
  List<String> get thumbnailURLs => _thumbnailURLs;

  set thumbnailURLs(List<String> value) {
    _thumbnailURLs = value;
  }

  List<String> get observers => _observers;

  set observers(List<String> value) {
    _observers = value;
  }

  List<String> get pending => _pending;

  set pending(List<String> value) {
    _pending = value;
  }
}
