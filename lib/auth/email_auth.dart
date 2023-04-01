import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_util.dart';

// This function signs in a user with email and password using Firebase Authentication.
// It takes the email and password as parameters, and returns a Future that resolves to a User object.
Future<User?> signInWithEmail(
    BuildContext context, String email, String password) async {
  // Create a function that signs in a user with email and password using Firebase Authentication.
  // This function will be used later to actually sign in the user.
  final signInFunc = () => FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email.trim(), password: password);

  // Call the signInOrCreateAccount function to sign in or create an account for the user.
  // Pass in the context, the signInFunc, and the authentication method ('EMAIL') as parameters.
  return signInOrCreateAccount(context, signInFunc, 'EMAIL');
}

// This function creates a new user account with email and password using Firebase Authentication.
// It takes the email and password as parameters, and returns a Future that resolves to a User object.
Future<User?> createAccountWithEmail(
    BuildContext context, String email, String password) async {
  // Create a function that creates a new user account with email and password using Firebase Authentication.
  // This function will be used later to actually create the account for the user.
  final createAccountFunc = () => FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email.trim(), password: password);

  // Call the signInOrCreateAccount function to sign in or create an account for the user.
  // Pass in the context, the createAccountFunc, and the authentication method ('EMAIL') as parameters.
  return signInOrCreateAccount(context, createAccountFunc, 'EMAIL');
}
