import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          if (ModalRoute.of(context)?.isCurrent ?? false) CurrentJobsPosted(),
          JobDesc(desc: "Past Jobs"),
          if (ModalRoute.of(context)?.isCurrent ?? false) PastJobsPosted(),
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
          if (ModalRoute.of(context)?.isCurrent ?? true) CurrentJobsAccepted(),
          JobDesc(desc: "Past Jobs"),
          if (ModalRoute.of(context)?.isCurrent ?? true) PastJobsAccepted(),
        ],
      ),
    );
  }
}

class PastJobsPosted extends StatefulWidget {
  const PastJobsPosted({Key? key}) : super(key: key);

  @override
  _PastJobsPostedState createState() => _PastJobsPostedState();
}

class _PastJobsPostedState extends State<PastJobsPosted> {
  late List<dynamic> pastJobsPosted = [];

  Future<List<dynamic>> getPastJobsPosted() async {
    try {
      final DocumentSnapshot snapshot = await currentUserReference!.get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;
      //TODO - fix double circular progressors
      //TODO - cache the loaded shit

      if (data != null && data.containsKey('past_jobs_posted')) {
        pastJobsPosted = data['past_jobs_posted'] as List<dynamic>;
      } else {
        pastJobsPosted = [];
      }
    } catch (e) {
      print(e);
    }

    return pastJobsPosted;
  }

  Future<JobRecord> jobRecordCreator(int i) async {
    return await JobRecord.getDocumentOnce(pastJobsPosted[i]);
  }

  @override
  void initState() {
    super.initState();

    getPastJobsPosted().then((value) {
      setState(() {
        pastJobsPosted = value;
      });
    }).catchError((error) {
      print(error);
      pastJobsPosted = []; // or any other fallback value
    });

    // getPastJobsPosted();
  }

  @override
  Widget build(BuildContext context) {
    // if (pastJobsPosted == null) {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       color: FlutterFlowTheme.of(context).primaryColor,
    //     ),
    //   );
    // }

    if (pastJobsPosted.isEmpty) {
      return NoJobPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: pastJobsPosted.length,
        itemBuilder: (context, i) {
          return FutureBuilder<JobRecord>(
              future: jobRecordCreator(i),
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

                JobRecord jobRecord = snapshot.data!;

                return JobCard(index: i, jobRecord: jobRecord);
              });
        },
      ),
    );
  }
}

class CurrentJobsPosted extends StatefulWidget {
  const CurrentJobsPosted({Key? key}) : super(key: key);

  @override
  _CurrentJobsPostedState createState() => _CurrentJobsPostedState();
}

class _CurrentJobsPostedState extends State<CurrentJobsPosted> {
  late List<dynamic> currJobsPosted = [];

  Future<List<dynamic>> getCurrJobsPosted() async {
    try {
      final DocumentSnapshot snapshot = await currentUserReference!.get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('curr_jobs_posted')) {
        currJobsPosted = data['curr_jobs_posted'] as List<dynamic>;
      } else {
        currJobsPosted = [];
      }
    } catch (e) {
      print(e);
    }

    return currJobsPosted;
  }

  Future<JobRecord> jobRecordCreator(int i) async {
    return await JobRecord.getDocumentOnce(currJobsPosted[i]);
  }

  @override
  void initState() {
    super.initState();
    getCurrJobsPosted().then((value) {
      setState(() {
        currJobsPosted = value;
      });
    }).catchError((error) {
      print(error);
      currJobsPosted = []; // or any other fallback value
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      print("nulling");
      print(currJobsPosted[0]);
    } catch (e) {
      return Center(
          child: CircularProgressIndicator(
        color: FlutterFlowTheme.of(context).primaryColor,
      ));
    }

    // if (currJobsPosted == null) {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       color: FlutterFlowTheme.of(context).primaryColor,
    //     ),
    //   );
    // }

    if (currJobsPosted.isEmpty) {
      return NoJobPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: currJobsPosted.length,
        itemBuilder: (context, i) {
          return FutureBuilder<JobRecord>(
              future: jobRecordCreator(i),
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

                JobRecord jobRecord = snapshot.data!;

                return JobCard(index: i, jobRecord: jobRecord);
              });
        },
      ),
    );
  }
}

class PastJobsAccepted extends StatefulWidget {
  const PastJobsAccepted({Key? key}) : super(key: key);

