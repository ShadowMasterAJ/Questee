import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_util.dart';

class QuesteeFirebaseUser {
  QuesteeFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

QuesteeFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;

Stream<QuesteeFirebaseUser> questeeFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<QuesteeFirebaseUser>(
      (user) {
        currentUser = QuesteeFirebaseUser(user);
        updateUserJwtTimer(user);
        return currentUser!;
      },
    );
