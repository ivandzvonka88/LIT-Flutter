import 'package:lit_beta/DBC/Auth.dart';

class FeedProvider{
  Auth db = Auth();
  final String userID;

  FeedProvider(this.userID);

  userStream() {
    return db.getUser(userID);
  }

}