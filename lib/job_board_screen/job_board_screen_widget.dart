// ignore_for_file: non_constant_identifier_names

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:text_search/text_search.dart';

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
  PagingController<DocumentSnapshot?, JobRecord>? _pagingController;

  List<StreamSubscription?> _streamSubscriptions = [];
  Query? _pagingQuery; // = FirebaseFirestore.instance.collection('job');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
    FFAppState().showFullList = true;
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    searchFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      bottomNavigationBar: NavBarWithMiddleButtonWidget(),
      extendBody: true,
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
                    JobList(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded JobList(BuildContext context) {
    //FIXME - filter properly and fix pagination

    // .where('posterID', isNotEqualTo: currentUserReference)
    // .where("acceptorID", isEqualTo: null));
    return Expanded(
      child: FFAppState().showFullList
          ? Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
              child: PagedListView<DocumentSnapshot<Object?>?, JobRecord>(
                // Use the pagingController to load and display paginated data
                pagingController: () {
                  print('CURRENT USER REF: $currentUserReference');
                  // Define a queryBuilder function to create Firestore queries
                  final Query<Object?> Function(Query<Object?>) queryBuilder =
                      (jobRecordCollection) => jobRecordCollection;

                  // If the pagingController already exists, refresh the data and return it
                  if (_pagingController != null) {
                    // Build the Firestore query for retrieving job records
                    final query = queryBuilder(
                      JobRecord.collection
                          .where('posterID', isNotEqualTo: currentUserReference)
                          .where('acceptorID', isEqualTo: null),
                    );

                    // If the query has changed since the last time the data was loaded, refresh the data
                    if (query != _pagingQuery) {
                      _pagingQuery = query;

                      // Cancel any existing stream subscriptions and clear the list of subscriptions
                      _streamSubscriptions.forEach((s) => s?.cancel());
                      _streamSubscriptions.clear();

                      // Refresh the data in the pagingController
                      _pagingController!.refresh();
                    }

                    // Return the existing pagingController
                    return _pagingController!;
                  }

                  // If the pagingController doesn't exist, create it
                  _pagingController = PagingController(firstPageKey: null);

                  // Build the Firestore query for retrieving job records
                  _pagingQuery = queryBuilder(JobRecord.collection
                      .where('posterID', isNotEqualTo: currentUserReference)
                      .where('acceptorID', isEqualTo: null));

                  // Listen for page requests and load data from Firestore
                  _pagingController!.addPageRequestListener((nextPageMarker) {
                    queryJobRecordPage(
                      queryBuilder: queryBuilder,
                      nextPageMarker: nextPageMarker,
                      pageSize: 4,
                      isStream: true,
                    ).then((page) {
                      // Append the new page of data to the list of items in the pagingController
                      _pagingController!.appendPage(
                        page.data,
                        page.nextPageMarker,
                      );

                      // Listen for updates to the data stream and update the UI
                      final streamSubscription =
                          page.dataStream?.listen((data) {
                        data.forEach((item) {
                          // Find the index of the item in the itemList
                          final itemIndexes = _pagingController!.itemList!
                              .asMap()
                              .map((k, v) => MapEntry(v.reference.id, k));
                          final index = itemIndexes[item.reference.id];
                          final items = _pagingController!.itemList!;

                          // Replace the old version of the item with the new version in the itemList
                          if (index != null) {
                            items.replaceRange(index, index + 1, [item]);
                            _pagingController!.itemList = {
                              for (var item in items) item.reference: item
                            }.values.toList();
                          }
                        });

                        // Update the UI to reflect the changes
                        setState(() {});
                      });

                      // Add the streamSubscription to the list of subscriptions
                      _streamSubscriptions.add(streamSubscription);
                    });
                  });

                  // Return the newly created pagingController
                  return _pagingController!;
                }(),

                // Configure the PagedListView
                primary: true,
                scrollDirection: Axis.vertical,
                builderDelegate: PagedChildBuilderDelegate<JobRecord>(

                    // Display a progress indicator while the first page of data is being loaded
                    firstPageProgressIndicatorBuilder: (_) => Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                          ),
                        ),

                    // Display a custom widget when there are

                    noItemsFoundIndicatorBuilder: (_) => NoJobsIllustration(),
                    itemBuilder: (context, job, listViewIndex) {
                      return JobCard(jobRef: job.reference);
                      // listViewJobRecord.acceptorID == null &&
                      //         listViewJobRecord.posterID != currentUserReference
                      //     ? JobCard(jobRecord: listViewJobRecord.reference)
                      //     : SizedBox.shrink();
                    }),
              ))
          : SearchResults(simpleSearchResults: simpleSearchResults),
    );
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
