import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBarWithMiddleButtonWidget extends StatefulWidget {
  const NavBarWithMiddleButtonWidget({Key? key}) : super(key: key);

  @override
  _NavBarWithMiddleButtonWidgetState createState() =>
      _NavBarWithMiddleButtonWidgetState();
}

class _NavBarWithMiddleButtonWidgetState
    extends State<NavBarWithMiddleButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0x00EEEEEE),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0x1A57636C),
                            offset: Offset(0, -10),
                            spreadRadius: 0.1,
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    onPressed: () async {
                      context.pushNamed('ChatWithUserScreen');
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 10,
                          borderWidth: 1,
                          buttonSize: 60,
                          fillColor: FlutterFlowTheme.of(context).primaryColor,
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
                    ],
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 50,
                    icon: Icon(
                      Icons.history,
                      color: FlutterFlowTheme.of(context).grayIcon,
                      size: 24,
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
                      size: 26,
                    ),
                    onPressed: () async {
                      context.pushNamed('editProfileScreen');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
