// ignore_for_file: non_constant_identifier_names

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
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
  Query? _pagingQuery;
  List<StreamSubscription?> _streamSubscriptions = [];

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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 7,
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
              NavBarWithMiddleButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded JobList(BuildContext context) {
    print(FFAppState().showFullList);
    return Expanded(
      child: FFAppState().showFullList
          ? Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
              child: PagedListView<DocumentSnapshot<Object?>?, JobRecord>(
                pagingController: () {
                  final Query<Object?> Function(Query<Object?>) queryBuilder =
                      (jobRecord) => jobRecord;
                  if (_pagingController != null) {
                    final query = queryBuilder(JobRecord.collection);
                    if (query != _pagingQuery) {
                      // The query has changed
                      _pagingQuery = query;
                      _streamSubscriptions.forEach((s) => s?.cancel());
                      _streamSubscriptions.clear();
                      _pagingController!.refresh();
                    }
                    return _pagingController!;
                  }

                  _pagingController = PagingController(firstPageKey: null);
                  _pagingQuery = queryBuilder(JobRecord.collection);
                  _pagingController!.addPageRequestListener((nextPageMarker) {
                    queryJobRecordPage(
                      queryBuilder: (jobRecord) => jobRecord,
                      nextPageMarker: nextPageMarker,
                      pageSize: 10,
                      isStream: true,
                    ).then((page) {
                      _pagingController!.appendPage(
                        page.data,
                        page.nextPageMarker,
                      );
                      final streamSubscription =
                          page.dataStream?.listen((data) {
                        final itemIndexes = _pagingController!.itemList!
                            .asMap()
                            .map((k, v) => MapEntry(v.reference.id, k));
                        data.forEach((item) {
                          final index = itemIndexes[item.reference.id];
                          final items = _pagingController!.itemList!;
                          if (index != null) {
                            items.replaceRange(index, index + 1, [item]);
                            _pagingController!.itemList = {
                              for (var item in items) item.reference: item
                            }.values.toList();
                          }
                        });
                        setState(() {});
                      });
                      _streamSubscriptions.add(streamSubscription);
                    });
                  });
                  return _pagingController!;
                }(),
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
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
                        _pagingController!.itemList![listViewIndex];

                    return listViewJobRecord.acceptorID != null
                        ? SizedBox.shrink()
                        : JobCard(
                            jobRecord: listViewJobRecord, index: listViewIndex);
                  },
                ),
              ),
            )
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
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
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
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/not_stonks.jpg',
                  width: double.infinity,
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
                return JobCard(jobRecord: searcResultsItem, index: index);
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
    required this.jobRecord,
    required this.index,
  }) : super(key: key);

  final JobRecord jobRecord;
  final int index;

  @override
  Widget build(BuildContext context) {
    int index = this.index;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
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
                      store: jobRecord.store!,
                    ),
                    CardEntry(
                      icon: Icons.access_time,
                      store: valueOrDefault<String>(
                        dateTimeFormat('jm', jobRecord.delTime),
                        'ASAP',
                      ),
                    ),
                    CardEntry(
                      icon: FontAwesomeIcons.locationArrow,
                      store: jobRecord.delLocation!,
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
