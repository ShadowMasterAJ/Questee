// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../components/AmountBottomSheet.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class JobDetailScreenPosterWidget extends StatefulWidget {
  final DocumentReference jobRef;
  const JobDetailScreenPosterWidget({
    Key? key,
    required this.jobRef, //TODO - better implementation, pass the jobID here and just access it's information instead of retrieving all the jobs again
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

              final location = jobData['del_location'].toString();
              final delTime = jobData['del_time'] as DateTime;
              final posterID = jobData['posterID'] as DocumentReference;
              final store = jobData['store'].toString();

              final acceptorID = jobData['acceptorID'] != ""
                  ? (jobData['acceptorID'] as DocumentReference).id
                  : jobData['acceptorID'];
              final type = jobData['type'].toString();
              final status = jobData['status'].toString();
              final items = List<String>.from(jobData['items']);
              final note = jobData['note'].toString();
              final price = jobData['price'] as double;

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
                          StoreTimeNoteEntry(
                            icon: Icons.shopping_cart,
                            entry: store,
                          ),
                          StoreTimeNoteEntry(
                              icon: Icons.timer,
                              entry: valueOrDefault<String>(
                                dateTimeFormat('jm', delTime),
                                'ASAP',
                              )),
                          StoreTimeNoteEntry(
                              icon: Icons.info, entry: note, lines: 2),
                        ],
                      ),
                    ],
                  ),
                  SectionDivider(),
                  Spacer(),
                  acceptorID == ""
                      ? DeleteJobButton(jobRef: widget.jobRef)
                      : ChatButton(jobRecord: widget.jobRef),
                  if (acceptorID != "")
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: VerifyButton(context, acceptorID)),
                          SizedBox(width: 10),
                          Expanded(
                              child: DeleteJobButton(jobRef: widget.jobRef)),
                        ],
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

  ElevatedButton VerifyButton(BuildContext context, acceptorID) {
    return ElevatedButton(
      onPressed: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AmountBottomSheetWidget(),
            );
          },
        ).then((value) => setState(() {}));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            acceptorID != "" ? Color(0xFF80D3A2) : Color(0xFFC0C0C0),
        textStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
        elevation: 5,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Verify',
        style: FlutterFlowTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
    );
  }

  Column DelItems(List<String> items, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 20, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items to buy",
                  style: FlutterFlowTheme.of(context).title3.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.   ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .copyWith(fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                items[index],
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StoreTimeNoteEntry extends StatelessWidget {
  const StoreTimeNoteEntry({
    Key? key,
    required this.entry,
    this.lines = 1,
    required this.icon,
  }) : super(key: key);

  final String entry;
  final int lines;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
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
              style:
                  FlutterFlowTheme.of(context).bodyText1.copyWith(fontSize: 16),
              maxLines: lines,
            ),
          ),
        ],
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

class DelTime extends StatelessWidget {
  const DelTime({
    Key? key,
    required this.store,
    required this.delTime,
    required this.note,
  }) : super(key: key);

  final String store;
  final DateTime delTime;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            StoreTimeNoteEntry(
              icon: Icons.shopping_cart,
              entry: store,
            ),
            StoreTimeNoteEntry(
                icon: Icons.timer,
                entry: valueOrDefault<String>(
                  dateTimeFormat('jm', delTime),
                  'ASAP',
                )),
            StoreTimeNoteEntry(icon: Icons.info, entry: note, lines: 2),
          ],
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
          ? Color(0xFF80D3A2)
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
        try {
          await jobRef.delete();
          print('Job document deleted successfully');
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
        backgroundColor: Color(0xFFC9685D),
        elevation: 5,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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
    return ElevatedButton(
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
      child: Text(
        'Chat with Job Acceptor',
        style: FlutterFlowTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.infinity, 50),
        side: BorderSide(
          color: Colors.transparent,
          width: 1,
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
