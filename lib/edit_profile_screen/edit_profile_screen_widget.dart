import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/firebase_storage/storage.dart';
import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import 'package:flutter/material.dart';

class EditProfileScreenWidget extends StatefulWidget {
  const EditProfileScreenWidget({Key? key}) : super(key: key);

  @override
  _EditProfileScreenWidgetState createState() =>
      _EditProfileScreenWidgetState();
}

class _EditProfileScreenWidgetState extends State<EditProfileScreenWidget> {
  bool isMediaUploading = false;
  String uploadedFileUrl = '';

  TextEditingController? yourNameController;
  TextEditingController? useEmailController;
  TextEditingController? genderController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    genderController = TextEditingController(
        text: valueOrDefault(currentUserDocument?.gender, ''));
    useEmailController = TextEditingController(text: currentUserEmail);
    yourNameController = TextEditingController(text: currentUserDisplayName);
  }

  @override
  void dispose() {
    genderController?.dispose();
    useEmailController?.dispose();
    yourNameController?.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 26, 30, 12),
                        child: Text(
                          'Edit Profile.',
                          style: FlutterFlowTheme.of(context).title1.override(
                                fontFamily: 'Poppins',
                                fontSize: 36,
                              ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFDBE2E7),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                              child: Container(
                                width: 90,
                                height: 90,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/images/questee.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                final selectedMedia = await selectMedia(
                                  mediaSource: MediaSource.photoGallery,
                                  multiImage: false,
                                );
                                if (selectedMedia != null &&
                                    selectedMedia.every((m) =>
                                        validateFileFormat(
                                            m.storagePath, context))) {
                                  setState(() => isMediaUploading = true);
                                  var downloadUrls = <String>[];
                                  try {
                                    showUploadMessage(
                                      context,
                                      'Uploading file...',
                                      showLoading: true,
                                    );
                                    downloadUrls = (await Future.wait(
                                      selectedMedia.map(
                                        (m) async => await uploadData(
                                            m.storagePath, m.bytes),
                                      ),
                                    ))
                                        .where((u) => u != null)
                                        .map((u) => u!)
                                        .toList();
                                  } finally {
                                    isMediaUploading = false;
                                  }
                                  if (downloadUrls.length ==
                                      selectedMedia.length) {
                                    setState(() =>
                                        uploadedFileUrl = downloadUrls.first);
                                    showUploadMessage(context, 'Success!');
                                  } else {
                                    setState(() {});
                                    showUploadMessage(
                                        context, 'Failed to upload media');
                                    return;
                                  }
                                }
                              },
                              text: 'Change Photo',
                              options: FFButtonOptions(
                                width: 130,
                                height: 40,
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Lexend Deca',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 1,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                        child: AuthUserStreamWidget(
                          child: TextFormField(
                            controller: yourNameController,
                            obscureText: false,
                            decoration: InputDecorator(context, 'Display Name'),
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
                        child: TextFormField(
                          controller: useEmailController,
                          readOnly: true,
                          obscureText: false,
                          decoration: InputDecorator(context, 'Email'),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
                        child: AuthUserStreamWidget(
                          child: TextFormField(
                            controller: genderController,
                            obscureText: false,
                            decoration: InputDecorator(context, 'Gender'),
                            style: FlutterFlowTheme.of(context).bodyText1,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SaveChangesButton(
                          yourNameController: yourNameController,
                          useEmailController: useEmailController,
                          uploadedFileUrl: uploadedFileUrl,
                          genderController: genderController),
                      LogoutButton(mounted: mounted),
                    ],
                  ),
                ),
              ),
              NavBarWithMiddleButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration InputDecorator(BuildContext context, String label) {
    return InputDecoration(
      labelStyle: FlutterFlowTheme.of(context).bodyText2,
      labelText: label,
      hintStyle: FlutterFlowTheme.of(context).bodyText2,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primaryBackground,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primaryBackground,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
    required this.mounted,
  }) : super(key: key);

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: FFButtonWidget(
        onPressed: () async {
          GoRouter.of(context).prepareAuthEvent();
          await signOut();

          context.goNamedAuth('AuthScreen', mounted);
        },
        text: 'Logout',
        options: FFButtonOptions(
          width: 150,
          height: 45,
          color: FlutterFlowTheme.of(context).buttonRed,
          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class SaveChangesButton extends StatelessWidget {
  const SaveChangesButton({
    Key? key,
    required this.yourNameController,
    required this.useEmailController,
    required this.uploadedFileUrl,
    required this.genderController,
  }) : super(key: key);

  final TextEditingController? yourNameController;
  final TextEditingController? useEmailController;
  final String? uploadedFileUrl;
  final TextEditingController? genderController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 10),
        child: FFButtonWidget(
          onPressed: () async {
            final Map<String, dynamic> usersUpdateData = {};

            if (yourNameController?.text != null)
              usersUpdateData['displayName'] = yourNameController!.text;

            if (useEmailController?.text != null)
              usersUpdateData['email'] = useEmailController!.text;

            if (uploadedFileUrl != null)
              usersUpdateData['photoUrl'] = uploadedFileUrl;

            if (genderController?.text != null)
              usersUpdateData['gender'] = genderController!.text;

            await currentUserReference!.update(usersUpdateData);
          },
          text: 'Save Changes',
          options: FFButtonOptions(
            width: 150,
            height: 45,
            color: FlutterFlowTheme.of(context).buttonGreen,
            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
            elevation: 2,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
