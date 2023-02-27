import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class JobHistoryScreenWidget extends StatefulWidget {
  const JobHistoryScreenWidget({Key? key}) : super(key: key);

  @override
  _JobHistoryScreenWidgetState createState() => _JobHistoryScreenWidgetState();
}

class _JobHistoryScreenWidgetState extends State<JobHistoryScreenWidget> {
  PagingController<DocumentSnapshot?, JobRecord>? _pagingController;
  List<StreamSubscription?> _streamSubscriptions = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc('userId');
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 12),
              child: Text(
                'Job History.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                    ),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: FlutterFlowTheme.of(context).primaryColor,
                      labelStyle: FlutterFlowTheme.of(context).subtitle2,
                      indicatorColor:
                          FlutterFlowTheme.of(context).secondaryColor,
                      tabs: [
                        Tab(text: 'Jobs Accepted'),
                        Tab(text: 'Jobs Posted'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AcceptedJobsTab(),
                          PostedJobsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NavBarWithMiddleButtonWidget(),
          ],
        ),
      ),
    );
  }
}

class PostedJobsTab extends StatelessWidget {
  const PostedJobsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobDesc(desc: "Current Jobs"),
          CurrentJobsPosted(),
          JobDesc(desc: "Past Jobs"),
          PastJobsPosted(),
        ],
      ),
    );
  }
}

class AcceptedJobsTab extends StatelessWidget {
  const AcceptedJobsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobDesc(desc: "Current Jobs"),
          CurrentJobsAccepted(),
          JobDesc(desc: "Past Jobs"),
          PastJobsAccepted(),
        ],
      ),
    );
  }
}

class PastJobsPosted extends StatelessWidget {
  const PastJobsPosted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: StreamBuilder<List<JobRecord>>(
        stream: queryJobRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }

          final allJobRecords = snapshot.data ?? [];

          // Filter the job records to only show completed jobs for the current user
          // TODO: replace with getting from pastJobsPosted list
          final filteredJobRecords = allJobRecords
              .where((jobRecord) =>
                  jobRecord.status == 'completed' &&
                  jobRecord.posterID?.id == currentUserUid)
              .toList();

          if (filteredJobRecords.isEmpty) {
            return NoJobPlaceholder();
          }

          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: filteredJobRecords.length,
            itemBuilder: (context, i) {
              final filteredJobRecord = filteredJobRecords[i];
              print(filteredJobRecord);
              return JobCard(index: i, jobRecord: filteredJobRecord);
            },
          );
        },
      ),
    );
  }
}

class CurrentJobsPosted extends StatelessWidget {
  const CurrentJobsPosted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final lst = currentUserReference!.getDocument()

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: StreamBuilder<List<JobRecord>>(
        stream: queryJobRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }

          // TODO: change to read from currJobsPosted # DC TP HERE

          List<dynamic> currJobsPosted = [];

          currentUserReference?.get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              currJobsPosted.add(data['curr_jobs_posted'][0]);
              print("Current Length: ${currJobsPosted.length}");
              print(currJobsPosted);
            } else {
              print('User does not exist in Firestore');
            }
          }).catchError((error) {
            currJobsPosted = [];
          });

          print("Current Length: ${currJobsPosted.length}");

          print(currJobsPosted);
          print("?");
          // if (currJobsPosted.isEmpty) {
          //   print("isEmpty");
          //   return NoJobPlaceholder();
          // }
          print("here");

          // final allJobRecords = snapshot.data ?? [];

          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: currJobsPosted.length,
            itemBuilder: (context, i) {
              print("errror");
              final listViewJobRecord = currJobsPosted[i];
              return JobCard(index: i, jobRecord: listViewJobRecord);
            },
          );

          // return FutureBuilder<List<JobRecord>>(
          //   future: Future.wait(currJobsPosted.map((refString) =>
          //       JobRecord.getDocumentOnce(
          //           FirebaseFirestore.instance.doc(refString)))),
          //   builder: (context, snapshot) {
          //     print("here");
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     } else {
          //       final jobRecords = snapshot.data!;
          //       // return ListView.builder(
          //       //   primary: false,
          //       //   shrinkWrap: true,
          //       //   scrollDirection: Axis.vertical,
          //       //   itemCount: jobRecords.length,
          //       //   itemBuilder: (context, i) {
          //       //     return JobCard(index: i, jobRecord: jobRecords[i]);
          //       //   },
          //       return ListView.builder(
          //         primary: false,
          //         shrinkWrap: true,
          //         scrollDirection: Axis.vertical,
          //         itemCount: jobRecords.length,
          //         itemBuilder: (context, i) {
          //           print(jobRecords[i]);
          //           return JobCard(index: i, jobRecord: jobRecords[i]);
          //         },
          //       );
          //     }
          //   },
          // );
        },
      ),
    );
  }
}

