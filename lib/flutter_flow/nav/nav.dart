import 'dart:async';

// TODO : remove every aspect that is flutterflow

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import '../flutter_flow_theme.dart';
import '../../backend/backend.dart';
import '../../auth/firebase_user_provider.dart';

import '../../index.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  QuesteeFirebaseUser? initialUser;
  QuesteeFirebaseUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(QuesteeFirebaseUser newUser) {
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    if (notifyOnAuthChange) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, _) => appStateNotifier.loggedIn
          ? JobBoardScreenWidget()
          : LoginScreenWidget(),
      routes: <GoRoute>[
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? JobBoardScreenWidget()
              : LoginScreenWidget(),
          routes: [
            FFRoute(
              name: 'AuthScreen',
              path: 'authScreen',
              builder: (context, params) => LoginScreenWidget(),
            ),
            FFRoute(
              name: 'JobBoardScreen',
              path: 'jobBoardScreen',
              builder: (context, params) => JobBoardScreenWidget(),
            ),
            FFRoute(
              name: 'JobHistoryScreen',
              path: 'jobHistoryScreen',
              builder: (context, params) => JobHistoryScreenWidget(),
            ),
            FFRoute(
              name: 'SignupScreen',
              path: 'signupScreen',
              builder: (context, params) => SignupScreenWidget(),
            ),
            FFRoute(
              name: 'editProfileScreen',
              path: 'editProfileScreen',
              builder: (context, params) => EditProfileScreenWidget(),
            ),
            FFRoute(
              name: 'createJobScreen',
              path: 'createJobScreen',
              builder: (context, params) => CreateJobScreenWidget(),
            ),
            FFRoute(
              name: 'editJobScreen',
              path: 'editJobScreen',
              builder: (context, params) => EditJobScreenWidget(),
            ),
            FFRoute(
                name: 'JobDetailScreenPoster',
                path: 'jobDetailScreenPoster',
                asyncParams: {
                  'jobDoc': getDoc('job', JobRecord.serializer),
                },
                builder: (context, params) {
                  return JobDetailScreenPosterWidget(
                      jobRef: params.getParam(
                          'jobRef', ParamType.DocumentReference));
                }),
            FFRoute(
              name: 'JobDetailScreenAcceptor',
              path: 'jobDetailScreenAcceptor',
              builder: (context, params) => JobDetailScreenAcceptorWidget(
                  jobRef:
                      params.getParam('jobRef', ParamType.DocumentReference)),
            ),
            FFRoute(
              name: 'forgotPasswordScreen',
              path: 'forgotPasswordScreen',
              builder: (context, params) => ForgotPasswordScreenWidget(),
            ),
            FFRoute(
              name: 'posterPaymentScreen',
              path: 'posterPaymentScreen',
              builder: (context, params) => PosterPaymentScreenWidget(),
            ),
            FFRoute(
              name: 'ChatScreen',
              path: 'chatScreen',
              asyncParams: {
                'chatUser': getDoc('users', UsersRecord.serializer),
              },
              builder: (context, params) => ChatScreenWidget(
                jobRef: params.getParam(
                    'jobRef', ParamType.DocumentReference, false, 'job'),
                // chatRef: params.getParam(
                //     'chatRef', ParamType.DocumentReference, false, 'chats'),
                // chatUser: params.getParam('chatUser', ParamType.Document),
              ),
            ),
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ).toRoute(appStateNotifier),
      ],
      urlPathStrategy: UrlPathStrategy.path,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              params: params,
              queryParams: queryParams,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              params: params,
              queryParams: queryParams,
              extra: extra,
            );
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState =>
      (routerDelegate.refreshListenable as AppStateNotifier);
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void setRedirectLocationIfUnset(String location) =>
      (routerDelegate.refreshListenable as AppStateNotifier)
          .updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(params)
    ..addAll(queryParams)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

/// FFParameters class manages and provides access to the parameters passed through GoRouterState.
class FFParameters {
  /// Constructs an instance of FFParameters with the given [state] and optional [asyncParams].
  /// [state]: The GoRouterState that contains the parameters.
  /// [asyncParams]: A map of parameter names to functions that return Future<dynamic> for async parameter values.
  FFParameters(this.state, [this.asyncParams = const {}]);

  /// The GoRouterState that contains the parameters.
  final GoRouterState state;

  /// A map of parameter names to functions that return Future<dynamic> for async parameter values.
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  /// Map to store the resolved future parameter values for optimization purposes.
  Map<String, dynamic> futureParamValues = {};

  /// Checks if the parameters are empty.
  ///
  /// Parameters are considered empty if the params map is empty or if the only parameter
  /// present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));

  /// Checks if a specific parameter is an async parameter.
  ///
  /// * [param]: The parameter to check.
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;

  /// Checks if there are any parameters that are async (Future) types.
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);

  /// Completes all the async (Future) parameters by executing their corresponding Future functions.
  ///
  /// Returns a Future<bool> indicating whether all the async parameter futures were completed successfully.
  /// If any of the async futures fails, it returns false.
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  /// Retrieves the parameter value with the specified type.
  ///
  /// * [paramName]: The name of the parameter to retrieve.
  /// * [type]: The expected type of the parameter.
  /// * [isList]: A flag to indicate if the parameter is a List type (default is false).
  /// * [collectionName]: The name of the collection (only used for some types).
  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    String? collectionName,
  ]) {
    if (futureParamValues.containsKey(paramName))
      return futureParamValues[paramName];

    if (!state.allParams.containsKey(paramName)) return null;

    final param = state.allParams[paramName];
    // Got the parameter from `extras`, so just directly return it.
    if (param is! String) return param;

    // Return serialized value.
    return deserializeParam<T>(param, type, isList, collectionName);
  }
}

/// FFRoute represents a FlutterFlow route that can be navigated within the app.
class FFRoute {
  /// Constructs an instance of FFRoute with the given properties.
  ///
  /// * `[name]`: The name of the route.
  /// * `[path]`: The path of the route used for routing.
  /// * `[builder]`: The builder function that returns the widget to be rendered for this route.
  /// * `[requireAuth]`: A flag indicating if this route requires authentication (default is false).
  /// * `[asyncParams]`: A map of parameter names to functions that return Future<dynamic> for async parameter values.
  /// * `[routes]`: A list of GoRoute instances representing sub-routes under this route.
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  /// The name of the route.
  final String name;

  /// The path of the route used for routing.
  final String path;

  /// A flag indicating if this route requires authentication.
  final bool requireAuth;

  /// A map of parameter names to functions that return Future<dynamic> for async parameter values.
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  /// The builder function that returns the widget to be rendered for this route.
  final Widget Function(BuildContext, FFParameters) builder;

  /// A list of GoRoute instances representing sub-routes under this route.
  final List<GoRoute> routes;

  /// Converts the FFRoute to a GoRoute to integrate with GoRouter.
  ///
  /// * [appStateNotifier]: The app state notifier to manage app-level state and authentication.
  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.location);
            return '/authScreen';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);

          // Show a loading indicator or the actual page based on appStateNotifier.loading value.
          final child = appStateNotifier.loading
              ? Container(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Screenshot_2022-09-29_at_23.11.14.png',
                      width: 150,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;

          // Wrap the page with a custom transition if needed, otherwise use a MaterialPage.
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: true);
}
