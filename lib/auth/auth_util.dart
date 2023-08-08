import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../backend/backend.dart';
import 'package:stream_transform/stream_transform.dart';
import '../components/alert_dialog_box.dart';
import 'firebase_user_provider.dart';

export 'anonymous_auth.dart';
export 'apple_auth.dart';
export 'email_auth.dart';
export 'google_auth.dart';
export 'jwt_token_auth.dart';

/// Signs in or creates an account for the user using the provided [signInFunc]
/// and [authProvider]. If successful, returns a [User] object representing
/// the signed-in user. If an error occurs, an error alert dialog is shown
/// with the error message, and null is returned.
///
/// Parameters:
/// - [context]: The [BuildContext] in which to show the error alert dialog if needed.
/// - [signInFunc]: A function that performs the sign-in operation and returns a [UserCredential].
/// - [authProvider]: The authentication provider used for signing in.
///
/// Returns:
/// - A [Future<User?>] representing the signed-in user, or null if an error occurs.
///
/// Usage:
/// ```dart
/// final user = await signInOrCreateAccount(
///   context,
///   () async => await FirebaseAuth.instance.signInWithEmailAndPassword(email, password),
///   'email',
/// );
/// ```
Future<User?> signInOrCreateAccount(
  BuildContext context,
  Future<UserCredential?> Function() signInFunc,
  String authProvider,
) async {
  try {
    final userCredential = await signInFunc();
    if (userCredential?.user != null) {
      await maybeCreateUser(userCredential!.user!);
    }
    return userCredential?.user;
  } on FirebaseAuthException catch (e) {
    showAlertDialog(context, 'Error', 'Error: ${e.message!}');
    return null;
  }
}

/// Signs out the currently logged-in user and updates the JWT token.
///
/// Usage:
/// ```dart
/// signOut();
/// ```
Future signOut() {
  updateUserJwtTimer();
  return FirebaseAuth.instance.signOut();
}

/// Deletes the current user's account. If an error occurs, an error alert dialog
/// is shown with the appropriate error message.
///
/// Parameters:
/// - [context]: The [BuildContext] in which to show the error alert dialog if needed.
///
/// Usage:
/// ```dart
/// deleteUser(context);
/// ```
Future deleteUser(BuildContext context) async {
  try {
    if (currentUser?.user == null) {
      print('Error: delete user attempted with no logged in user!');
      return;
    }
    await currentUser?.user?.delete();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      showAlertDialog(context, 'Error',
          'Too long since most recent sign in. Sign in again before deleting your account.');
    }
  }
}

/// Sends a password reset email to the specified [email]. If an error occurs,
/// an error alert dialog is shown with the error message, and null is returned.
///
/// Parameters:
/// - [email]: The email address to which the password reset email will be sent.
/// - [context]: The [BuildContext] in which to show the error alert dialog if needed.
///
/// Usage:
/// ```dart
/// await resetPassword(email: 'user@example.com', context: context);
/// ```
Future resetPassword(
    {required String email, required BuildContext context}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    showAlertDialog(context, 'Error', 'Error: ${e.message!}');

    return null;
  }
  showAlertDialog(
      context, 'Done', 'Password reset email sent\nMake sure to check spam');
}

/// Sends an email verification to the current user's email address.
/// Requires the user to be logged in.
///
/// Usage:
/// ```dart
/// await sendEmailVerification();
/// ```
Future sendEmailVerification() async =>
    currentUser?.user?.sendEmailVerification();


/// Create a timer that periodically gets the current user's JWT Token,
/// since Firebase generates a new token every hour.
Timer? _jwtTimer;
String? _currentJwtToken;

/// Creates a timer that periodically gets the current user's JWT Token,
/// since Firebase generates a new token every hour. The JWT token is updated
/// immediately and then every hour based on the [currentUser].
///
/// Usage:
/// ```dart
/// updateUserJwtTimer(currentUser?.user);
/// ```
Future updateUserJwtTimer([User? user]) async {
  _jwtTimer?.cancel();
  // Clear the JWT token and return if the user is not logged in.
  if (user == null) {
    _currentJwtToken = null;
    return;
  }
  // Update the user's JWT token immediately and then every hour
  // based on the [currentUser].
  try {
    _currentJwtToken = await user.getIdToken();
    _jwtTimer = Timer.periodic(
      Duration(hours: 1),
      (_) async => _currentJwtToken = await currentUser?.user?.getIdToken(),
    );
  } catch (_) {}
}

// Set when using phone verification (after phone number is provided).
String? _phoneAuthVerificationCode;
// Set when using phone sign in in web mode (ignored otherwise).
ConfirmationResult? _webPhoneAuthConfirmationResult;

