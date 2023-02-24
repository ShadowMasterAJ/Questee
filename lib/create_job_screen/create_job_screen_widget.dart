import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class CreateJobScreenWidget extends StatefulWidget {
  const CreateJobScreenWidget({Key? key}) : super(key: key);

  @override
  _CreateJobScreenWidgetState createState() => _CreateJobScreenWidgetState();
}

class _CreateJobScreenWidgetState extends State<CreateJobScreenWidget> {
  DateTime? datePicked;
  TextEditingController? priceController;
  String? storeValue;
  String? type;
  TextEditingController? delLocationController;
  TextEditingController? noteController;
  TextEditingController? itemQuantityController;
  TextEditingController? itemController;
  List<TextFormField> _fields = [];
  List<TextEditingController> _controllers = [];
  final List<String> _items = [];
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    delLocationController = TextEditingController();
    priceController = TextEditingController();
    noteController = TextEditingController();
    itemQuantityController = TextEditingController();
    itemController = TextEditingController();
  }

  @override
  void dispose() {
    delLocationController?.dispose();
    priceController?.dispose();
    noteController?.dispose();
    itemQuantityController?.dispose();
    itemController?.dispose();
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
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 30,
                          ),
                          onPressed: () async {
                            context.pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(18, 26, 30, 12),
                        child: Text(
                          'Create Job.',
                          style: FlutterFlowTheme.of(context).title1.override(
                                fontFamily: 'Poppins',
                                fontSize: 36,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [jobStore(context), jobType(context)],
                          ),
                          DeliveryLocation(
                              delLocationController: delLocationController),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                jobDateTime(context),
                                OfferedPrice(priceController: priceController),
                              ],
                            ),
                          ),
                          Note(noteController: noteController),
                          Items(fields: _fields),
                          addItem(context),
                          CreateTaskButton(
                              controllers: _controllers,
                              items: _items,
                              type: type,
                              noteController: noteController,
                              storeValue: storeValue,
                              delLocationController: delLocationController,
                              priceController: priceController,
                              datePicked: datePicked),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding jobDateTime(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: InkWell(
        onTap: () async {
          await DatePicker.showTimePicker(
            context,
            showTitleActions: true,
            onConfirm: (date) {
              setState(() => datePicked = date);
            },
            currentTime: getCurrentTimestamp,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryBackground,
              width: 0,
            ),
          ),
          alignment: AlignmentDirectional(0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: AutoSizeText(
                  // TODO: change time selection to actual calendar
                  valueOrDefault<String>(
                    dateTimeFormat('d/M H:mm', datePicked),
                    'Deadline',
                  ),
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily: 'Poppins',
                        lineHeight: 1,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Icon(
                  Icons.date_range_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded jobType(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: FlutterFlowDropDown(
          options: ["Buying", "Queueing"],
          onChanged: (val) => setState(() => type = val),
          width: double.infinity,
          height: 50,
          textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Poppins',
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
          hintText: 'Select Job Type',
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 2,
          borderColor: Colors.transparent,
          borderWidth: 0,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
          hidesUnderline: true,
        ),
      ),
    );
  }

  Expanded jobStore(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: FlutterFlowDropDown(
          options: ['Prime Supermarket', 'Booklink', 'Cheers'],
          onChanged: (val) => setState(() => storeValue = val),
          width: double.infinity,
          height: 50,
          textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Poppins',
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
          hintText: 'Select Store',
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 2,
          borderColor: Colors.transparent,
          borderWidth: 0,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
          hidesUnderline: true,
        ),
      ),
    );
  }

  Align addItem(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(1, 0),
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            final controller = TextEditingController();
            final field = TextFormField(
              controller: controller,
              onChanged: (_) => EasyDebounce.debounce(
                'itemController',
                Duration(milliseconds: 1000),
                () => setState(() {}),
              ),
              obscureText: false,
              decoration: InputDecoration(
                hintText: '(Eg. Meiji Milk Original 300ml x3)',
                hintStyle: FlutterFlowTheme.of(context).bodyText2,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              ),
              style: FlutterFlowTheme.of(context).bodyText1,
              maxLines: 1,
            );
            setState(() {
              _controllers.add(controller);
              _fields.add(field);
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                child: Text(
                  'Add Items',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Icon(
                Icons.add_box,
                color: FlutterFlowTheme.of(context).primaryBtnText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferedPrice extends StatelessWidget {
  const OfferedPrice({
    Key? key,
    required this.priceController,
  }) : super(key: key);

  final TextEditingController? priceController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: priceController,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Offered Job Price \$',
          hintStyle: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Poppins',
                fontSize: 13,
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
        style: FlutterFlowTheme.of(context).bodyText1,
        textAlign: TextAlign.start,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
      ),
    );
  }
}

class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({
    Key? key,
    required List<TextEditingController> controllers,
    required List<String> items,
    required this.type,
    required this.noteController,
    required this.storeValue,
    required this.delLocationController,
    required this.priceController,
    required this.datePicked,
  })  : _controllers = controllers,
        _items = items,
        super(key: key);

  final List<TextEditingController> _controllers;
  final List<String> _items;
  final String? type;
  final TextEditingController? noteController;
  final String? storeValue;
  final TextEditingController? delLocationController;
  final TextEditingController? priceController;
  final DateTime? datePicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 25),
      child: FFButtonWidget(
        onPressed: () async {
          for (int i = 0; i < _controllers.length; i++) {
            _items.add(_controllers[i].text);
          }
          final jobCreateData = createJobRecordData(
            type: type,
            note: noteController!.text,
            store: storeValue,
            delLocation: delLocationController!.text,
            price: valueOrDefault<double>(
              double.parse(priceController!.text),
              3.00,
            ),
            items: _items,
            status: 'open',
            delTime: datePicked,
            posterID: currentUserReference,
          );
          // await JobRecord.collection.doc().set(jobCreateData);
          final newDocRef = JobRecord.collection.doc();
          await newDocRef.set(jobCreateData);
          final jobId = newDocRef.id;
          UsersRecord.addCurrJobsPosted(currentUserReference!.id, jobId);
          context.pushNamed('JobBoardScreen');
        },
        text: 'Create Task',
        options: FFButtonOptions(
          width: 270,
          height: 50,
          color: FlutterFlowTheme.of(context).primaryColor,
          textStyle: FlutterFlowTheme.of(context).subtitle1.override(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
          elevation: 3,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  const Items({
    Key? key,
    required List<TextFormField> fields,
  })  : _fields = fields,
        super(key: key);

  final List<TextFormField> _fields;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _fields.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: _fields[index]),
          );
        });
  }
}

class Note extends StatelessWidget {
  const Note({
    Key? key,
    required this.noteController,
  }) : super(key: key);

  final TextEditingController? noteController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: TextFormField(
        controller: noteController,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Note',
          hintStyle: FlutterFlowTheme.of(context).bodyText2,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
        style: FlutterFlowTheme.of(context).bodyText1,
        maxLines: 6,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          }

          return null;
        },
      ),
    );
  }
}

class DeliveryLocation extends StatelessWidget {
  const DeliveryLocation({
    Key? key,
    required this.delLocationController,
  }) : super(key: key);

  final TextEditingController? delLocationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: TextFormField(
        controller: delLocationController,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Enter Delivery Location',
          hintStyle: FlutterFlowTheme.of(context).bodyText2,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
        style: FlutterFlowTheme.of(context).bodyText1,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          }

          return null;
        },
      ),
    );
  }
}
