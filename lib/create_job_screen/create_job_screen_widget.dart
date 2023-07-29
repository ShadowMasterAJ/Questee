// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/alert_dialog_box.dart';
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
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool storeIsNull = false;
  bool typeIsNull = false;
  bool dateIsNull = false;

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
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Header(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [JobStore(context), JobType(context)],
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
                                JobDateTime(context),
                                JobPrice(priceController: priceController),
                              ],
                            ),
                          ),
                          Note(noteController: noteController),
                          Items(fields: _fields),
                          AddItemButton(context),
                          CreateJobButton(context)
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

  Padding CreateJobButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 25),
      child: FFButtonWidget(
        onPressed: () async {
          print("Items: $_items");
          print("Type: $type");
          print("Store Value: $storeValue");
          print("Date Picked: $datePicked");
          if (_formKey.currentState == null ||
              !_formKey.currentState!.validate() ||
              type == null ||
              storeValue == null ||
              datePicked == null) {
            if (storeValue == null) setState(() => storeIsNull = true);
            if (datePicked == null) setState(() => dateIsNull = true);
            if (type == null) setState(() => typeIsNull = true);
            return;
          }

          for (int i = 0; i < _controllers.length; i++) {
            _items.add(_controllers[i].text);
          }
          if (_items.isEmpty) {
            showAlertDialog(context, 'No Items Added!',
                'You must add atleast 1 item to create the task');
          } else {
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
            final newJobRef = JobRecord.collection.doc();
            await newJobRef.set(jobCreateData);
            UsersRecord.addCurrJobsPosted(currentUserReference!.id, newJobRef);
            context.pushNamed('JobBoardScreen');
          }
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

  Padding JobDateTime(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: InkWell(
          onTap: () async {
            await DatePicker.showTimePicker(
              context,
              showTitleActions: true,
              onConfirm: (date) {
                setState(() {
                  datePicked = date;
                  dateIsNull = false;
                });
              },
              currentTime: getCurrentTimestamp,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              dateIsNull
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: Text(
                        'Field is required',
                        style: TextStyle(
                            color: Color.fromARGB(255, 204, 58, 48),
                            fontSize: 13),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      );

  Expanded JobType(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: FlutterFlowDropDown(
                options: ["Buying", "Queueing"],
                onChanged: (val) => setState(() {
                  type = val;
                  typeIsNull = false;
                }),
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
            typeIsNull
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 0, 0),
                    child: Text(
                      'Field is required',
                      style: TextStyle(
                          color: Color.fromARGB(255, 204, 58, 48),
                          fontSize: 13),
                    ),
                  )
                : Container()
          ],
        ),
      );

  Expanded JobStore(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: FlutterFlowDropDown(
                options: ['Prime Supermarket', 'Booklink', 'Cheers'],
                onChanged: (val) => setState(() {
                  storeValue = val;
                  storeIsNull = false;
                }),
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
            storeIsNull
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 0, 0),
                    child: Text(
                      'Field is required',
                      style: TextStyle(
                          color: Color.fromARGB(255, 204, 58, 48),
                          fontSize: 13),
                    ),
                  )
                : Container()
          ],
        ),
      );

  Align AddItemButton(BuildContext context) => Align(
        alignment: AlignmentDirectional(1.1, 0),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
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
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(10, 15, 10, 10),
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

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class JobPrice extends StatelessWidget {
  const JobPrice({
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          suffixIcon: InkWell(
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'explain',
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Align(
                    alignment: Alignment(0.9, -0.3),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primaryBackgroundLight,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              // offset: Offset(0, ),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          'This is how much you are willing to pay for delivery.\nThe higher it is, the more likely the job will be accepted',
                          style: FlutterFlowTheme.of(context).bodyText2,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.help_outline,
                color: FlutterFlowTheme.of(context).primaryColorLight),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyText1,
        textAlign: TextAlign.start,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Field is required';
          } else if (val == "cock" || val == "penis") {
            return "Why must you do this DC?";
          } else if (double.tryParse(val) == null) {
            return 'Only numbers are allowed';
          }
          return null;
        },
      ),
    );
  }
}

class Items extends StatefulWidget {
  const Items({
    Key? key,
    required List<TextFormField> fields,
  })  : _fields = fields,
        super(key: key);

  final List<TextFormField> _fields;

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget._fields.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: widget._fields[index]),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: FlutterFlowTheme.of(context).primaryColorLight,
                ),
                onPressed: () => setState(() => widget._fields.removeAt(index)),
                iconSize: 30,
              )
            ],
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
      padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
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
              color: Color.fromARGB(0, 255, 0, 0),
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(10, 12, 10, 10),
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
