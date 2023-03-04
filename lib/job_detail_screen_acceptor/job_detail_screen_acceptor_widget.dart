import 'package:flutter/material.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

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
                              style:
                                  FlutterFlowTheme.of(context).title1.override(
                                        fontFamily: 'Poppins',
                                        fontSize: 36,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DelItems(columnJobRecord, context),
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
                              DelStore(columnJobRecord: columnJobRecord),
                              DelTiming(columnJobRecord: columnJobRecord),
                              PosterNote(columnJobRecord: columnJobRecord),
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
                                    columnJobRecord!.posterID!.id)
                                .toList();
                            return Text(
                              poster.length > 0
                                  ? "Posted by: ${poster[0].displayName.toString()}"
                                  : "Error",
                              style: FlutterFlowTheme.of(context).bodyText1,
                            );
                          }),
                    ),
                    Spacer(),
                    columnJobRecord!.acceptorID == null
                        ? AcceptJobButton(columnJobRecord, context)
                        : ChatButton(columnJobRecordList: columnJobRecordList),
                    columnJobRecord.acceptorID.toString() == currentUserUid
                        ? JobAcceptedText()
                        : Container(),
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
  Align DelItems(JobRecord? columnJobRecord, BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-0.1, 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      FlutterFlowCheckboxGroup(
                        options: columnJobRecord!.items!.toList(),
                        onChanged: (val) =>
                            setState(() => checkboxGroupValues = val),
                        activeColor: FlutterFlowTheme.of(context).primaryColor,
                        checkColor: Colors.white,
                        checkboxBorderColor: Color(0xFF95A1AC),
                        textStyle: FlutterFlowTheme.of(context).bodyText1,
                        initialized: checkboxGroupValues != null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding AcceptJobButton(JobRecord columnJobRecord, BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: FFButtonWidget(
        onPressed: () async {
          final jobUpdateData = createJobRecordData(
              acceptorID: currentUserReference,
              items: columnJobRecord.items?.toList());
          UsersRecord.addCurrJobsAccepted(
              currentUserReference!.id, columnJobRecord.reference);
          await columnJobRecord.reference.update(jobUpdateData);
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

          final DocumentReference<Object?>? columnJobRecord =
              columnJobRecordList.isNotEmpty
                  ? columnJobRecordList.first.reference
                  : null;
          return FFButtonWidget(
            onPressed: () async {
              context.pushNamed(
                'ChatScreen',
                queryParams: {
                  'jobRef': serializeParam(
                    columnJobRecord,
                    ParamType.DocumentReference,
                  ),
                }.withoutNulls,
                extra: {
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

class DelStore extends StatelessWidget {
  const DelStore({
    Key? key,
    required this.columnJobRecord,
  }) : super(key: key);

  final JobRecord? columnJobRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              Icons.shopping_cart,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Text(
            columnJobRecord!.store!,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}

class DelTiming extends StatelessWidget {
  const DelTiming({
    Key? key,
    required this.columnJobRecord,
  }) : super(key: key);

  final JobRecord? columnJobRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(25, 20, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              Icons.timer,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Text(
            // columnJobRecord!.delTime.toString(),
            valueOrDefault<String>(
              dateTimeFormat('jm', columnJobRecord!.delTime),
              'ASAP',
            ),
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}

class PosterNote extends StatelessWidget {
  const PosterNote({
    Key? key,
    required this.columnJobRecord,
  }) : super(key: key);

  final JobRecord? columnJobRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(25, 20, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              Icons.info_outlined,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Text(
            columnJobRecord!.note!.length < 2
                ? "Poster provided no description"
                : columnJobRecord!.note!,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
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