/// Begins the phone authentication process for the specified [phoneNumber].
/// Depending on the platform, this method uses either the web phone sign-in or
/// the SMS verification process. After initiating the process, the [onCodeSent]
/// callback will be called.
///
/// Parameters:
/// - [context]: The [BuildContext] in which to show the error snackbar if needed.
/// - [phoneNumber]: The phone number to be verified.
/// - [onCodeSent]: A callback that will be called when the code is sent to the user's phone.
///
/// Usage:
/// ```dart
/// beginPhoneAuth(context: context, phoneNumber: '+1234567890', onCodeSent: () {});
/// ```
Future beginPhoneAuth({
  required BuildContext context,
  required String phoneNumber,
  required VoidCallback onCodeSent,
}) async {
  if (kIsWeb) {
    _webPhoneAuthConfirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
    onCodeSent();
    return;
  }
  // If you'd like auto-verification, without the user having to enter the SMS
  // code manually. Follow these instructions:
  // * For Android: https://firebase.google.com/docs/auth/android/phone-auth?authuser=0#enable-app-verification (SafetyNet set up)
  // * For iOS: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0#start-receiving-silent-notifications
  // * Finally modify verificationCompleted below as instructed.
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: Duration(seconds: 5),
    verificationCompleted: (phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      // If you've implemented auto-verification, navigate to home page or
      // onboarding page here manually. Uncomment the lines below and replace
      // DestinationPage() with the desired widget.
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => DestinationPage()),
      // );
    },
    verificationFailed: (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message!}'),
      ));
    },
    codeSent: (verificationId, _) {
      _phoneAuthVerificationCode = verificationId;
      onCodeSent();
    },
    codeAutoRetrievalTimeout: (_) {},
  );
}

/// Verifies the SMS code for phone authentication. This method is used after the
/// user receives the SMS code and enters it to complete the phone authentication process.
/// Depending on the platform, this method uses either the web phone sign-in or
/// the SMS verification process.
///
/// Parameters:
/// - [context]: The [BuildContext] in which to show the error alert dialog if needed.
/// - [smsCode]: The SMS code entered by the user.
///
/// Usage:
/// ```dart
/// await verifySmsCode(context: context, smsCode: '123456');
/// ```
Future verifySmsCode({
  required BuildContext context,
  required String smsCode,
}) async {
  if (kIsWeb) {
    return signInOrCreateAccount(
      context,
      () => _webPhoneAuthConfirmationResult!.confirm(smsCode),
      'PHONE',
    );
  } else {
    final authCredential = PhoneAuthProvider.credential(
        verificationId: _phoneAuthVerificationCode!, smsCode: smsCode);
    return signInOrCreateAccount(
      context,
      () => FirebaseAuth.instance.signInWithCredential(authCredential),
      'PHONE',
    );
  }
}


String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.user?.email ?? '';
String get currentUserUid => currentUser?.user?.uid ?? '';
String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.user?.displayName ?? '';
String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.user?.photoURL ?? '';
String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.user?.phoneNumber ?? '';
String get currentUserStripeAcc => currentUserDocument?.stripeAccountID ?? '';
bool get currentUserStripeVerifiedStatus =>
    currentUserDocument?.stripeVerified ?? false;
String get currentJwtToken => _currentJwtToken ?? '';

List<DocumentReference<Object?>>? get currentUserCurrJobsAccepted =>
    currentUserDocument?.currJobsAccepted?.asList();
List<DocumentReference<Object?>>? get currentUserCurrJobsPosted =>
    currentUserDocument?.currJobsPosted?.asList();
List<DocumentReference<Object?>>? get currentUserPastJobsAccepted =>
    currentUserDocument?.pastJobsAccepted?.asList();
List<DocumentReference<Object?>>? get currentUserPastJobsPosted =>
    currentUserDocument?.pastJobsPosted?.asList();

bool get currentUserEmailVerified {
  // Reloads the user when checking in order to get the most up to date
  // email verified status.
  if (currentUser?.user != null && !currentUser!.user!.emailVerified) {
    currentUser!.user!
        .reload()
        .then((_) => currentUser!.user = FirebaseAuth.instance.currentUser);
  }
  return currentUser?.user?.emailVerified ?? false;
}

DocumentReference? get currentUserReference => currentUser?.user != null
    ? UsersRecord.collection.doc(currentUser!.user!.uid)
    : null;

UsersRecord? currentUserDocument;

/// A stream that provides the authenticated user's UID when there is an authentication state change.
/// It maps the user UID to an empty string if the user is not authenticated.
/// Then it switches to another stream based on the UID value:
/// - If the UID is empty, it emits a stream with a value of `null`.
/// - If the UID is not empty, it fetches the user document using the `UsersRecord.getDocument()` method based on the UID.
///   If an error occurs during the document retrieval, it is handled silently.
/// The resulting stream maps the user document to the `currentUserDocument` variable,
/// and the stream is broadcasted to multiple listeners.

// Step 1: Create a stream that listens for changes in the authentication state.
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    // Step 2: Map the user object to the user's UID or an empty string.
    .map<String>((user) => user?.uid ?? '')
    // Step 3: Switch to another stream based on the UID value.
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(
              null) // Emit a stream with a value of `null` if the UID is empty.
          : UsersRecord.getDocument(UsersRecord.collection.doc(uid))
              .handleError((_) {}),
    )
    // Step 4: Map the user document to the `currentUserDocument` variable.
    .map((user) => currentUserDocument = user)
    // Step 5: Broadcast the stream to multiple listeners.
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => child,
      );
}
