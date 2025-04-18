// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:u_grabv1/auth/auth_util.dart';

import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'verification_bottom_modal_sheet.dart';

class JobDetailScreenPosterWidget extends StatefulWidget {
  final DocumentReference jobRef;
  const JobDetailScreenPosterWidget({
    Key? key,
    required this.jobRef,
  }) : super(key: key);

  @override
  _JobDetailScreenPosterWidgetState createState() =>
      _JobDetailScreenPosterWidgetState();
}

class _JobDetailScreenPosterWidgetState
    extends State<JobDetailScreenPosterWidget> {
  List<String>? checkboxGroupValues;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, Object>> getJobData() async {
    print("RECEIVED JOBRECORD: ${widget.jobRef}");
    final DocumentReference correctRef =
        FirebaseFirestore.instance.doc('job/${widget.jobRef.id}');
    final DocumentSnapshot snapshot = await correctRef.get();
    print("CORRECTED JOBRECORD: $correctRef");

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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: FutureBuilder<Map<String, Object>>(
            future: getJobData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");

                return Center(
                    child: Text('Error fetching data: ${snapshot.error}'));
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
              final double price = jobData['price'] as double;

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Header(),
                  JobStatusChip(acceptorID: acceptorID),
                  DelItems(items, context),
                  SectionDivider(),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          StoreTimeNoteEntries(
                            context,
                            icon: Icons.money,
                            entry: '\$' + price.toString(),
                          ),
                          StoreTimeNoteEntries(
                            context,
                            icon: Icons.shopping_cart,
                            entry: store,
                          ),
                          StoreTimeNoteEntries(
                            context,
                            icon: Icons.pin_drop_sharp,
                            entry: location,
                          ),
                          StoreTimeNoteEntries(context,
                              icon: Icons.access_time,
                              entry: valueOrDefault<String>(
                                dateTimeFormat('jm', delTime),
                                'ASAP',
                              )),
                          StoreTimeNoteEntries(context,
                              icon: Icons.info, entry: note, lines: 2),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ],
                  ),
                  SectionDivider(),
                  Spacer(),
                  acceptorID == ""
                      ? DeleteJobButton(jobRef: correctJobRef)
                      : ChatButton(jobRef: correctJobRef),
                  Visibility(
                    visible: acceptorID != "",
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: VerifyButton(context, correctJobRef)),
                          SizedBox(width: 10),
                          Expanded(
                              child: DeleteJobButton(jobRef: correctJobRef)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Padding StoreTimeNoteEntries(
    BuildContext context, {
    required IconData icon,
    required String entry,
    int lines = 1,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              icon,
              color: FlutterFlowTheme.of(context).gray200,
              size: 24,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              entry,
              style: FlutterFlowTheme.of(context).bodyText1,
              maxLines: lines,
            ),
          ),
        ],
      ),
    );
  }

  VerificationModalBottomSheet VerifyButton(
      BuildContext context, DocumentReference correctJobRef) {
    return VerificationModalBottomSheet(
      jobRef: correctJobRef,
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
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Text(
            'Job Detail.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).title1,
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
                ? 'Your job has been Accepted!'
                : 'Your job is pending acceptance.',
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

class DeleteJobButton extends StatelessWidget {
  final DocumentReference jobRef;

  const DeleteJobButton({Key? key, required this.jobRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print('DELETING JOBREF: $jobRef');

        try {
          await jobRef.delete();
          UsersRecord.removeFromCurrJobsPosted(currentUserUid, jobRef);
          print('Job document deleted successfully');

          Navigator.of(context).pop();
        } catch (e) {
          print('Error deleting job document: $e');
        }
      },
      child: Text(
        'Delete',
        style: FlutterFlowTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: FlutterFlowTheme.of(context).buttonRed,
        elevation: 5,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: FlutterFlowTheme.of(context).grayIcon,
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
    required this.jobRef,
  }) : super(key: key);

  final DocumentReference jobRef;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        GoToChat(context, jobRef);
      },
      child: Text(
        'Chat with Quest Runner',
        style: FlutterFlowTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  void GoToChat(BuildContext context, DocumentReference jobRef) {
    context.pushNamed(
      'ChatScreen',
      queryParams: {
        'jobRef': serializeParam(
          jobRef,
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
  }
}
