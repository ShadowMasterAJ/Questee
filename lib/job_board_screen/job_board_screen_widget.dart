import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/nav_bar_with_middle_button_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:text_search/text_search.dart';

class JobBoardScreenWidget extends StatefulWidget {
  const JobBoardScreenWidget({Key? key}) : super(key: key);

  @override
  _JobBoardScreenWidgetState createState() => _JobBoardScreenWidgetState();
}

class _JobBoardScreenWidgetState extends State<JobBoardScreenWidget> {
  List<JobRecord> _simpleSearchResults = [];
  TextEditingController? searchFieldController;
  PagingController<DocumentSnapshot?, JobRecord>? pagingController;
  Query? pagingQuery;
  List<StreamSubscription?> _streamSubscriptions = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _updateSearchResults(List<JobRecord> resultOutput) {
    setState(() {
      _simpleSearchResults = resultOutput;
    });
  }

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                // flex: 7,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    JobBoardHeader(),
                    SearchHeader(
                        updateSearchResults: _updateSearchResults,
                        searchFieldController: searchFieldController),
                    // SizedBox(
                    //   height: 200,
                    ListOfJobs(
                        simpleSearchResults: _simpleSearchResults,
                        searchFieldController: searchFieldController,
                        pagingController: pagingController,
                        pagingQuery: pagingQuery),
                    // ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: NavBarWithMiddleButtonWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({
    Key? key,
    required this.listViewJobRecord,
    required this.index,
  }) : super(key: key);

  final JobRecord listViewJobRecord;
  final int index;

  @override
  Widget build(BuildContext context) {
    int index = this.index;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
      child: InkWell(
        onTap: () async {
          String indexStr = index.toString();

          if ((listViewJobRecord.posterID!.id) == (currentUserReference!.id)) {
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
                  //TODO - update with some specific image
                  child: Image.asset(
                    "assets/images/app_launcher_icon.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardEntry(
                      icon: Icons.shopping_cart,
                      store: listViewJobRecord.store!,
                    ),
                    CardEntry(
                      icon: Icons.access_time,
                      store: valueOrDefault<String>(
                        dateTimeFormat('jm', listViewJobRecord.delTime),
                        'ASAP',
                      ),
                    ),
                    CardEntry(
                      icon: FontAwesomeIcons.locationArrow,
                      store: listViewJobRecord.delLocation!,
                      lines: 2,
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
}

class ListOfJobs extends StatefulWidget {
  ListOfJobs(
      {Key? key,
      required this.searchFieldController,
      required this.pagingQuery,
      required this.pagingController,
      required this.simpleSearchResults})
      : super(key: key);
  var searchFieldController;
  final simpleSearchResults;
  var pagingController;
  var pagingQuery;

  // final streamSubscriptions = [];
  @override
  ListOfJobsState createState() => ListOfJobsState();
}

class ListOfJobsState extends State<ListOfJobs> {
  // List<JobRecord> simpleSearchResults = [];
  List<StreamSubscription?> streamSubscriptions = [];
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        FFAppState().showFullList
            ? Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
                child: Expanded(
                  child: PagedListView<DocumentSnapshot<Object?>?, JobRecord>(
                    pagingController: () {
                      final Query<Object?> Function(Query<Object?>)
                          queryBuilder = (jobRecord) => jobRecord;
                      if (widget.pagingController != null) {
                        final query = queryBuilder(JobRecord.collection);
                        if (query != widget.pagingQuery) {
                          // The query has changed
                          widget.pagingQuery = query;
                          streamSubscriptions.forEach((s) => s?.cancel());
                          streamSubscriptions.clear();
                          widget.pagingController!.refresh();
                        }
                        return widget.pagingController!;
                      }

                      widget.pagingController =
                          PagingController(firstPageKey: null);
                      widget.pagingQuery = queryBuilder(JobRecord.collection);
                      widget.pagingController!
                          .addPageRequestListener((nextPageMarker) {
                        queryJobRecordPage(
                          queryBuilder: (jobRecord) => jobRecord,
                          nextPageMarker: nextPageMarker,
                          pageSize: 25,
                          isStream: true,
                        ).then((page) {
                          widget.pagingController!.appendPage(
                            page.data,
                            page.nextPageMarker,
                          );
                          final streamSubscription =
                              page.dataStream?.listen((data) {
                            final itemIndexes = widget
                                .pagingController!.itemList!
                                .asMap()
                                .map((k, v) => MapEntry(v.reference.id, k));
                            data.forEach((item) {
                              final index = itemIndexes[item.reference.id];
                              final items = widget.pagingController!.itemList!;
                              if (index != null) {
                                items.replaceRange(index, index + 1, [item]);
                                widget.pagingController!.itemList = {
                                  for (var item in items) item.reference: item
                                }.values.toList();
                              }
                            });
                            setState(() {});
                          });
                          streamSubscriptions.add(streamSubscription);
                        });
                      });
                      return widget.pagingController!;
                    }(),
                    primary: false,
                    shrinkWrap: true,
                    // TODO: figure out why this scroll (only within the bottom part of page) isn't working
                    // scrollDirection: Axis.vertical,
                    builderDelegate: PagedChildBuilderDelegate<JobRecord>(
                      // Customize what your widget looks like when it's loading the first page.
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/not_stonks.jpg',
                            width: double.infinity,
                          ),
                        ),
                      ),
                      itemBuilder: (context, _, listViewIndex) {
                        final listViewJobRecord = // add if statement here
                            widget.pagingController!.itemList![listViewIndex];

                        if (listViewJobRecord.acceptorID != null) {
                          return SizedBox.shrink();
                        } else {
                          return JobCard(
                              listViewJobRecord: listViewJobRecord,
                              index: listViewIndex);
                        }
                      },
                    ),
                  ),
                ),
              )
            :
            // SizedBox(height: 800),
            // EMPTY RESULTS
            Builder(
                builder: (context) {
                  final searcResults = widget.simpleSearchResults.toList();
                  if (searcResults.isEmpty) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/not_stonks.jpg',
                          width: double.infinity,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                      height:
                          400, // TODO: figure out how to make this dynamic. otherwise may have to change structure of navbar, refer to jobhist
                      child: ListView.builder(
                          shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                          itemCount: searcResults.length,
                          itemBuilder: (context, searcResultsIndex) {
                            final searcResultsItem =
                                searcResults[searcResultsIndex];
                            return JobCard(
                                listViewJobRecord: searcResultsItem,
                                index: searcResultsIndex);
                          }));
                },
              ),
      ],
    );
  }
}

