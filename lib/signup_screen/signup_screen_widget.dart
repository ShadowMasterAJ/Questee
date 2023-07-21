// ignore_for_file: non_constant_identifier_names

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class SignupScreenWidget extends StatefulWidget {
  const SignupScreenWidget({Key? key}) : super(key: key);

  @override
  _SignupScreenWidgetState createState() => _SignupScreenWidgetState();
}

class _SignupScreenWidgetState extends State<SignupScreenWidget> {
  TextEditingController? userCfmPasswordController;

  late bool userCfmPasswordVisibility;
  TextEditingController? userEmailController;
  TextEditingController? userNameController;
  TextEditingController? userPasswordController;

  late bool userPasswordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userCfmPasswordController = TextEditingController();
    userCfmPasswordVisibility = false;
    userEmailController = TextEditingController();
    userNameController = TextEditingController();
    userPasswordController = TextEditingController();
    userPasswordVisibility = false;
  }

  @override
  void dispose() {
    userCfmPasswordController?.dispose();
    userEmailController?.dispose();
    userNameController?.dispose();
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
              shape: BoxShape.rectangle,
            ),
            alignment: AlignmentDirectional(0, -1),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                      child: Text(
                        'Sign up.',
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
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          UsernameField(context),
                          EmailField(context),
                          PwdField(context),
                          CfmPwdField(context),
                        ],
                      ),
                    ),
                  ),
                  SignupButton(
                      formKey: formKey,
                      userPasswordController: userPasswordController,
                      userCfmPasswordController: userCfmPasswordController,
                      userEmailController: userEmailController,
                      userNameController: userNameController,
                      mounted: mounted),
                  SwitchToSignIn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row SwitchToSignIn(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
        FFButtonWidget(
          onPressed: () async {
            context.pushNamed(
              'AuthScreen',
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.leftToRight,
                  duration: Duration(milliseconds: 300),
                ),
              },
            );
          },
          text: 'Sign in',
          options: FFButtonOptions(
            width: 78,
            height: 30,
            color: Color(0x0096669E),
            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).secondaryColor,
                  fontSize: 14,
                ),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Padding CfmPwdField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        controller: userCfmPasswordController,
        obscureText: !userCfmPasswordVisibility,
        decoration: FieldDecoration(
          context,
          labelText: 'Retype Password',
          onTap: () => setState(
            () => userCfmPasswordVisibility = !userCfmPasswordVisibility,
          ),
          icon: Icon(
            userCfmPasswordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: userCfmPasswordVisibility
                ? FlutterFlowTheme.of(context).primaryColorLight
                : FlutterFlowTheme.of(context).primaryColor,
            size: userCfmPasswordVisibility ? 26 : 22,
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

          if (val.length < 6) {
            return 'Requires at least 6 characters.';
          }

          return null;
        },
      ),
    );
  }

  Align PwdField(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
        child: TextFormField(
          controller: userPasswordController,
          obscureText: !userPasswordVisibility,
          decoration: FieldDecoration(context,
              labelText: 'Password',
              onTap: () => setState(
                  () => userPasswordVisibility = !userPasswordVisibility),
              icon: Icon(
                userPasswordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: userPasswordVisibility
                    ? FlutterFlowTheme.of(context).primaryColorLight
                    : FlutterFlowTheme.of(context).primaryColor,
                size: userPasswordVisibility ? 26 : 22,
              )),
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

            if (val.length < 6) {
              return 'Requires at least 6 characters.';
            }

            return null;
          },
        ),
      ),
    );
  }

  Align EmailField(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.3, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
        child: TextFormField(
          controller: userEmailController,
          obscureText: false,
          decoration: FieldDecoration(context, labelText: 'Email'),
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
            if (val.contains('cock')) {
              return "No cocks pls";
            }
            if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
              return 'Has to be a valid email address.';
            }
            return null;
          },
        ),
      ),
    );
  }

  Padding UsernameField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        controller: userNameController,
        obscureText: false,
        decoration: FieldDecoration(context, labelText: 'Username'),
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

  InputDecoration FieldDecoration(
    BuildContext context, {
    required String labelText,
    VoidCallback? onTap,
    Icon? icon,
  }) {
    return InputDecoration(
      labelText: labelText,
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
          color: FlutterFlowTheme.of(context).alternate,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
      suffixIcon: icon != null
          ? InkWell(
              onTap: onTap,
              focusNode: FocusNode(skipTraversal: true),
              child: icon)
          : null,
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
    Key? key,
    required this.formKey,
    required this.userPasswordController,
    required this.userCfmPasswordController,
    required this.userEmailController,
    required this.userNameController,
    required this.mounted,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController? userPasswordController;
  final TextEditingController? userCfmPasswordController;
  final TextEditingController? userEmailController;
  final TextEditingController? userNameController;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    late var usersCreateData;

    return Align(
      alignment: AlignmentDirectional(0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
        child: FFButtonWidget(
          onPressed: () async {
            if (formKey.currentState == null ||
                !formKey.currentState!.validate()) {
              return;
            }

            GoRouter.of(context).prepareAuthEvent();
            if (userPasswordController?.text !=
                userCfmPasswordController?.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Passwords don\'t match!',
                  ),
                ),
              );
              return;
            }
            try {
              final response = await http.post(
                  Uri.parse(
                      'https://us-central1-ugrab-17ad6.cloudfunctions.net/createOrRetrieveCustomer'),
                  body: {
                    'email': userEmailController!.text,
                    'name': userNameController!.text
                  });
              final jsonResponse = jsonDecode(response.body);
              print(jsonResponse);
              usersCreateData = createUsersRecordData(
                  displayName: userNameController!.text,
                  stripeAccountID: jsonResponse['customer']);
            } catch (e) {
              if (e is StripeException)
                print('Stripe error: ${e.error.localizedMessage}');
              else
                print('Error: $e');
            }
            final user = await createAccountWithEmail(
              context,
              userEmailController!.text,
              userPasswordController!.text,
            );
            if (user == null) return;

            //TODO - Add gender, phone number fields to signup etc (other attributes)
            await UsersRecord.collection.doc(user.uid).update(usersCreateData);

            context.goNamedAuth('JobBoardScreen', mounted);
          },
          text: 'Signup',
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
