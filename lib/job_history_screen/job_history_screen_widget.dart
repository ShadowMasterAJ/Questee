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

  final DocumentReference jobRecord;
  final int index;

  Future<Map<String, Object>> getJobData() async {
    print("JOBRECORD: $jobRecord");
    final DocumentSnapshot snapshot = await jobRecord.get();

    final data = snapshot.data() as Map<String, dynamic>?;

    return {
      'del_location': data!['del_location'].toString(),
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
    return FutureBuilder<Map<String, Object>>(
      future: getJobData(),
      builder: (context, snapshot) {
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

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: InkWell(
            onTap: () {
              if (posterID.id == currentUserReference!.id) {
                context.pushNamed(
                  'JobDetailScreenPoster',
                  queryParams: {
                    'jobRef':
                        serializeParam(jobRecord, ParamType.DocumentReference)!,
                  },
                );
              } else {
                print("PUSHING JOBRECORD: $jobRecord");
                context.pushNamed(
                  'JobDetailScreenAcceptor',
                  queryParams: {
                    'jobRef':
                        serializeParam(jobRecord, ParamType.DocumentReference)!,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Icon(
                                Icons.shopping_cart,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 24,
                              ),
                            ),
                            Text(
                              store,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Icon(
                                Icons.access_time,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 24,
                              ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                dateTimeFormat('jm', delTime),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: FaIcon(
                                FontAwesomeIcons.moneyBill,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 22,
                              ),
                            ),
                            Text(
                              location,
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
      },
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
          if (ModalRoute.of(context)?.isCurrent ?? false)
            JobCategoryBuilder(jobCat: "curr_jobs_posted"),
          JobDesc(desc: "Past Jobs"),
          if (ModalRoute.of(context)?.isCurrent ?? false)
            JobCategoryBuilder(jobCat: "past_jobs_posted"),
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
          if (ModalRoute.of(context)?.isCurrent ?? true)
            JobCategoryBuilder(jobCat: "curr_jobs_accepted"),
          JobDesc(desc: "Past Jobs"),
          if (ModalRoute.of(context)?.isCurrent ?? true)
            JobCategoryBuilder(jobCat: "past_jobs_accepted"),
        ],
      ),
    );
  }
}

class JobCategoryBuilder extends StatefulWidget {
  final String jobCat;

  const JobCategoryBuilder({Key? key, required this.jobCat}) : super(key: key);

  @override
  _JobCategoryBuilderState createState() => _JobCategoryBuilderState();
}

class _JobCategoryBuilderState extends State<JobCategoryBuilder> {
  Future<List<DocumentReference>> _getJobRecords() async {
    try {
      final snapshot = await currentUserReference!.get();
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(widget.jobCat)) {
        final userJobCat = List<DocumentReference>.from(data[widget.jobCat]);
        return userJobCat.map((record) => record).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return []; // or any other fallback value
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentReference>>(
      future: _getJobRecords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final _jobRecords = snapshot.data;
          return _jobRecords!.isEmpty
              ? NoJobPlaceholder()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _jobRecords.length,
                    itemBuilder: (context, i) =>
                        JobCard(index: i, jobRecord: _jobRecords[i]),
                  ),
                );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
