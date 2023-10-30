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

import '../backend/cache_handler.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _pageSize = 4;
  late ScrollController controller;

  bool _isLoading = false;
  List<JobRecord> _fetchedJobs = [];
  DocumentSnapshot? _lastVisible;
  int totalCount = 0;
  bool jobsFetchedFromCache = false;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    _isLoading = true;
    getTotalItemCount();
    loadData();
    searchFieldController = TextEditingController();
    FFAppState().showFullList = true;
  }

  Future<Null> getTotalItemCount() async {
    print('Current user id: $currentUserUid');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('job')
        .where('posterID', isNotEqualTo: currentUserUid)
        .where('acceptorID', isNull: true)
        .get();
    totalCount = querySnapshot.size;
  }

  Future<void> loadData() async {
    // Try to get cached jobs first
    if (_lastVisible == null) {
      List<JobRecord>? cachedJobs = await CacheHandler.getCachedJobs();
      print("\nCached Jobs:\n-------------------");
      if (cachedJobs != null)
        for (JobRecord rec in cachedJobs) print(rec.reference);

      if (cachedJobs != null && cachedJobs.length >= 4) {
        print("\n|---LOADED JOBS FROM CACHE---|\n");
        setState(() {
          _fetchedJobs = cachedJobs;
          _isLoading = false;
        });
        if (totalCount > cachedJobs.length) return;
      }
    }

    QuerySnapshot? data;
    if (_lastVisible == null) {
      print("\n|---LOADED JOBS FROM CACHE---|\n");
      jobsFetchedFromCache = true;
      data = await FirebaseFirestore.instance
          .collection('job')
          .orderBy('del_time', descending: true)
          .limit(_pageSize)
          .get();
    } else {
      print("\n|---LOADED JOBS FROM SERVER---|\n");

      data = await FirebaseFirestore.instance
          .collection('job')
          .orderBy('del_time', descending: true)
          .startAfter([_lastVisible!['del_time']])
          .limit(_pageSize)
          .get();
    }

    List<JobRecord> jobsToCache = [];
    for (var doc in data.docs) {
      JobRecord jobRecord = JobRecord.getDocumentFromData(
          doc.data() as Map<String, dynamic>, doc.reference);
      if (jobRecord.posterID!.id == currentUserUid ||
          jobRecord.status != 'open') continue;
      jobsToCache.add(jobRecord);
    }
    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];

      if (mounted) {
        setState(() {
          _isLoading = false;
          _fetchedJobs.addAll(jobsToCache);
        });
      }
    }

    if (!jobsFetchedFromCache) await CacheHandler.cacheJobs(jobsToCache);

    return;
  }

  void _scrollListener() {
    if (!_isLoading && _fetchedJobs.length < totalCount) {
      if (controller.position.pixels >= controller.position.maxScrollExtent) {
        print(
            'Scroll reached max (${controller.position.pixels}==${controller.position.maxScrollExtent})');
        setState(() => _isLoading = true);
        loadData();
      }
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
    print('Total jobs:\t$totalCount');

    // print('Current User Email:\t\t $currentUserEmail\n');
    // print('Current User UID:\t\t $currentUserUid\n');
    // print('Current User Display Name:\t\t $currentUserDisplayName\n');
    // print('Current User Photo URL:\t\t $currentUserPhoto\n');
    // print('Current User Phone Number:\t\t $currentPhoneNumber\n');
    // print('Current User Stripe Account ID:\t\t $currentUserStripeAcc\n');
    // print(
    //     'Current User Stripe Verification Status:\t $currentUserStripeVerifiedStatus\n');
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
                    // currentUserStripeVerifiedStatus
                    //     ? Container()
                    //     : VerifyAccountButton(),
                    SearchBar(context),
                    Expanded(
                      child: Stack(
                        children: [
                          JobList(context),
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
    print("--------------------------------");
    print("JOBS FETCHED: ${_fetchedJobs.length}");
    for (int i = 0; i < _fetchedJobs.length; i++)
      print('JOB ${i + 1}:\t${_fetchedJobs[i].reference}');

    _lastVisible != null
        ? print('LAST VISIBLE:${_lastVisible!.id}')
        : print('LAST VISIBLE: NULL');
    print("--------------------------------");

    return FFAppState().showFullList
        ? Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchedJobs.clear();
                _lastVisible = null;
                await CacheHandler.clearJobsCache();
                await loadData();
                print('REFRESHED THIS SHIT');
              },
              child: ListView.builder(
                controller: controller,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _fetchedJobs.length,
                itemBuilder: (_, index) {
                  final jobRef = _fetchedJobs[index].reference;
                  final jobKey =
                      Key('job_${jobRef.id}'); // Unique key for each job

                  // Calculate the gradient color based on index
                  final double t =
                      index / (_fetchedJobs.length - 1); // t ranges from 0 to 1

                  if (index == _fetchedJobs.length - 1) {
                    return Container(
                      // color: gradientColor,
                      margin: EdgeInsets.only(bottom: 85),
                      child: JobCard(
                        key: jobKey, // Assign the unique key to the JobCard
                        jobRef: jobRef,
                      ),
                    );
                  } else if ((index + 1) % _pageSize == 0) {
                    return Container(
                      // color: gradientColor,
                      child: JobCard(
                        key: jobKey, // Assign the unique key to the JobCard
                        jobRef: jobRef,
                      ),
                    );
                  } else {
                    return Container(
                      // color: gradientColor,
                      child: JobCard(
                        key: jobKey, // Assign the unique key to the JobCard
                        jobRef: jobRef,
                      ),
                    );
                  }
                },
              ),
            ))
        : SearchResults(simpleSearchResults: simpleSearchResults);
  }

  Container SearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 8, 0),
        child: TextFormField(
          controller: searchFieldController,
          onChanged: (_) {
            EasyDebounce.debounce('searchFieldController',
                Duration(milliseconds: 100), () => searchInQuery());
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
                  color: FlutterFlowTheme.of(context).primaryColorLight,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: FlutterFlowTheme.of(context).primaryColorLight,
                size: 25,
              ),
              suffixIcon: ClearSearchTextButton(context)),
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
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
            ? () => searchInQuery()
            : () {},
      ),
    );
  }

  void searchInQuery() async {
    String query = searchFieldController!.text
        .toLowerCase(); // assuming searchFieldController is defined

    // Filter _fetchedJobs based on the search query
    List<JobRecord> results = _fetchedJobs.where((jobRecord) {
      return jobRecord.store!.toLowerCase().contains(query) ||
          jobRecord.delLocation!.toLowerCase().contains(query);
    }).toList();

    // Update the state with the search results
    setState(() {
      // If you have a separate variable for search results, update it here
      simpleSearchResults = results;

      FFAppState().showFullList = false; // Update any other necessary state
    });
  }

  void searchJobs() {
    // Converting your _fetchedJobs list into a list of TextSearchItem
    List<TextSearchItem> searchItems = _fetchedJobs
        .map(
          (record) =>
              TextSearchItem(record, [record.store!, record.delLocation!]),
        )
        .toList();

    // Creating a TextSearch object with your search items
    TextSearch textSearch = TextSearch(searchItems);

    // Performing the search with the text from your searchFieldController
    List<TextSearchItem> searchResults =
        textSearch.search(searchFieldController!.text).cast<TextSearchItem>();

    // If you need the results as a list of JobRecord objects again
    List<JobRecord> resultRecords =
        searchResults.map((r) => r.object as JobRecord).toList();

    // Now resultRecords contains the search results, you can use setState or other methods to update your UI
    setState(() {
      simpleSearchResults = resultRecords;
      FFAppState().showFullList = false;
    });
  }
}

