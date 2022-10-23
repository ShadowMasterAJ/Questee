import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobDetailScreenGrabberWidget extends StatefulWidget {
  final String indexStr;
  const JobDetailScreenGrabberWidget({
    Key? key,
    required this.indexStr,
  }) : super(key: key);

  @override
  _JobDetailScreenGrabberWidgetState createState() =>
      _JobDetailScreenGrabberWidgetState();
}

class _JobDetailScreenGrabberWidgetState
    extends State<JobDetailScreenGrabberWidget> {
  List<String>? checkboxGroupValues;
  bool accepted = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int index = int.parse(widget.indexStr);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: StreamBuilder<List<JobRecord>>(
              stream: queryJobRecord(
                singleRecord: false,
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                List<JobRecord> columnJobRecordList = snapshot.data!;
                print(columnJobRecordList);

                // Return an empty Container when the document does not exist.
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                final columnJobRecord = columnJobRecordList.isNotEmpty
                    ? columnJobRecordList[index]
                    : null;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 50,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 30,
                            ),
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: Text(
                              'Job Details.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).title1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.1, 0.05),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 0, 0, 0),
                                        child: FlutterFlowCheckboxGroup(
                                          options:
                                              columnJobRecord!.items!.toList(),
                                          onChanged: (val) => setState(
                                              () => checkboxGroupValues = val),
                                          activeColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryColor,
                                          checkColor: Colors.white,
                                          checkboxBorderColor:
                                              Color(0xFF95A1AC),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1,
                                          initialized:
                                              checkboxGroupValues != null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: FlutterFlowTheme.of(context).grayIcon,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 10, 0),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: FlutterFlowTheme.of(context)
                                            .gray200,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      columnJobRecord.store!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    25, 20, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 10, 0),
                                      child: Icon(
                                        Icons.timer,
                                        color: FlutterFlowTheme.of(context)
                                            .gray200,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      // columnJobRecord!.delTime.toString(),
                                      valueOrDefault<String>(
                                        dateTimeFormat(
                                            'jm', columnJobRecord.delTime),
                                        'ASAP',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    25, 20, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 10, 0),
                                      child: Icon(
                                        Icons.info_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .gray200,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      columnJobRecord.note!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: FlutterFlowTheme.of(context).grayIcon,
                    ),
                    Spacer(),
                    if (accepted)
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: StreamBuilder<List<UsersRecord>>(
                            stream: queryUsersRecord(
                              singleRecord: false,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                );
                              }

                              //  List<JobRecord> columnJobRecordList = snapshot.data!;

                              // Return an empty Container when the document does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final columnJobRecord =
                                  columnJobRecordList.isNotEmpty
                                      ? columnJobRecordList.first
                                      : null;
                              List<UsersRecord> buttonUsersRecordList =
                                  snapshot.data!;

                              var buttonUsersRecord;

                              for (int i = 0;
                                  i < buttonUsersRecordList.length;
                                  i++) {
                                if (buttonUsersRecordList[i].uid ==
                                    '8pheppLwF8NICJ29T6bgD9A18j02') {
                                  buttonUsersRecord = buttonUsersRecordList[i];
                                }
                              }
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }

                              return FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed(
                                    'ChatScreen',
                                    queryParams: {
                                      'chatUser': serializeParam(
                                        buttonUsersRecord,
                                        ParamType.Document,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'chatUser': buttonUsersRecord,
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.scale,
                                        alignment: Alignment.bottomCenter,
                                        duration: Duration(milliseconds: 400),
                                      ),
                                    },
                                  );
                                },
                                text: 'Chat with Job Poster',
                                options: FFButtonOptions(
                                  width: 340,
                                  height: 50,
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (accepted == false)
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: FFButtonWidget(
                            onPressed: () async {
                              // how to set acceptorId to current user's userId?

                              // final columnJobUpdateData = createJobRecordData(
                              //   acceptorId: currentUserReference,
                              //   accepted: true,
                              // );
                              print("GOING TO UPDATE");

                              final jobUpdateData = createJobRecordData(
                                  acceptorID: currentUserReference);
                              print(columnJobRecord);

                              // final usersUpdateData = createUsersRecordData(
                              //   uid: currentUserUid,
                              // );
                              await columnJobRecord.reference
                                  .update(jobUpdateData);

                              print("update!!!!!!!");

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Job Accepted!',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: Color(0x00000000),
                                ),
                              );
                              setState(() => accepted = true);
                              print(columnJobRecord);
                            },
                            text: 'Accept This Job ',
                            options: FFButtonOptions(
                              width: 340,
                              height: 50,
                              color: Color(0xFF9ACDA1),
                              textStyle: FlutterFlowTheme.of(context)
                                  .subtitle2
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    if (accepted)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Job Accepted!',
                          style: FlutterFlowTheme.of(context).title2.override(
                                fontFamily: 'Poppins',
                                color: Color(0xFF80D3A2),
                                fontSize: 30,
                              ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
