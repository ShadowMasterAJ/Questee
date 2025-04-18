import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:u_grabv1/flutter_flow/index.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'alert_dialog_box.dart';

class NavBarWithMiddleButtonWidget extends StatefulWidget {
  const NavBarWithMiddleButtonWidget({Key? key}) : super(key: key);

  @override
  _NavBarWithMiddleButtonWidgetState createState() =>
      _NavBarWithMiddleButtonWidgetState();
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter(
      {this.backgroundColor = Colors.white, this.insetRadius = 38});

  Color backgroundColor;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 12);

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;
    double transitionToInsetCurveWidth = size.width * .05;
    path.quadraticBezierTo(size.width * 0.20, 0,
        insetCurveBeginnningX - transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(
        insetCurveBeginnningX, 0, insetCurveBeginnningX, insetRadius / 2);

    path.arcToPoint(Offset(insetCurveEndX, insetRadius / 2),
        radius: Radius.circular(40.0), clockwise: false);

    path.quadraticBezierTo(
        insetCurveEndX, 0, insetCurveEndX + transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 12);
    path.lineTo(size.width, size.height + 56);
    path.lineTo(
        0,
        size.height +
            56); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _NavBarWithMiddleButtonWidgetState
    extends State<NavBarWithMiddleButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      color: Colors.transparent,
      child: CustomPaint(
        size: Size(double.infinity, 50),
        painter: BottomNavCurvePainter(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground),
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 50,
                icon: Icon(
                  Icons.home_rounded,
                  color: FlutterFlowTheme.of(context).grayIcon,
                  size: 30,
                ),
                onPressed: () async {
                  context.pushNamed('JobBoardScreen');
                },
              ),
              FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 50,
                  icon: Icon(
                    Icons.chat_bubble_rounded,
                    color: FlutterFlowTheme.of(context).grayIcon,
                    size: 24,
                  ),
                  onPressed: () async => currentUserCurrJobsAccepted!.isNotEmpty
                      ? context.pushNamed(
                          'ChatScreen',
                          queryParams: {
                            'jobRef': serializeParam(
                              currentUserCurrJobsAccepted!.first,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                          extra: {
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 400),
                            ),
                          },
                        )
                      : showAlertDialog(context, 'No Chats Yet!',
                          'You need to accept a job first to start a chat with the Quest Runner')),
              Align(
                alignment: Alignment(0, -8),
                child: FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).primaryColorLight,
                  borderRadius: 23,
                  buttonSize: 70,
                  borderWidth: 3,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: FaIcon(
                    FontAwesomeIcons.plus,
                    color: FlutterFlowTheme.of(context).gray200,
                    size: 30,
                  ),
                  onPressed: () async {
                    context.pushNamed('createJobScreen');
                  },
                ),
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 50,
                icon: Icon(
                  Icons.history,
                  color: FlutterFlowTheme.of(context).grayIcon,
                  size: 30,
                ),
                onPressed: () async {
                  context.pushNamed('JobHistoryScreen');
                },
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 50,
                icon: Icon(
                  Icons.face,
                  color: FlutterFlowTheme.of(context).grayIcon,
                  size: 30,
                ),
                onPressed: () async {
                  context.pushNamed('editProfileScreen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
