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

class JobBoardScreenWidget extends StatefulWidget {
  const JobBoardScreenWidget({Key? key}) : super(key: key);

  @override
  _JobBoardScreenWidgetState createState() => _JobBoardScreenWidgetState();
}

class _JobBoardScreenWidgetState extends State<JobBoardScreenWidget> {
  PagingController<DocumentSnapshot?, JobRecord>? _pagingController;
  Query? _pagingQuery;
  List<StreamSubscription?> _streamSubscriptions = [];

  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    textController?.dispose();
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
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 20, 0, 20),
                          child: Center(
                            child: Text(
                              'Job Board.',
                              textAlign: TextAlign.start,
                              style:
                                  FlutterFlowTheme.of(context).title1.override(
                                        fontFamily: 'Poppins',
                                        fontSize: 36,
                                      ),
                            ),
                          ),
                        ),
                      ),
                      Container(
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
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
                                child: TextFormField(
                                  controller: textController,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController',
                                    Duration(milliseconds: 500),
                                    () => setState(() {}),
                                  ),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search Jobs',
                                    hintStyle:
                                        FlutterFlowTheme.of(context).bodyText2,
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
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            5, 5, 5, 5),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: Color(0x67FFFFFF),
                                      size: 25,
                                    ),
                                    suffixIcon: textController!.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              textController?.clear();
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: Color(0xFF757575),
                                              size: 22,
                                            ),
                                          )
                                        : null,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyText1,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                              child: FlutterFlowIconButton(
                                borderColor: Color(0x0096669E),
                                borderRadius: 10,
                                borderWidth: 1,
                                buttonSize: 50,
                                fillColor:
                                    FlutterFlowTheme.of(context).primaryColor,
                                icon: Icon(
                                  Icons.filter_alt,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 30,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
                        child: PagedListView<DocumentSnapshot<Object?>?,
                            JobRecord>(
                          pagingController: () {
                            final Query<Object?> Function(Query<Object?>)
                                queryBuilder = (jobRecord) => jobRecord;
                            if (_pagingController != null) {
                              final query = queryBuilder(JobRecord.collection);
                              if (query != _pagingQuery) {
                                // The query has changed
                                _pagingQuery = query;
                                _streamSubscriptions
                                    .forEach((s) => s?.cancel());
                                _streamSubscriptions.clear();
                                _pagingController!.refresh();
                              }
                              return _pagingController!;
                            }

                            _pagingController =
                                PagingController(firstPageKey: null);
                            _pagingQuery = queryBuilder(JobRecord.collection);
                            _pagingController!
                                .addPageRequestListener((nextPageMarker) {
                              queryJobRecordPage(
                                queryBuilder: (jobRecord) => jobRecord,
                                nextPageMarker: nextPageMarker,
                                pageSize: 25,
                                isStream: true,
                              ).then((page) {
                                _pagingController!.appendPage(
                                  page.data,
                                  page.nextPageMarker,
                                );
                                final streamSubscription =
                                    page.dataStream?.listen((data) {
                                  final itemIndexes = _pagingController!
                                      .itemList!
                                      .asMap()
                                      .map((k, v) =>
                                          MapEntry(v.reference.id, k));
                                  data.forEach((item) {
                                    final index =
                                        itemIndexes[item.reference.id];
                                    final items = _pagingController!.itemList!;
                                    if (index != null) {
                                      items.replaceRange(
                                          index, index + 1, [item]);
                                      _pagingController!.itemList = {
                                        for (var item in items)
                                          item.reference: item
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
                          padding: EdgeInsets.zero,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
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
                              final listViewJobRecord =
                                  _pagingController!.itemList![listViewIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 5, 10, 5),
                                child: InkWell(
                                  onTap: () async {
                                    String STORE = listViewJobRecord.store!;
                                    String TIME = valueOrDefault<String>(
                                      dateTimeFormat(
                                          'jm', listViewJobRecord.delTime),
                                      'ASAP',
                                    );
                                    String NOTE =
                                        listViewJobRecord.delLocation!;

                                    print(serializeParam(
                                      STORE,
                                      ParamType.String,
                                    ));
                                    print(TIME);
                                    print(NOTE);
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
                                      print(
                                          "THIS IS THE GRABBER ELSE STATEMENT");
                                      context.pushNamed(
                                          'JobDetailScreenGrabber',
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
                                          });
                                    }
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  7, 7, 7, 7),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 10, 0),
                                                    child: Icon(
                                                      Icons.shopping_cart,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Text(
                                                    listViewJobRecord.store!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 10, 0),
                                                    child: Icon(
                                                      Icons.access_time,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      dateTimeFormat(
                                                          'jm',
                                                          listViewJobRecord
                                                              .delTime),
                                                      'ASAP',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 10, 0),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .moneyCheckAlt,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  Text(
                                                    listViewJobRecord
                                                        .delLocation!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NavBarWithMiddleButtonWidget()
            ],
          ),
        ),
      ),
    );
  }
}
