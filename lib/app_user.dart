import 'package:firebase_auth/firebase_auth.dart';

// @todo Find a better way to "share" the current user across widget tree.
class AppUser {
  static FirebaseUser currentUser;
}