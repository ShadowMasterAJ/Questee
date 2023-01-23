import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class JobHistoryScreenWidget extends StatefulWidget {
  const JobHistoryScreenWidget({Key? key}) : super(key: key);

  @override
  _JobHistoryScreenWidgetState createState() => _JobHistoryScreenWidgetState();
}

class _JobHistoryScreenWidgetState extends State<JobHistoryScreenWidget> {
  PagingController<DocumentSnapshot?, JobRecord>? _pagingController;
  Query? _pagingQuery;
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(flex: 2),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 12),
                                child: Text(
                                  'Job History.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .title1
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 36,
                                      ),
                                ),
                              ),
                              Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 650,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: DefaultTabController(
                                      length: 2,
                                      initialIndex: 0,
                                      child: Column(
                                        children: [
                                          TabBar(
                                            labelColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryColor,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .subtitle2,
                                            indicatorColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryColor,
                                            tabs: [
                                              Tab(
                                                text: 'Jobs Accepted',
                                              ),
                                              Tab(
                                                text: 'Jobs Posted',
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -0.85, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 15,
                                                                    0, 0),
                                                        child: Text(
                                                          'Current Job(s)',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFFC6C5C5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        // height: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0,
                                                                      10,
                                                                      0,
                                                                      10),
                                                          child: StreamBuilder<
                                                              List<JobRecord>>(
                                                            stream:
                                                                queryJobRecord(
                                                              limit: 3,
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<JobRecord>
                                                                  listViewJobRecordList =
                                                                  snapshot
                                                                      .data!;

                                                              if (listViewJobRecordList
                                                                  .isEmpty) {
                                                                return Center(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/not_stonks.jpg',
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          600,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    listViewJobRecordList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        listViewIndex) {
                                                                  final listViewJobRecord =
                                                                      listViewJobRecordList[
                                                                          listViewIndex];

                                                                  if (listViewJobRecord
                                                                          .status ==
                                                                      'ongoing') {
                                                                    if (listViewJobRecord
                                                                            .acceptorID!
                                                                            .id ==
                                                                        currentUserUid) {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            5,
                                                                            10,
                                                                            5),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            if (listViewJobRecord.posterID ==
                                                                                currentUserReference) {
                                                                              context.pushNamed('JobDetailScreenPoster');
                                                                            } else {
                                                                              context.pushNamed('JobDetailScreenGrabber');
                                                                            }
                                                                          },
                                                                          child:
                                                                              Card(
                                                                            clipBehavior:
                                                                                Clip.antiAliasWithSaveLayer,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryColor,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    child: Image.network(
                                                                                      'https://picsum.photos/seed/689/600',
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 24,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            listViewJobRecord.store!,
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 24,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                              dateTimeFormat('jm', listViewJobRecord.delTime),
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 22,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            listViewJobRecord.delLocation!,
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
                                                                    } else {
                                                                      return Text(
                                                                          '.');
                                                                    }
                                                                  } else {
                                                                    return Text(
                                                                        '.');
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -0.85, 0),
                                                      child: Text(
                                                        'Historical Job(s)',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: Color(
                                                                      0xFFC6C5C5),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0,
                                                                      10,
                                                                      0,
                                                                      12),
                                                          child: StreamBuilder<
                                                              List<JobRecord>>(
                                                            stream:
                                                                queryJobRecord(),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<JobRecord>
                                                                  historicalListViewJobRecordList =
                                                                  snapshot
                                                                      .data!;
                                                              if (historicalListViewJobRecordList
                                                                  .isEmpty) {
                                                                return Center(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/not_stonks.jpg',
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                  ),
                                                                );
                                                              }

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    historicalListViewJobRecordList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        historicalListViewIndex) {
                                                                  final historicalListViewJobRecord =
                                                                      historicalListViewJobRecordList[
                                                                          historicalListViewIndex];

                                                                  if (historicalListViewJobRecord
                                                                          .status ==
                                                                      'completed') {
                                                                    if (historicalListViewJobRecord
                                                                            .acceptorID!
                                                                            .id ==
                                                                        currentUserUid) {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10,
                                                                            5,
                                                                            10,
                                                                            5),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            if (historicalListViewJobRecord.posterID ==
                                                                                currentUserReference) {
                                                                              context.pushNamed('JobDetailScreenPoster');
                                                                            } else {
                                                                              context.pushNamed('JobDetailScreenGrabber');
                                                                            }
                                                                          },
                                                                          child:
                                                                              Card(
                                                                            clipBehavior:
                                                                                Clip.antiAliasWithSaveLayer,
                                                                            color:
                                                                                Color(0xFF6C686C),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    child: Image.network(
                                                                                      'https://picsum.photos/seed/689/600',
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 24,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            historicalListViewJobRecord.store!,
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 24,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                              dateTimeFormat('jm', historicalListViewJobRecord.delTime),
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
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              size: 22,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            historicalListViewJobRecord.delLocation!,
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
                                                                    } else {
                                                                      return Text(
                                                                          ".");
                                                                    }
                                                                  }
                                                                  return Text(
                                                                      ".");
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -0.85, 0.7),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 15,
                                                                    0, 0),
                                                        child: Text(
                                                          'Current Job(s)',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFFC6C5C5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 10),
                                                        child: StreamBuilder<
                                                            List<JobRecord>>(
                                                          stream:
                                                              queryJobRecord(),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.

                                                            if (!snapshot
                                                                .hasData) {
                                                              return Center(
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 50,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            List<JobRecord>
                                                                listViewJobRecordList =
                                                                snapshot.data!;
                                                            if (listViewJobRecordList
                                                                .isEmpty) {
                                                              return ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/not_stonks.jpg',
                                                                  width: double
                                                                      .infinity,
                                                                  height: 100,
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  listViewJobRecordList
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  listViewIndex) {
                                                                final listViewJobRecord =
                                                                    listViewJobRecordList[
                                                                        listViewIndex];
                                                                if (listViewJobRecord
                                                                            .status ==
                                                                        'ongoing' ||
                                                                    listViewJobRecord
                                                                            .status ==
                                                                        'untaken') {
                                                                  print(listViewJobRecord
                                                                      .posterID);
                                                                  print(
                                                                      currentUserUid);
                                                                  if (listViewJobRecord
                                                                          .posterID!
                                                                          .id ==
                                                                      currentUserUid) {
                                                                    return Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10,
                                                                              5,
                                                                              10,
                                                                              5),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          String
                                                                              STORE =
                                                                              listViewJobRecord.store!;
                                                                          String
                                                                              TIME =
                                                                              valueOrDefault<String>(
                                                                            dateTimeFormat('jm',
                                                                                listViewJobRecord.delTime),
                                                                            'ASAP',
                                                                          );
                                                                          String
                                                                              NOTE =
                                                                              listViewJobRecord.delLocation!;

                                                                          print(
                                                                              serializeParam(
                                                                            STORE,
                                                                            ParamType.String,
                                                                          ));
                                                                          print(
                                                                              TIME);
                                                                          print(
                                                                              NOTE);
                                                                          if ((listViewJobRecord.posterID!.id) ==
                                                                              (currentUserReference!.id)) {
                                                                            print("THIS IS THE POSTER IF STATEMENT");

                                                                            context.pushNamed(
                                                                              'JobDetailScreenPoster',
                                                                              queryParams: {
                                                                                'store': serializeParam(
                                                                                  STORE,
                                                                                  ParamType.String,
                                                                                )!,
                                                                                'time': serializeParam(
                                                                                  TIME,
                                                                                  ParamType.String,
                                                                                )!,
                                                                                'note': serializeParam(
                                                                                  NOTE,
                                                                                  ParamType.String,
                                                                                )!,
                                                                              },
                                                                              // extra: {
                                                                              //   'store': listViewJobRecord.store!,
                                                                              //   'time': valueOrDefault<String>(
                                                                              //     dateTimeFormat('jm',
                                                                              //         listViewJobRecord.delTime),
                                                                              //     'ASAP',
                                                                              //   ),
                                                                              //   'note': listViewJobRecord.delLocation!
                                                                              // },
                                                                            );
                                                                          } else {
                                                                            print("THIS IS THE GRABBER ELSE STATEMENT");
                                                                            context.pushNamed('JobDetailScreenGrabber', queryParams: {
                                                                              'store': serializeParam(
                                                                                STORE,
                                                                                ParamType.String,
                                                                              )!,
                                                                              'time': serializeParam(
                                                                                TIME,
                                                                                ParamType.String,
                                                                              )!,
                                                                              'note': serializeParam(
                                                                                NOTE,
                                                                                ParamType.String,
                                                                              )!,
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Card(
                                                                          clipBehavior:
                                                                              Clip.antiAliasWithSaveLayer,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryColor,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  child: Image.network(
                                                                                    'https://picsum.photos/seed/689/600',
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
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            size: 24,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          listViewJobRecord.store!,
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
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            size: 24,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            dateTimeFormat('jm', listViewJobRecord.delTime),
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
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            size: 22,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          listViewJobRecord.delLocation!,
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
                                                                  } else {
                                                                    return Text(
                                                                        ".");
                                                                  }
                                                                }
                                                                return Text(
                                                                    ".");
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -0.85, 0.7),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 15,
                                                                    0, 0),
                                                        child: Text(
                                                          'Historical Job(s)',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFFC6C5C5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 340,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 12),
                                                        child: PagedListView<
                                                            DocumentSnapshot<
                                                                Object?>?,
                                                            JobRecord>(
                                                          pagingController: () {
                                                            final Query<Object?> Function(
                                                                    Query<
                                                                        Object?>)
                                                                queryBuilder =
                                                                (jobRecord) =>
                                                                    jobRecord;
                                                            if (_pagingController !=
                                                                null) {
                                                              final query =
                                                                  queryBuilder(
                                                                      JobRecord
                                                                          .collection);
                                                              if (query !=
                                                                  _pagingQuery) {
                                                                // The query has changed
                                                                _pagingQuery =
                                                                    query;
                                                                _streamSubscriptions
                                                                    .forEach((s) =>
                                                                        s?.cancel());
                                                                _streamSubscriptions
                                                                    .clear();
                                                                _pagingController!
                                                                    .refresh();
                                                              }
                                                              return _pagingController!;
                                                            }

                                                            _pagingController =
                                                                PagingController(
                                                                    firstPageKey:
                                                                        null);
                                                            _pagingQuery =
                                                                queryBuilder(
                                                                    JobRecord
                                                                        .collection);
                                                            _pagingController!
                                                                .addPageRequestListener(
                                                                    (nextPageMarker) {
                                                              queryJobRecordPage(
                                                                queryBuilder:
                                                                    (jobRecord) =>
                                                                        jobRecord,
                                                                nextPageMarker:
                                                                    nextPageMarker,
                                                                pageSize: 25,
                                                                isStream: true,
                                                              ).then((page) {
                                                                _pagingController!
                                                                    .appendPage(
                                                                  page.data,
                                                                  page.nextPageMarker,
                                                                );
                                                                final streamSubscription = page
                                                                    .dataStream
                                                                    ?.listen(
                                                                        (data) {
                                                                  final itemIndexes = _pagingController!
                                                                      .itemList!
                                                                      .asMap()
                                                                      .map((k, v) => MapEntry(
                                                                          v.reference
                                                                              .id,
                                                                          k));
                                                                  data.forEach(
                                                                      (item) {
                                                                    final index =
                                                                        itemIndexes[item
                                                                            .reference
                                                                            .id];
                                                                    final items =
                                                                        _pagingController!
                                                                            .itemList!;
                                                                    if (index !=
                                                                        null) {
                                                                      items.replaceRange(
                                                                          index,
                                                                          index +
                                                                              1,
                                                                          [
                                                                            item
                                                                          ]);
                                                                      _pagingController!
                                                                          .itemList = {
                                                                        for (var item
                                                                            in items)
                                                                          item.reference:
                                                                              item
                                                                      }
                                                                          .values
                                                                          .toList();
                                                                    }
                                                                  });
                                                                  setState(
                                                                      () {});
                                                                });
                                                                _streamSubscriptions
                                                                    .add(
                                                                        streamSubscription);
                                                              });
                                                            });
                                                            return _pagingController!;
                                                          }(),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          builderDelegate:
                                                              PagedChildBuilderDelegate<
                                                                  JobRecord>(
                                                            // Customize what your widget looks like when it's loading the first page.
                                                            firstPageProgressIndicatorBuilder:
                                                                (_) => Center(
                                                              child: SizedBox(
                                                                width: 50,
                                                                height: 50,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                            noItemsFoundIndicatorBuilder:
                                                                (_) => Center(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/not_stonks.jpg',
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                              ),
                                                            ),
                                                            itemBuilder: (context,
                                                                _,
                                                                historicalListViewIndex) {
                                                              final historicalListViewJobRecord =
                                                                  _pagingController!
                                                                          .itemList![
                                                                      historicalListViewIndex];
                                                              if (historicalListViewJobRecord
                                                                      .status ==
                                                                  'completed') {
                                                                if (historicalListViewJobRecord
                                                                        .posterID!
                                                                        .id ==
                                                                    currentUserUid) {
                                                                  return Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            5,
                                                                            10,
                                                                            5),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (historicalListViewJobRecord.posterID ==
                                                                            currentUserReference) {
                                                                          print(
                                                                              "hello7");
                                                                          context
                                                                              .pushNamed('JobDetailScreenPoster');
                                                                        } else {
                                                                          print(
                                                                              "hello8");
                                                                          context
                                                                              .pushNamed('JobDetailScreenGrabber');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Card(
                                                                        clipBehavior:
                                                                            Clip.antiAliasWithSaveLayer,
                                                                        color: Color(
                                                                            0xFF6C686C),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                child: Image.network(
                                                                                  'https://picsum.photos/seed/689/600',
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
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          size: 24,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        historicalListViewJobRecord.store!,
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
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          size: 24,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        valueOrDefault<String>(
                                                                                          dateTimeFormat('jm', historicalListViewJobRecord.delTime),
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
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          size: 22,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        historicalListViewJobRecord.delLocation!,
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
                                                                } else {
                                                                  return Text(
                                                                      ".");
                                                                }
                                                              }
                                                              return Text(".");
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
