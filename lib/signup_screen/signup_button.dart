import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/cloud_functions.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({
    Key? key,
    required this.formKey,
    required this.userPasswordController,
    required this.userCfmPasswordController,
    required this.userEmailController,
    required this.displayNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.mounted,
    required this.gender,
    required this.phoneController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController? userPasswordController,
      userCfmPasswordController,
      userEmailController,
      displayNameController,
      firstNameController,
      lastNameController,
      phoneController;
  final bool mounted;
  final String gender;
  @override
  Widget build(BuildContext context) {

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
                    'first_name': firstNameController!.text,
                    'last_name': lastNameController!.text,
                    'phone': '65'+ phoneController!.text,
                    'gender': gender.toLowerCase()
                  });

              final jsonResponse = jsonDecode(response.body);
              print(jsonResponse);

              //TODO - Invstigate why the `makeCloudCall` method from lib/backend/cloud_functions.dart is erroneous
              // final response = makeCloudCall('createOrRetrieveCustomer', {
              //   'email': userEmailController!.text,
              //   'first_name': firstNameController!.text,
              //   'last_name': lastNameController!.text,
              //   'phone': phoneController!.texts
              // });

              launchURL(jsonResponse['accountUrl']);

              final usersCreateData = createUsersRecordData(
                  displayName: displayNameController!.text,
                  firstName: firstNameController!.text,
                  lastName: lastNameController!.text,
                  phoneNumber: phoneController!.text,
                  gender: gender,
                  stripeAccountID: jsonResponse['customer']);

              if (jsonResponse['success']) {
                final user = await createAccountWithEmail(
                  context,
                  userEmailController!.text,
                  userPasswordController!.text,
                );
                if (user == null) return;

                await UsersRecord.collection
                    .doc(user.uid)
                    .update(usersCreateData);

                context.goNamedAuth('JobBoardScreen', mounted);
              } else {
                print('FAILED STRIPE');
                return;
              }
            } catch (e) {
              if (e is StripeException)
                print('Stripe error: ${e.error.localizedMessage}');
              else
                print('Error: $e');
            }
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
