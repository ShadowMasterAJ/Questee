// ignore_for_file: non_constant_identifier_names

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../auth/auth_util.dart';
import '../backend/schema/users_record.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  TextEditingController? userEmailController;
  TextEditingController? userPasswordController;

  late bool userPasswordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userEmailController = TextEditingController();
    userPasswordController = TextEditingController();
    userPasswordVisibility = false;
  }

  @override
  void dispose() {
    userEmailController?.dispose();
    userPasswordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            alignment: AlignmentDirectional(0, -0.9),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                      child: Text(
                        'Sign in.',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          LoginEmail(context),
                          LoginPassword(context),
                        ],
                      ),
                    ),
                  ),
                  ForgotPasswordButton(),
                  LoginButton(
                      formKey: formKey,
                      userEmailController: userEmailController,
                      userPasswordController: userPasswordController,
                      mounted: mounted),
                  SwitchToSignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding LoginPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: TextFormField(
        controller: userPasswordController,
        obscureText: !userPasswordVisibility,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          hintStyle: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryText,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryText,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
          suffixIcon: InkWell(
            onTap: () => setState(
              () => userPasswordVisibility = !userPasswordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              userPasswordVisibility
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Color(0xFF757575),
              size: 22,
            ),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          }

          return null;
        },
      ),
    );
  }

  Padding LoginEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        controller: userEmailController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Username or Email',
          labelStyle: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          hintStyle: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryText,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryText,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
        style: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          }
          if (!val.contains('@') || !val.contains('.com')) {
            return null;
          } else if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}

class SwitchToSignUpButton extends StatelessWidget {
  const SwitchToSignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 100),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
            child: InkWell(
              onTap: () async {
                context.pushNamed(
                  'SignupScreen',
                  extra: <String, dynamic>{
                    kTransitionInfoKey: TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 300),
                    ),
                  },
                );
              },
              child: Text(
                'Sign up',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).tertiary400,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.formKey,
    required this.userEmailController,
    required this.userPasswordController,
    required this.mounted,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController? userEmailController;
  final TextEditingController? userPasswordController;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    late var usersCreateData;
    return Align(
      alignment: AlignmentDirectional(0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: FFButtonWidget(
          onPressed: () async {
            if (formKey.currentState == null ||
                !formKey.currentState!.validate()) {
              return;
            }

            GoRouter.of(context).prepareAuthEvent();
            final user = await signInWithEmail(
              context,
              userEmailController!.text,
              userPasswordController!.text,
            );
            if (user == null) return;
            try {
              //TODO - In the future implement the `makeCloudCall` method from lib/backend/cloud_functions.dart
              final response = await http.post(
                  Uri.parse(
                      'https://us-central1-ugrab-17ad6.cloudfunctions.net/createOrRetrieveCustomer'),
                  body: {
                    'email': userEmailController!.text,
                    'name': userEmailController!.text.split('@')[0]
                  });
              final jsonResponse = jsonDecode(response.body);
              print(jsonResponse);
              jsonResponse['stripeAccountExists']
                  ? debugPrint(
                      'STRIPE ACCOUNT EXISTS. Hence skipping updating firebase')
                  : await UsersRecord.collection
                      .doc(currentUserUid)
                      .update({'stripeAccountID': jsonResponse['customer']});
            } catch (e) {
              e is StripeException
                  ? print('Stripe error: ${e.error.localizedMessage}')
                  : print('Error: $e');
            }

            context.goNamedAuth('JobBoardScreen', mounted);
          },
          text: 'Login',
          options: FFButtonOptions(
            width: 270,
            height: 50,
            color: Color(0xFF96669E),
            textStyle: FlutterFlowTheme.of(context).subtitle1.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
            elevation: 2,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.8, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
        child: InkWell(
          onTap: () async {
            context.pushNamed(
              'forgotPasswordScreen',
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                ),
              },
            );
          },
          child: Text(
            'Forgot Password?',
            style: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}
