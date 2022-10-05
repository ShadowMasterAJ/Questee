import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_util.dart';

class UGrabv1FirebaseUser {
  UGrabv1FirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

UGrabv1FirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<UGrabv1FirebaseUser> uGrabv1FirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<UGrabv1FirebaseUser>(
      (user) {
        currentUser = UGrabv1FirebaseUser(user);
        updateUserJwtTimer(user);
        return currentUser!;
      },
    );
