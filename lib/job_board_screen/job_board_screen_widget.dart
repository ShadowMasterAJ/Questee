// ignore_for_file: non_constant_identifier_names

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:text_search/text_search.dart';
import 'package:u_grabv1/components/alert_dialog_box.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';

import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class JobBoardScreenWidget extends StatefulWidget {
  const JobBoardScreenWidget({Key? key}) : super(key: key);

  @override
  _JobBoardScreenWidgetState createState() => _JobBoardScreenWidgetState();
}

class _JobBoardScreenWidgetState extends State<JobBoardScreenWidget> {
  List<JobRecord> simpleSearchResults = [];
  TextEditingController? searchFieldController;

  List<StreamSubscription?> _streamSubscriptions = [];
  // Query? _pagingQuery; // = FirebaseFirestore.instance.collection('job');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  Query? _pagingQuery;
  static const _pageSize = 24; // approx 3 units for one card
  String? _lastDelLoc = '';

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(() {
    //   final position =
    //       _scrollController.offset / _scrollController.position.maxScrollExtent;
    //   if (position >= 0.8 && !_isLoadingMore) {
    //     loadMoreData();
    //   }
    // });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0 &&
          !_isLoadingMore) {
        loadMoreData(); // reallly ideally this works but i can't confirm 100%
      }
    });

    searchFieldController = TextEditingController();
    FFAppState().showFullList = true;

    _pagingQuery = FirebaseFirestore.instance
        .collection('job')
        .orderBy('del_location')
        .limit(_pageSize); // Set initial limit
  }

  void loadMoreData() async {
    if (_pagingQuery != null && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      final newDocs = await _pagingQuery!.startAfter([_lastDelLoc]).get();

      setState(() {
        _isLoadingMore = false;
        if (newDocs.docs.isNotEmpty) {
          final lastDoc = newDocs.docs.last;
          final lastDocData = lastDoc.data() as Map<String, dynamic>?;

          if (lastDocData != null) {
            _lastDelLoc = lastDocData['del_location'] as String?;
          }
        } else {
          _pagingQuery = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    searchFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Current User Email:\t\t $currentUserEmail\n');
    print('Current User UID:\t\t $currentUserUid\n');
    print('Current User Display Name:\t\t $currentUserDisplayName\n');
    print('Current User Photo URL:\t\t $currentUserPhoto\n');
    print('Current User Phone Number:\t\t $currentPhoneNumber\n');
    print('Current User Stripe Account ID:\t\t $currentUserStripeAcc\n');
    print(
        'Current User Stripe Verification Status:\t $currentUserStripeVerifiedStatus\n');
    // print(
    //     'Current User Current Jobs Accepted:\t $currentUserCurrJobsAccepted\n');
    // print('Current User Current Jobs Posted:\t\t $currentUserCurrJobsPosted\n');
    // print(
    //     'Current User Past Jobs Accepted:\t\t $currentUserPastJobsAccepted\n');
    // print('Current User Past Jobs Posted:\t\t $currentUserPastJobsPosted\n');

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      // extendBody: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    JobBoardHeader(),
                    SearchBar(context),
                    Expanded(
                      child: Stack(
                        children: [
                          JobList(context),
                          currentUserStripeVerifiedStatus
                              ? Container()
                              : Align(
                                  alignment: Alignment(0, 0.65),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        print(currentUserStripeAcc);
                                        final response = await http.post(
                                            Uri.parse(
                                                'https://us-central1-ugrab-17ad6.cloudfunctions.net/generateAccountLink'),
                                            body: {
                                              'stripeAccId':
                                                  currentUserStripeAcc
                                            });

                                        final jsonResponse =
                                            jsonDecode(response.body);
                                        print(jsonResponse);
                                        jsonResponse['success']
                                            ? launchURL(
                                                jsonResponse['accountUrl'])
                                            : showAlertDialog(context, 'Error',
                                                jsonResponse['error']);
                                        //TODO - upon deeplinking, based on a some flag, show the below alert
                                        showAlertDialog(context, 'Success!',
                                            'You have been verified by Stripe and are now eligible to post/accept jobs');
                                      } catch (e) {
                                        showAlertDialog(context, 'Error', '$e');
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Verify to Receive Payouts',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                ),
                          Align(
                            alignment: Alignment(0, 1),
                            child: NavBarWithMiddleButtonWidget(),
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
    );
  }

  Widget JobList(BuildContext context) {
    return FFAppState().showFullList
        ? Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
              stream: () {
                // Define a queryBuilder function to create Firestore queries
                final Query<Map<String, dynamic>> Function(
                        Query<Map<String, dynamic>>) queryBuilder =
                    (jobRecordCollection) => jobRecordCollection;

                // Build the Firestore query for retrieving job records
                final query = queryBuilder(FirebaseFirestore.instance
                        .collection('job')
                        // .where('posterID', isNotEqualTo: currentUserReference)
                        .orderBy('del_location')
                        .startAfter([_lastDelLoc]).limit(_pageSize)

                    // .where('acceptorID', isNull: true)
                    // the above doesn't work, but if you ctrl-f 'dc tp',
                    //you will find the condition that does
                    );
                return query.snapshots();
              }(),
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
                    child: Text('Error fetching data'),
                  );
                }

                final jobDocs = snapshot.data!.docs;

                if (jobDocs.isNotEmpty) {
                  final lastJobData = jobDocs[jobDocs.length - 1].data();
                  _lastDelLoc = lastJobData['del_location'] as String;
                }

                final jobSnapshot = snapshot.data;
                if (jobSnapshot == null || jobSnapshot.docs.isEmpty) {
                  return NoJobsIllustration();
                }

                return ListView.builder(
                  // controller: _scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: jobSnapshot.docs.length + 1,
                  itemBuilder: (context, index) {
                    // final jobData = jobSnapshot.docs[index].data();
                    if (index < jobSnapshot.docs.length &&
                        _pagingQuery != null) {
                      // final jobData = jobSnapshot.docs[index].data();
                      final jobRef = jobSnapshot.docs[index].reference;
                      return JobCard(jobRef: jobRef);
                    } else {
                      return Container();
                      // return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          )
        : SearchResults(simpleSearchResults: simpleSearchResults);
  }

  Container SearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 8, 0),
                  child: TextFormField(
                    controller: searchFieldController,
                    onChanged: (_) {
                      EasyDebounce.debounce(
                          'searchFieldController',
                          Duration(milliseconds: 100),
                          () async => await searchInQuery());
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: 'Search Jobs',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryColorLight,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).primaryColorLight,
                          size: 25,
                        ),
                        suffixIcon: ClearSearchTextButton(context)),
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                // ClearSearchTextButton(context),
              ],
            ),
          ),
          SearchButton(context),
        ],
      ),
    );
  }

  InkWell ClearSearchTextButton(BuildContext context) {
    return InkWell(
      onTap: searchFieldController!.text.isNotEmpty
          ? () async => setState(() {
                searchFieldController!.clear();
                FFAppState().showFullList = true;
              })
          : () {},
      child: Icon(
        Icons.clear_outlined,
        color: FlutterFlowTheme.of(context).primaryColorLight,
        size: 24,
      ),
    );
  }

  Padding SearchButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
      child: FlutterFlowIconButton(
        borderColor: Color(0x0096669E),
        borderRadius: 10,
        borderWidth: 1,
        buttonSize: 48,
        fillColor: FlutterFlowTheme.of(context).primaryColor,
        icon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: FlutterFlowTheme.of(context).primaryColorLight,
          size: 24,
        ),
        onPressed: searchFieldController!.text.isNotEmpty
            ? () async => await searchInQuery()
            : () {},
      ),
    );
  }

  Future<void> searchInQuery() async {
    await queryJobRecordOnce()
        .then(
          (records) => simpleSearchResults = TextSearch(
            records
                .map(
                  (record) => TextSearchItem(
                      record, [record.store!, record.delLocation!]),
                )
                .toList(),
          ).search(searchFieldController!.text).map((r) => r.object).toList(),
        )
        .onError((_, __) => simpleSearchResults = [])
        .whenComplete(() => setState(() {}));

    setState(() => FFAppState().showFullList = false);
  }
}

