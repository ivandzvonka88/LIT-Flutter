class Vibed {
  String _userID;
  String _vibedCount;
  List<String> _vibed;
  List<String> _pendingVibes;


  Vibed(
      {String userID,
        String vibedCount,
        List<String> vibed,
        List<String> pendingVibes,
      }) {
    this._userID = userID;
    this._vibedCount = vibedCount;
    this._vibed = vibed;
    this._pendingVibes = pendingVibes;
  }

  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get vibedCount => _vibedCount;
  set vibedCount(String vibedCount) => _vibedCount = vibedCount;
  List<String> get vibed => _vibed;
  set vibed(List<String> vibed) => _vibed = vibed;
  List<String> get pendingVibes => _pendingVibes;
  set pendingVibes(List<String> pendingVibes) => _pendingVibes = pendingVibes;

  Vibed.fromJson(Map<String, dynamic> json) {
    _userID = json['userID'];
    _vibedCount = json['vibedCount'];
    _vibed = json['vibed'];
    _pendingVibes = json['pendingVibes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this._userID;
    data['vibedCount'] = this._vibedCount;
    data['vibed'] = this._vibed;
    data['pendingVibes'] = this._pendingVibes;
    return data;
  }
}

class Vibing {
  String _userID;
  String _vibingCount;
  List<String> _vibing;
  List<String> _pendingVibing;


  Vibing(
      {String userID,
        String vibedCount,
        List<String> vibing,
        List<String> pendingVibing,
      }) {
    this._userID = userID;
    this._vibingCount = vibedCount;
    this._vibing = vibing;
    this._pendingVibing = pendingVibing;
  }

  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get vibingCount => _vibingCount;
  set vibingCount(String vibingCount) => _vibingCount = vibingCount;
  List<String> get vibing => _vibing;
  set vibing(List<String> vibing) => _vibing = vibing;
  List<String> get pendingVibing => _pendingVibing;
  set pendingVibing(List<String> pendingVibing) => _pendingVibing = pendingVibing;

  Vibing.fromJson(Map<String, dynamic> json) {
    _userID = json['userID'];
    _vibingCount = json['vibingCount'];
    _vibing = json['vibing'];
    _pendingVibing = json['pendingVibing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this._userID;
    data['vibingCount'] = this._vibingCount;
    data['vibing'] = this._vibing;
    data['pendingVibing'] = this._pendingVibing;
    return data;
  }

}
