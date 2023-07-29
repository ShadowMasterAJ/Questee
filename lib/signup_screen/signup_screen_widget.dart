// ignore_for_file: non_constant_identifier_names

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'signup_button.dart';

class SignupScreenWidget extends StatefulWidget {
  const SignupScreenWidget({Key? key}) : super(key: key);

  @override
  _SignupScreenWidgetState createState() => _SignupScreenWidgetState();
}

class _SignupScreenWidgetState extends State<SignupScreenWidget> {
  TextEditingController? userCfmPasswordController;

  late bool userCfmPasswordVisibility;
  TextEditingController? userEmailController,
      displayNameController,
      userPasswordController,
      firstNameController,
      lastNameController,
      phoneController;
  String gender = '';
  late bool userPasswordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userCfmPasswordController = TextEditingController();
    userCfmPasswordVisibility = false;
    userEmailController = TextEditingController();
    userPasswordController = TextEditingController();
    displayNameController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    userPasswordController = TextEditingController();
    userPasswordVisibility = false;
  }

  @override
  void dispose() {
    userCfmPasswordController?.dispose();
    userEmailController?.dispose();
    firstNameController?.dispose();
    lastNameController?.dispose();
    displayNameController?.dispose();
    phoneController?.dispose();
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
                          NameField(
                              context,
                              displayNameController,
                              'Display Name',
                              EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16)),
                          Row(
                            children: [
                              Expanded(
                                  child: NameField(
                                      context,
                                      firstNameController,
                                      'First Name',
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 5, 16))),
                              Expanded(
                                  child: NameField(
                                      context,
                                      lastNameController,
                                      'Last Name',
                                      EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 20, 16))),
                            ],
                          ),
                          Container(
                            height: 80,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: PhoneNumberField(
                                      context,
                                      phoneController,
                                      'Phone Number',
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 10, 16)),
                                ),
                                Flexible(
                                    flex: 2,
                                    child: GenderField(
                                        context,
                                        (val) =>
                                            setState(() => gender = val!))),
                              ],
                            ),
                          ),
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
                      displayNameController: displayNameController,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      gender: gender,
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
          if (userPasswordController?.text != val)
            return 'The passwords need to match';

          return null;
        },
      ),
    );
  }

  Padding PwdField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        controller: userPasswordController,
        obscureText: !userPasswordVisibility,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
          if (val == null || val.isEmpty) return 'Field is required';
          if (val.length < 6) return 'Requires at least 6 characters.';

          return null;
        },
      ),
    );
  }

  Padding EmailField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        controller: userEmailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: false,
        decoration: FieldDecoration(context, labelText: 'Email'),
        style: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Field is required';

          if (!RegExp(kTextValidatorEmailRegex).hasMatch(val))
            return 'Has to be a valid email address.';

          return null;
        },
      ),
    );
  }

  Padding NameField(BuildContext context, TextEditingController? textController,
      String labelText, EdgeInsetsDirectional padding) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: FieldDecoration(context, labelText: labelText),
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

  Padding PhoneNumberField(
      BuildContext context,
      TextEditingController? textController,
      String labelText,
      EdgeInsetsDirectional padding) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController,
        keyboardType:
            TextInputType.phone, // Set the keyboard type to phone number.
        autovalidateMode: AutovalidateMode.onUserInteraction,

        decoration: FieldDecoration(context, labelText: labelText),
        style: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Field is required';

          if (val.length != 8) return 'Number must have 8 digits';

          return null;
        },
      ),
    );
  }

  Padding GenderField(BuildContext context, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 20, 16),
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(15),
        enableFeedback: true,
        elevation: 0,
        hint: Text(
          'Gender',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        decoration: FieldDecoration(context, labelText: ''),
        items: [
          'Male',
          'Female',
        ].map((gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Center(
              child: Text(
                gender,
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Please select\na gender';

          return null;
        },
        dropdownColor: FlutterFlowTheme.of(context).primaryBackgroundLight,
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
