import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'job_card.dart';

class JobHistoryScreenWidget extends StatefulWidget {
  const JobHistoryScreenWidget({Key? key}) : super(key: key);

  @override
  _JobHistoryScreenWidgetState createState() => _JobHistoryScreenWidgetState();
}

class _JobHistoryScreenWidgetState extends State<JobHistoryScreenWidget> {
  List<StreamSubscription?> _streamSubscriptions = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Curr jobs accept\t $currentUserCurrJobsAccepted');
    // print('Past jobs accept\t $currentUserPastJobsAccepted');
    // print('Curr jobs post\t $currentUserCurrJobsPosted');
    // print('Past jobs post\t $currentUserPastJobsPosted');

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
              child: Stack(
                children: [
                  DefaultTabController(
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
                  Align(
                      alignment: Alignment(0, 1),
                      child: NavBarWithMiddleButtonWidget()),
                ],
              ),
            ),
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
          JobListWidget(
            title: "Current Jobs",
            jobList: currentUserCurrJobsPosted!,
          ),
          JobListWidget(
            title: "Past Jobs",
            jobList: currentUserPastJobsPosted!,
          ),
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
          JobListWidget(
            title: "Current Jobs",
            jobList: currentUserCurrJobsAccepted!,
          ),
          JobListWidget(
            title: "Past Jobs",
            jobList: currentUserPastJobsAccepted!,
          ),
        ],
      ),
    );
  }
}

class JobListWidget extends StatelessWidget {
  final String title;
  final List<DocumentReference> jobList;

  const JobListWidget({
    Key? key,
    required this.title,
    required this.jobList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobDesc(desc: title),
        if (ModalRoute.of(context)?.isCurrent ?? true)
          jobList.isEmpty
              ? NoJobPlaceholder()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: jobList.length,
                    itemBuilder: (context, i) =>
                        JobCard(index: i, jobRecord: jobList[i]),
                  ),
                ),
      ],
    );
  }
}