  @override
  _PastJobsAcceptedState createState() => _PastJobsAcceptedState();
}

class _PastJobsAcceptedState extends State<PastJobsAccepted> {
  late List<dynamic> pastJobsAccepted = [];

  Future<List<dynamic>> getPastJobsAccepted() async {
    try {
      final DocumentSnapshot snapshot = await currentUserReference!.get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('past_jobs_accepted')) {
        pastJobsAccepted = data['past_jobs_accepted'] as List<dynamic>;
      } else {
        pastJobsAccepted = [];
      }
    } catch (e) {
      print(e);
    }

    return pastJobsAccepted;
  }

  Future<JobRecord> jobRecordCreator(int i) async {
    return await JobRecord.getDocumentOnce(pastJobsAccepted[i]);
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    getPastJobsAccepted().then((value) {
      setState(() {
        pastJobsAccepted = value;
      });
    }).catchError((error) {
      print(error);
      pastJobsAccepted = []; // or any other fallback value
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pastJobsAccepted == null) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primaryColor,
        ),
      );
    }

    if (pastJobsAccepted.isEmpty) {
      return NoJobPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: pastJobsAccepted.length,
        itemBuilder: (context, i) {
          return FutureBuilder<JobRecord>(
              future: jobRecordCreator(i),
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

                JobRecord jobRecord = snapshot.data!;

                return JobCard(index: i, jobRecord: jobRecord);
              });
        },
      ),
    );
  }
}

class CurrentJobsAccepted extends StatefulWidget {
  const CurrentJobsAccepted({Key? key}) : super(key: key);

  @override
  _CurrentJobsAcceptedState createState() => _CurrentJobsAcceptedState();
}

class _CurrentJobsAcceptedState extends State<CurrentJobsAccepted> {
  List<dynamic> currJobsAccepted = [];

  Future<List<dynamic>> getCurrJobsAccepted() async {
    try {
      final DocumentSnapshot snapshot = await currentUserReference!.get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('curr_jobs_accepted')) {
        currJobsAccepted = data['curr_jobs_accepted'] as List<dynamic>;
      } else {
        currJobsAccepted = [];
      }
    } catch (e) {
      print(e);
    }

    return currJobsAccepted;
  }

  Future<JobRecord> jobRecordCreator(int i) async {
    return await JobRecord.getDocumentOnce(currJobsAccepted[i]);
  }

  @override
  void initState() {
    super.initState();
    getCurrJobsAccepted().then((value) {
      setState(() {
        currJobsAccepted = value;
      });
    }).catchError((error) {
      print(error);
      currJobsAccepted = []; // or any other fallback value
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currJobsAccepted == null) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primaryColor,
        ),
      );
    }

    if (currJobsAccepted.isEmpty) {
      return NoJobPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: currJobsAccepted.length,
        itemBuilder: (context, i) {
          return FutureBuilder<JobRecord>(
              future: jobRecordCreator(i),
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

                JobRecord jobRecord = snapshot.data!;

                return JobCard(index: i, jobRecord: jobRecord);
              });
        },
      ),
    );
  }
}
// class CurrentJobsAccepted extends StatelessWidget {
//   const CurrentJobsAccepted({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//       child: StreamBuilder<List<JobRecord>>(
//         stream: queryJobRecord(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: FlutterFlowTheme.of(context).primaryColor,
//               ),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text('An error occurred. Please try again later.'),
//             );
//           }
//           // TODO: change to read from currJobsAccepted

//           final listViewJobRecordList = snapshot.data
//                   ?.where((jobRecord) =>
//                       (jobRecord.status == 'open' ||
//                           jobRecord.status == 'ongoing') &&
//                       jobRecord.acceptorID?.id == currentUserUid)
//                   .toList() ??
//               [];
//           print("JobsAcceped: $listViewJobRecordList");
//           if (listViewJobRecordList.isEmpty) {
//             return NoJobPlaceholder();
//           }

//           return ListView.builder(
//             primary: false,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemCount: listViewJobRecordList.length,
//             itemBuilder: (context, i) {
//               final listViewJobRecord = listViewJobRecordList[i];
//               return JobCard(index: i, jobRecord: listViewJobRecord);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/illustrations/no_jobs.svg',
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Container(
              // margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(10),
              child: Text(
                "No jobs found",
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
              ),
            ),
          ],
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