class VerifyAccountButton extends StatelessWidget {
  const VerifyAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.65),
      child: ElevatedButton(
        onPressed: () async {
          try {
            print(currentUserStripeAcc);
            final response = await http.post(
                Uri.parse(
                    'https://us-central1-ugrab-17ad6.cloudfunctions.net/generateAccountLink'),
                body: {'stripeAccId': currentUserStripeAcc});

            final jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            jsonResponse['success']
                ? launchURL(jsonResponse['accountUrl'])
                : showAlertDialog(context, 'Error', jsonResponse['error']);
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
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ),
      ),
    );
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
    print('Simple search results: $simpleSearchResults');
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
                      padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
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
      // height: 100,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 26, 0, 0),
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
        final price = jobData['price'].toString();
        // if (jobData['acceptorID'] != "null" ||
        //     jobData['posterID'] == currentUserReference) {
        //   // condition for filtering

        //   // print("posterID:");
        //   // print(jobData['posterID']);
        //   // print(jobData['del_location']);
        //   // print("userref:");
        //   // print(currentUserReference);
        //   return Center();
        // } // dc tp

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
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JobCardStore(store: store),
                        JobCardDelTime(delTime: delTime),
                        JobCardMoney(amount: price),
                        JobCardLocation(location: location)
                      ],
                    ),
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

class JobCardLocation extends StatelessWidget {
  const JobCardLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(3, 0, 10, 0),
            child: FaIcon(
              FontAwesomeIcons.locationPin,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              location,
              style: FlutterFlowTheme.of(context).bodyText1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
      padding: EdgeInsetsDirectional.fromSTEB(7, 5, 5, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/app_launcher_icon.png', //TODO - change
          width: 100,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class JobCardMoney extends StatelessWidget {
  const JobCardMoney({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final String amount;

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
            amount,
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
      padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 5),
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