class NoJobsIllustration extends StatelessWidget {
  const NoJobsIllustration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              'assets/illustrations/no_jobs.svg',
              width: MediaQuery.of(context).size.width * 0.7,
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

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.simpleSearchResults,
  }) : super(key: key);

  final List<JobRecord> simpleSearchResults;

  @override
  Widget build(BuildContext context) {
    print(simpleSearchResults);
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
      child: Builder(
        builder: (context) {
          final searcResults = simpleSearchResults;
          if (searcResults.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/illustrations/no_jobs.svg',
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                      decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: searcResults.length,
              itemBuilder: (context, index) {
                final searcResultsItem = searcResults[index];
                return JobCard(jobRef: searcResultsItem.reference);
              });
        },
      ),
    );
  }
}

class JobBoardHeader extends StatelessWidget {
  const JobBoardHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Spacer(),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 26, 0, 12),
              child: Text(
                'Job Board.',
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                    ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({
    Key? key,
    required this.jobRef,
  }) : super(key: key);

  final DocumentReference jobRef;

  Future<Map<String, Object>> getJobData() async {
    final DocumentSnapshot snapshot = await jobRef.get();

    final data = snapshot.data() as Map<String, dynamic>?;

    return {
      'del_location': data!['del_location'].toString(),
      'del_time': data['del_time'].toDate(),
      'items': data['items'],
      'note': data['note'],
      'posterID': data['posterID'],
      'acceptorID':
          data.containsKey('acceptorID') ? data['acceptorID'] : "null",
      'store': data['store'],
      'status': data['status'],
      'type': data['type'],
      'price': data['price'],
      'verificationImages': data.containsKey('verificationImages')
          ? data['verificationImages']
          : "null"
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object>>(
      future: getJobData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center();
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
        final store = jobData['store'].toString();

        if (jobData['acceptorID'] != "null" ||
            jobData['posterID'] == currentUserReference) {
          // condition for filtering

          // print("posterID:");
          // print(jobData['posterID']);
          // print(jobData['del_location']);
          // print("userref:");
          // print(currentUserReference);
          return Center();
        } // dc tp

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                'JobDetailScreenAcceptor',
                queryParams: {
                  'jobRef':
                      serializeParam(jobRef, ParamType.DocumentReference)!,
                },
              );
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
                  JobCardImage(),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JobCardStore(store: store),
                      JobCardDelTime(delTime: delTime),
                      JobCardMoney(location: location),
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

class JobCardImage extends StatelessWidget {
  const JobCardImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class JobCardMoney extends StatelessWidget {
  const JobCardMoney({
    Key? key,
    required this.location,
  }) : super(key: key);

  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: FaIcon(
              FontAwesomeIcons.moneyBill,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 22,
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

class JobCardDelTime extends StatelessWidget {
  const JobCardDelTime({
    Key? key,
    required this.delTime,
  }) : super(key: key);

  final DateTime delTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
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

class JobCardStore extends StatelessWidget {
  const JobCardStore({
    Key? key,
    required this.store,
  }) : super(key: key);

  final String store;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            store,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}
