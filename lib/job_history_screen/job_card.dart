import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

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
        final price = jobData['price'].toString();

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
                        store == 'Prime Supermarket'
                            ? 'assets/images/Prime_Supermarket.jpg'
                            : store == 'Cheers'
                                ? 'assets/images/cheers.jpg'
                                : store == 'Booklink'
                                    ? 'assets/images/booklink.jpg'
                                    : 'assets/images/711.png',
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DelStore(store: store),
                      DelLocation(location: location),
                      DelTiming(delTime: delTime),
                      DelPrice(price: price),
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

class DelStore extends StatelessWidget {
  const DelStore({
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
        mainAxisAlignment: MainAxisAlignment.start,
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

class DelLocation extends StatelessWidget {
  const DelLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8, 5, 5, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: FaIcon(
              FontAwesomeIcons.locationPin,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 22,
            ),
          ),
          SizedBox(width: 5),
          Text(
            location,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}

class DelPrice extends StatelessWidget {
  const DelPrice({
    Key? key,
    required this.price,
  }) : super(key: key);

  final String price;

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
            price,
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ],
      ),
    );
  }
}

class DelTiming extends StatelessWidget {
  const DelTiming({
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
