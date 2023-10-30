import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

/// Shows an alert dialog with the specified [title] and [content] in the given [context].
/// The alert dialog is displayed as a pop-up with a customizable appearance.
///
/// Parameters:
/// - [context]: The [BuildContext] in which to show the alert dialog.
/// - [title]: The title of the alert dialog.
/// - [content]: The content of the alert dialog.
///
/// Usage:
/// ```dart
/// showAlertDialog(context, 'Alert', 'This is an important message');
/// ```
Future<void> showAlertDialog(
    BuildContext context, String title, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).subtitle1,
        ),
        content: Text(content,
            textAlign: TextAlign.center,
            style:
                FlutterFlowTheme.of(context).bodyText1.copyWith(fontSize: 16)),
        actionsAlignment: MainAxisAlignment.center,
        elevation: 10,
        shadowColor: FlutterFlowTheme.of(context).primaryColorLight,
        actionsPadding: EdgeInsets.only(bottom: 15),
        actions: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: FFButtonWidget(
                text: "OK",
                onPressed: () => Navigator.of(context).pop(),
                options: FFButtonOptions(
                    padding: EdgeInsets.all(10),
                    width: 150,
                    height: 50,
                    borderRadius: BorderRadius.circular(10),
                    textStyle: FlutterFlowTheme.of(context)
                        .bodyText1
                        .copyWith(fontSize: 16),
                    color: FlutterFlowTheme.of(context).primaryColor)),
          )
        ],
      );
    },
  );
}
