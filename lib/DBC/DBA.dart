import 'package:firebase_auth/firebase_auth.dart';
import 'package:lit_beta/Models/User.dart' as UserModel;
abstract class DBA{
  Future<String> signIn(String email , String password);
  Future<String> signUp(String email , String password);
  Future<User> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isVerified();
}