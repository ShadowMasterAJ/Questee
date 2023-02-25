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

class JobDetailScreenAcceptorWidget extends StatefulWidget {
  final String indexStr;
  const JobDetailScreenAcceptorWidget({
    Key? key,
    required this.indexStr,
  }) : super(key: key);

  @override
  _JobDetailScreenAcceptorWidgetState createState() =>
      _JobDetailScreenAcceptorWidgetState();
}

class _JobDetailScreenAcceptorWidgetState
    extends State<JobDetailScreenAcceptorWidget> {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      columnJobRecord.note!.length < 2
                                          ? "Poster provided no description"
                                          : columnJobRecord.note!,
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
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

                            List<UsersRecord> poster = snapshot.data!
                                .where((element) =>
                                    element.uid.toString() ==
                                    columnJobRecord.posterID!.id)
                                .toList();

                            return Text(
                              poster.length > 0
                                  ? "Posted by: ${poster[0].displayName.toString()}"
                                  : "Error",
                              style: FlutterFlowTheme.of(context).bodyText1,
                            );
                            // Text(
                            //   columnJobRecord.posterID!.id,
                            //   style: FlutterFlowTheme.of(context).bodyText1,
                            // ),
                          }),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: FFButtonWidget(
                        onPressed: () async {
                          // how to set acceptorId to current user's userId?

                          // final columnJobUpdateData = createJobRecordData(
                          //   acceptorId: currentUserReference,
                          //   accepted: true,
                          // );
                          print("GOING TO UPDATE");
                          // List _lst = columnJobRecord.items;

                          final jobUpdateData = createJobRecordData(
                              acceptorID: currentUserReference,
                              items: columnJobRecord.items?.toList());
                          print(columnJobRecord);

                          // final usersUpdateData = createUsersRecordData(
                          //   uid: currentUserUid,
                          // );
                          await columnJobRecord.reference.update(jobUpdateData);

                          setState(() => accepted = true);
                          print(columnJobRecord);
                        },
                        text: 'Accept This Job ',
                        options: FFButtonOptions(
                          width: 340,
                          height: 50,
                          color: Color(0xFF9ACDA1),
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
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
                    !accepted
                        ? AcceptJobButton(columnJobRecord, context)
                        : ChatButton(columnJobRecordList: columnJobRecordList),

                    // ignore below for now
                    // FFButtonWidget(
                    //   onPressed: () {
                    //     context.pushNamed("ChatScreen",
                    //         queryParams: {
                    //           'jobRef': serializeParam(
                    //               columnJobRecord, ParamType.Document)
                    //         }.withoutNulls);
                    //   },
                    //   text: 'Chat with Job Poster',
                    //   options: FFButtonOptions(
                    //     width: 320,
                    //     height: 50,
                    //     color: FlutterFlowTheme.of(context).primaryColor,
                    //     textStyle:
                    //         FlutterFlowTheme.of(context).subtitle2.override(
                    //               fontFamily: 'Poppins',
                    //               color: Colors.white,
                    //             ),
                    //     borderSide: BorderSide(
                    //       color: Colors.transparent,
                    //       width: 1,
                    //     ),
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    // ),

                    accepted ? JobAcceptedText() : Container(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding AcceptJobButton(JobRecord columnJobRecord, BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: FFButtonWidget(
        onPressed: () async {
          // how to set acceptorId to current user's userId?

          // final columnJobUpdateData = createJobRecordData(
          //   acceptorId: currentUserReference,
          //   accepted: true,
          // );
          print("GOING TO UPDATE");
          // List _lst = columnJobRecord.items;

          final jobUpdateData = createJobRecordData(
              acceptorID: currentUserReference,
              items: columnJobRecord.items?.toList());
          print(columnJobRecord);

          // final usersUpdateData = createUsersRecordData(
          //   uid: currentUserUid,
          // );
          await columnJobRecord.reference.update(jobUpdateData);

          setState(() => accepted = true);
          print(columnJobRecord);
        },
        text: 'Accept This Job ',
        options: FFButtonOptions(
          width: 340,
          height: 50,
          color: Color(0xFF9ACDA1),
          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
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
    );
  }
}

class JobAcceptedText extends StatelessWidget {
  const JobAcceptedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        'Job Accepted!',
        style: FlutterFlowTheme.of(context).title2.override(
              fontFamily: 'Poppins',
              color: Color(0xFF80D3A2),
              fontSize: 30,
            ),
      ),
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
    required this.columnJobRecordList,
  }) : super(key: key);

  final List<JobRecord> columnJobRecordList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: StreamBuilder<List<UsersRecord>>(
        stream: queryUsersRecord(
          singleRecord: true,
        ),
        builder: (context, snapshot) {
          /// TODO: modify jobrecord accept button to add to user jobsaccepted list

          // final newDocRef = JobRecord.collection.doc();
          // await newDocRef.set(jobCreateData);
          // final jobId = newDocRef.id;
          // UsersRecord.addCurrJobsAccepted(currentUserReference!.id, jobId);

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
          //  List<JobRecord> columnJobRecordList = snapshot.data!;

          // Return an empty Container when the document does not exist.
          if (snapshot.data!.isEmpty) {
            return Container();
          }
          final columnJobRecord =
              columnJobRecordList.isNotEmpty ? columnJobRecordList.first : null;
          DocumentReference<Object?>? buttonUsersRecord =
              columnJobRecord!.posterID;

          return FFButtonWidget(
            onPressed: () async {
              context.pushNamed(
                'ChatScreen',
                queryParams: {
                  'chatUser': serializeParam(
                    columnJobRecord,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'chatUser': buttonUsersRecord,
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.scale,
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
              color: FlutterFlowTheme.of(context).primaryColor,
              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).primaryText,
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
    );
  }
}
