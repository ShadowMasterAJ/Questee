import '../backend/backend.dart';
import '../components/AmountBottomSheet.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class JobDetailScreenPosterWidget extends StatefulWidget {
  // final String store;
  // final String time;
  // final String note;
  // final DocumentReference? job;
  // final JobRecord? jobDoc;
  final String indexStr;
  // final int fuck;
  const JobDetailScreenPosterWidget({
    Key? key,
    required this.indexStr,
    // required this.store,
    // required this.time,
    // required this.note,
    // this.job,
    // this.jobDoc
    // required this.fuck,
  }) : super(key: key);

  @override
  _JobDetailScreenPosterWidgetState createState() =>
      _JobDetailScreenPosterWidgetState();
}

class _JobDetailScreenPosterWidgetState
    extends State<JobDetailScreenPosterWidget> {
  List<String>? checkboxGroupValues;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // PagingController<DocumentSnapshot?, JobRecord>? _pagingController;

    // String STORE = widget.store;
    // String TIME = widget.time;
    // print("fuck");
    // print(widget.jobDoc);
    // String NOTE = widget.note;
    int index = int.parse(widget.indexStr);
    // int fuck = widget.fuck;
    // final listViewJobRecord = _pagingController!.itemList![fuck];
    // print(listViewJobRecord.store!);
    // JobRecord record = widget.record!;
    // print(record.items![0]);
    // if (widget.record == null) print("NULL YOU RETARD");
    // List<String> CHECKLIST = widget.checklist;
    print("REACHED SCREEN POSTER WIDGET 000");
    // List CHECKLIST = widget.checklist.items!.toList();
    // String STORE = widget.checklist.store!;
    // String TIME = valueOrDefault<String>(
    //   dateTimeFormat('jm', widget.checklist.delTime),
    //   'ASAP',
    // );
    // String NOTE = widget.checklist.note!;
    // print(CHECKLIST[0]);
    print("REACHED SCREEN POSTER WIDGET 1111");
    // final args = ModalRoute.of(context)!.settings.arguments;
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
                print(index);
                print(columnJobRecordList);
                print("kokokokokokookokokokokookokokokokokok");
                print(columnJobRecordList[index]);
                print("hi here");
                print("===========================================");
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
                              'Job Detail.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).title1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (columnJobRecord!.acceptorID == null)
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: columnJobRecord!.acceptorID != null
                            ? 'Your job has been Accepted!'
                            : 'Your job is pending acceptance.',
                        options: FFButtonOptions(
                          width: 300,
                          height: 40,
                          color: columnJobRecord!.acceptorID != null
                              ? Color(0xFF80D3A2)
                              : FlutterFlowTheme.of(context).secondaryText,
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
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
                                          options: columnJobRecord!.items!
                                              .toList(), // HI DC REFER TO HERE
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
                                      // STORE,
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
                                      valueOrDefault<String>(
                                        dateTimeFormat(
                                            'jm', columnJobRecord.delTime),
                                        'ASAP',
                                      ),
                                      // TIME,
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
                                      // NOTE,
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
                    Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0.11),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Chat with Job Acceptor',
                            options: FFButtonOptions(
                              width: 320,
                              height: 50,
                              color: FlutterFlowTheme.of(context).primaryColor,
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (columnJobRecord.acceptorID == null)
                          Align(
                            alignment: AlignmentDirectional(0, 0.7),
                            child: StreamBuilder<List<UsersRecord>>(
                              stream: queryUsersRecord(
                                singleRecord: true,
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
                                List<UsersRecord> buttonUsersRecordList =
                                    snapshot.data!;
                                print(buttonUsersRecordList);
                                // Return an empty Container when the document does not exist.
                                if (snapshot.data!.isEmpty) {
                                  return Container();
                                }
                                final buttonUsersRecord =
                                    buttonUsersRecordList.isNotEmpty
                                        ? buttonUsersRecordList.first
                                        : null;
                                return FFButtonWidget(
                                  onPressed: () async {
                                    if (columnJobRecord.acceptorID != null) {
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
                                            duration:
                                                Duration(milliseconds: 400),
                                          ),
                                        },
                                      );
                                    } else {
                                      return;
                                    }
                                  },
                                  text: 'Chat with Job Acceptor',
                                  options: FFButtonOptions(
                                    width: 320,
                                    height: 50,
                                    color: valueOrDefault<Color>(
                                      columnJobRecord!.acceptorID != null
                                          ? Color(0xFF80D3A2)
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      Color(0xFFC0C0C0),
                                    ),
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.1, -0.05),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 15, 0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if(true){
                                      //if (columnJobRecord!.acceptorID != null) {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: AmountBottomSheetWidget(),
                                            );
                                          },
                                        ).then((value) => setState(() {}));
                                      } else {
                                        return;
                                      }
                                    },
                                    text: 'Verify',
                                    options: FFButtonOptions(
                                      width: 150,
                                      height: 50,
                                      color: valueOrDefault<Color>(
                                        columnJobRecord!.acceptorID != null
                                            ? Color(0xFF80D3A2)
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        Color(0xFFC0C0C0),
                                      ),
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Delete',
                            options: FFButtonOptions(
                              width: 150,
                              height: 50,
                              color: Color(0xFFC9685D),
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
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
