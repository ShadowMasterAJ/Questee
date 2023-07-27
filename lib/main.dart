import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_user_provider.dart';
import 'auth/auth_util.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase.
  await FlutterFlowTheme.initialize(); // Initialize FlutterFlowTheme.
  FFAppState(); // Initialize FFAppState
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale; // Holds the current app's locale for localization.
  ThemeMode _themeMode =
      FlutterFlowTheme.themeMode; // Holds the current theme mode.

  late Stream<QuesteeFirebaseUser>
      userStream; // Stream to listen to Firebase user changes.

  late AppStateNotifier _appStateNotifier; // Notifier for app state changes.
  late GoRouter _router; // Router for navigation.

  final authUserSub = authenticatedUserStream
      .listen((_) {}); // Subscription to user authentication changes.

  @override
  void initState() {
    super.initState();
    // Initialize app state notifier and router.
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);
    // Listen to Firebase user changes and update the app state notifier accordingly.
    userStream = QuesteeFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    // After 1 second delay, stop showing the splash image.
    Future.delayed(
      Duration(seconds: 1),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub
        .cancel(); // Cancel the user authentication stream subscription to prevent memory leaks.
    super.dispose();
  }

  // Sets the app's locale for internationalization.
  void setLocale(String language) =>
      setState(() => _locale = createLocale(language));

  // Sets the theme mode for the app.
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Questee',
      localizationsDelegates: [
        FFLocalizationsDelegate(), // FlutterFlow Localizations delegate.
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale, // Set the current locale for localization.
      supportedLocales: const [
        Locale('en', '')
      ], // Supported locales for the app.
      theme: ThemeData(brightness: Brightness.light), // Light theme.
      darkTheme: ThemeData(brightness: Brightness.dark), // Dark theme.
      themeMode: _themeMode, // Set the theme mode based on the current value.
      routeInformationParser: _router
          .routeInformationParser, // Parse route information for the router.
      routerDelegate: _router
          .routerDelegate, // Handle routing and navigation using the router.
    );
  }
}