class SearchHeader extends StatefulWidget {
  const SearchHeader(
      {Key? key,
      required this.searchFieldController,
      required this.updateSearchResults})
      : super(key: key);
  final searchFieldController;
  final Function(List<JobRecord>) updateSearchResults;
  @override
  SearchHeaderState createState() => SearchHeaderState();
}

class SearchHeaderState extends State<SearchHeader> {
  Widget build(BuildContext context) {
    // List<JobRecord> simpleSearchResults = [];
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, -0.15),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
                    child: TextFormField(
                      controller: widget.searchFieldController,
                      onChanged: (_) => EasyDebounce.debounce(
                        'searchFieldController',
                        Duration(milliseconds: 500),
                        () => setState(() {}),
                      ),
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Search Jobs',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0x67FFFFFF),
                          size: 25,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.85, 0),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        widget.searchFieldController?.clear();
                      });
                      setState(() => FFAppState().showFullList = true);
                    },
                    child: Icon(
                      Icons.clear_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
            child: FlutterFlowIconButton(
              borderColor: Color(0x0096669E),
              borderRadius: 10,
              borderWidth: 1,
              buttonSize: 50,
              fillColor: FlutterFlowTheme.of(context).primaryColor,
              icon: FaIcon(
                FontAwesomeIcons.search,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24,
              ),
              onPressed: () async {
                // TODO: remove the bug where pressing the button generates new entries into screen
                // IS DUE TO SIMPLESEARCHRESULTS
                List<JobRecord> simpleSearchResults = [];
                await queryJobRecordOnce()
                    .then(
                  (records) => simpleSearchResults = TextSearch(
                    records
                        .map(
                          (record) => TextSearchItem(
                              record, [record.store!, record.delLocation!]),
                        )
                        .toList(),
                  )
                      .search(widget.searchFieldController.text)
                      .map((r) => r.object)
                      .toList(),
                )
                    .onError((_, __) {
                  return simpleSearchResults = [];
                }).whenComplete(() => setState(() {}));
                widget.updateSearchResults(simpleSearchResults);

                setState(() => FFAppState().showFullList = false);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobBoardHeader extends StatelessWidget {
  const JobBoardHeader({
    Key? key,
  }) : super(key: key);

  // @override
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

class CardEntry extends StatelessWidget {
  const CardEntry(
      {Key? key, required this.store, required this.icon, this.lines = 1})
      : super(key: key);

  final String store;
  final IconData icon;
  final int lines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              icon,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 24,
            ),
          ),
          Flexible(
            child: Text(
              store,
              style: FlutterFlowTheme.of(context).bodyText1,
              maxLines: lines,
            ),
          ),
        ],
      ),
    );
  }
}
