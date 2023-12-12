// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:u_grabv1/components/CardForm.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'verification_bottom_modal_sheet.dart';

class JobDetailScreenAcceptorWidget extends StatefulWidget {
  final DocumentReference jobRef;
  const JobDetailScreenAcceptorWidget({
    Key? key,
    required this.jobRef,
  }) : super(key: key);

  @override
  _JobDetailScreenAcceptorWidgetState createState() =>
      _JobDetailScreenAcceptorWidgetState();
}

class _JobDetailScreenAcceptorWidgetState
    extends State<JobDetailScreenAcceptorWidget> {
  List<String>? checkboxGroupValues;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, Object>> getJobData() async {
    final DocumentReference correctRef =
        FirebaseFirestore.instance.doc('job/${widget.jobRef.id}');
    final DocumentSnapshot snapshot = await correctRef.get();
    final data = snapshot.data() as Map<String, dynamic>;

    return {
      'ref': correctRef,
      'del_location': data['del_location'].toString(),
      'del_time': data['del_time'].toDate(),
      'items': data['items'],
      'note': data['note'],
      'posterID': data['posterID'],
      'acceptorID': data.containsKey('acceptorID') ? data['acceptorID'] : "",
      'store': data['store'],
      'status': data['status'],
      'type': data['type'],
      'price': data['price'],
    };
  }

  @override
  Widget build(BuildContext context) {
    // final DocumentReference correctJobRef =
    //     FirebaseFirestore.instance.doc('job/${widget.jobRef.id}');

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: FutureBuilder<Map<String, Object>>(
              future: getJobData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");

                  return Center(
                    child: Text('Error fetching data'),
                  );
                }

                final jobData = snapshot.data!;
                final DocumentReference correctJobRef =
                    jobData['ref'] as DocumentReference;
                final String location = jobData['del_location'].toString();
                final DateTime delTime = jobData['del_time'] as DateTime;
                final DocumentReference posterID =
                    jobData['posterID'] as DocumentReference;
                final String store = jobData['store'].toString();
                final String acceptorID = jobData['acceptorID'] != ""
                    ? (jobData['acceptorID'] as DocumentReference).id
                    : jobData['acceptorID'];
                final String type = jobData['type'].toString();
                final String status = jobData['status'].toString();
                final List<String> items = List<String>.from(jobData['items']);
                final String note = jobData['note'].toString();
                final double price = jobData['price'];

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Header(),
                    ),
                    JobStatusChip(acceptorID: acceptorID),
                    DelItems(items, context),
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
                              DelStore(store: store),
                              DelLocation(location: location),
                              DelTiming(delTime: delTime),
                              PosterNote(note: note),
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
                    PostedBy(posterID),
                    Spacer(),
                    acceptorID != ""
                        ? ChatButton(jobRecord: correctJobRef)
                        : AcceptJobButton(correctJobRef, context),
                    if (acceptorID != "")
                      UploadReceiptModalBottomSheet(
                        jobRef: correctJobRef,
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

  Padding PostedBy(DocumentReference<Object?> posterID) {
    return Padding(
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
                    color: FlutterFlowTheme.of(context).primaryColor,
                  ),
                ),
              );
            }

            List<UsersRecord> poster = snapshot.data!
                .where((element) => element.uid.toString() == posterID.id)
                .toList();
            return Text(
              poster.length > 0
                  ? "Posted by: ${poster[0].displayName.toString()}"
                  : "Error",
              style: FlutterFlowTheme.of(context).bodyText1,
            );
          }),
    );
  }

  Widget DelItems(List<String> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
          child: Text("Items to buy",
              style: FlutterFlowTheme.of(context).title3.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                  )),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 20),
          constraints: BoxConstraints(
            maxHeight: 200,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: items.length > 5
                  ? [
                      Colors.transparent,
                      FlutterFlowTheme.of(context).primaryColor.withOpacity(0.3)
                    ]
                  : [Colors.transparent, Colors.transparent],
              stops: [0.75, 1],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(items.length, (index) {
                return Container(
                  height: 35,
                  child: ListTile(
                    title: Text(
                      '${index + 1}.\t\t${items[index]}',
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Padding AcceptJobButton(
      DocumentReference columnJobRecord, BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: ElevatedButton(
        onPressed: () async {
          final Map<String, dynamic> jobUpdateData = {};

          jobUpdateData['acceptorID'] = currentUserReference;

          UsersRecord.addCurrJobsAccepted(
              currentUserReference!.id, columnJobRecord);

          await columnJobRecord.update(jobUpdateData);
          setState(() {});
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => CardForm()));
        },
        child: Text(
          'Accept This Job',
          style: FlutterFlowTheme.of(context).subtitle2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          minimumSize: Size(340, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
          child: Text(
            'Job Details.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).title1.override(
                  fontFamily: 'Poppins',
                  fontSize: 36,
                ),
          ),
        ),
      ],
    );
  }
}

class JobStatusChip extends StatelessWidget {
  const JobStatusChip({
    Key? key,
    required this.acceptorID,
  }) : super(key: key);

  final String acceptorID;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: acceptorID != ""
          ? FlutterFlowTheme.of(context).buttonGreen
          : FlutterFlowTheme.of(context).secondaryText,
      child: SizedBox(
        width: 300,
        height: 40,
        child: Center(
          child: Text(
            acceptorID != ""
                ? "You have accepted the job."
                : "Job is still available",
            style: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}

class DelStore extends StatelessWidget {
  const DelStore({
    Key? key,
    required this.store,
  }) : super(key: key);

  final String store;

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
            store,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}

class DelLocation extends StatelessWidget {
  const DelLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  final String location;

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
              Icons.pin_drop_rounded,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Text(
            location,
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
    required this.delTime,
  }) : super(key: key);

  final DateTime delTime;

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
              Icons.access_time,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Text(
            // columnJobRecord!.delTime.toString(),
            valueOrDefault<String>(
              dateTimeFormat('jm', delTime),
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
    required this.note,
  }) : super(key: key);

  final String note;

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
            note.length < 2 ? "Poster provided no description" : note,
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
              color: FlutterFlowTheme.of(context).buttonGreen,
              fontSize: 30,
            ),
      ),
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
    required this.jobRecord,
  }) : super(key: key);

  final DocumentReference jobRecord;

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
          print("JOBRECORD TO CHAT: $jobRecord");
          return FFButtonWidget(
            onPressed: () async {
              context.pushNamed(
                'ChatScreen',
                queryParams: {
                  'jobRef': serializeParam(
                    jobRecord,
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
            text: 'Chat with ReQuester',
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