class PastJobsAccepted extends StatelessWidget {
  const PastJobsAccepted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: StreamBuilder<List<JobRecord>>(
        stream: queryJobRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }

          final allJobRecords = snapshot.data ?? [];

          // Filter the job records to only show completed jobs for the current user
          // TODO: change to read from pastJobsAccepted/Posted
          final filteredJobRecords = allJobRecords
              .where((jobRecord) =>
                  jobRecord.status == 'completed' &&
                  jobRecord.acceptorID?.id == currentUserUid)
              .toList();

          if (filteredJobRecords.isEmpty) {
            return NoJobPlaceholder();
          }

          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: filteredJobRecords.length,
            itemBuilder: (context, i) {
              final filteredJobRecord = filteredJobRecords[i];
              print(filteredJobRecord);
              return JobCard(index: i, jobRecord: filteredJobRecord);
            },
          );
        },
      ),
    );
  }
}

class CurrentJobsAccepted extends StatelessWidget {
  const CurrentJobsAccepted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: StreamBuilder<List<JobRecord>>(
        stream: queryJobRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }
          // TODO: change to read from currJobsAccepted

          final listViewJobRecordList = snapshot.data
                  ?.where((jobRecord) =>
                      (jobRecord.status == 'open' ||
                          jobRecord.status == 'ongoing') &&
                      jobRecord.acceptorID?.id == currentUserUid)
                  .toList() ??
              [];
          print("JobsAcceped: $listViewJobRecordList");
          if (listViewJobRecordList.isEmpty) {
            return NoJobPlaceholder();
          }

          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listViewJobRecordList.length,
            itemBuilder: (context, i) {
              final listViewJobRecord = listViewJobRecordList[i];
              return JobCard(index: i, jobRecord: listViewJobRecord);
            },
          );
        },
      ),
    );
  }
}

class JobDesc extends StatelessWidget {
  const JobDesc({
    Key? key,
    required this.desc,
  }) : super(key: key);
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15, 15, 0, 0),
      child: Text(
        desc,
        style: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Poppins',
              color: Color(0xFFC6C5C5),
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }
}

class NoJobPlaceholder extends StatelessWidget {
  const NoJobPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/not_stonks.jpg',
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({
    Key? key,
    required this.jobRecord,
    required this.index,
  }) : super(key: key);

  final JobRecord jobRecord;
  final int index;

  @override
  Widget build(BuildContext context) {
    int index = this.index;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: InkWell(
        onTap: () async {
          String indexStr = index.toString();

          if ((jobRecord.posterID!.id) == (currentUserReference!.id)) {
            context.pushNamed(
              'JobDetailScreenPoster',
              queryParams: {
                'indexStr': serializeParam(indexStr, ParamType.String)!,
              },
            );
          } else {
            context.pushNamed(
              'JobDetailScreenAcceptor',
              queryParams: {
                'indexStr': serializeParam(indexStr, ParamType.String)!,
              },
            );
          }
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: FlutterFlowTheme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/app_launcher_icon.png', //TODO - change
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: Icon(
                            Icons.shopping_cart,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            size: 24,
                          ),
                        ),
                        Text(
                          jobRecord.store!,
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: Icon(
                            Icons.access_time,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            size: 24,
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            dateTimeFormat('jm', jobRecord.delTime),
                            'ASAP',
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: FaIcon(
                            FontAwesomeIcons.moneyCheckAlt,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            size: 22,
                          ),
                        ),
                        Text(
                          jobRecord.delLocation!,
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
