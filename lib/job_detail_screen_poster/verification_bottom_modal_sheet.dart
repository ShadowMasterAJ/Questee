// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:u_grabv1/flutter_flow/chat/index.dart';

import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../utils/custom_rect_tween.dart';
import '../utils/hero_dialog_route.dart';

class VerificationModalBottomSheet extends StatefulWidget {
  const VerificationModalBottomSheet({
    Key? key,
    required this.jobRef,
  }) : super(key: key);
  final DocumentReference jobRef;

  @override
  State<VerificationModalBottomSheet> createState() =>
      _VerificationModalBottomSheetState();
}

class _VerificationModalBottomSheetState
    extends State<VerificationModalBottomSheet> {
  late double maxWidth;
  late List<String> verificationImages;
  late double amountToBePaid;
  late double maxHeight;

  bool verifiedReceipt = false;

  bool payNow = false;
  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    // if (_imageFile != null) print('IMAGE: ${_imageFile!.path}');
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.jobRef.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          verificationImages =
              List<String>.from(data['verificationImages'] ?? []);
          amountToBePaid = data['price'];
          print('IMAGES:$verificationImages');
          print('PRICE: $amountToBePaid');
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: verificationImages.isNotEmpty
                  ? FlutterFlowTheme.of(context).buttonGreen
                  : Colors.grey,
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: verificationImages.isNotEmpty
                ? () => ShowBottomSheet(context)
                : () => _showImageLimitDialog(context),
            child: Text(
              'Verify Purchase',
              style: FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
            ),
          );
        }
      },
    );
  }

  Future ShowBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackgroundLight,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SheetLever(),
                Expanded(
                  child: ImagesViewRow(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AmountExplainers(
                          context,
                          'Total Amount Reported by Acceptor:',
                          '\$${amountToBePaid.toStringAsFixed(2)}'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AmountExplainers(context, 'Base fees:', '\$0.60'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AmountExplainers(context, 'Delivery Fees:',
                          '\$${(amountToBePaid * .05).toStringAsFixed(2)}'),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: FlutterFlowTheme.of(context).primaryColorLight,
                      thickness: 2,
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AmountExplainers(context, 'Total Price:',
                          '\$${(amountToBePaid * 1.05 + 0.6).toStringAsFixed(2)}'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceButton(
                              context,
                              verifiedReceipt ? 'Pay Now' : 'Looks Good!',
                              verifiedReceipt
                                  ? () => setState(() => payNow = true)
                                  : () {
                                      setState(() => verifiedReceipt = true);
                                      Navigator.of(context).pop();
                                      ShowBottomSheet(context);
                                    },
                              verifiedReceipt
                                  ? FlutterFlowTheme.of(context).primaryColor
                                  : FlutterFlowTheme.of(context).buttonGreen),
                        ),
                        if (!verifiedReceipt)
                          Expanded(
                            child: ChoiceButton(
                                context,
                                'Clarify with Acceptor!',
                                () => GoToChat(context, widget.jobRef),
                                FlutterFlowTheme.of(context).buttonRed),
                          )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Row AmountExplainers(BuildContext context, String desc, String price) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(desc, style: FlutterFlowTheme.of(context).subtitle2),
      Spacer(),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: FlutterFlowTheme.of(context).primaryColorDark),
        child: Text(
          price,
          style: FlutterFlowTheme.of(context).subtitle1.copyWith(fontSize: 16),
        ),
      )
    ]);
  }

  Container ChoiceButton(
      BuildContext context, String text, Function() onTap, Color color) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: FFButtonWidget(
        onPressed: onTap,
        text: text,
        options: FFButtonOptions(
          width: double.infinity,
          height: 50,
          color: color,
          textStyle: FlutterFlowTheme.of(context).subtitle1,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _showImageLimitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackgroundLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Please Wait!',
            style: FlutterFlowTheme.of(context).subtitle1,
          ),
          content: Text(
              'The acceptor is still purchasing the items.\nThe button will turn green once they upload the receipts',
              style: FlutterFlowTheme.of(context)
                  .bodyText1
                  .copyWith(fontSize: 14)),
          actionsAlignment: MainAxisAlignment.center,
          elevation: 10,
          shadowColor: FlutterFlowTheme.of(context).primaryColorLight,
          actionsPadding: EdgeInsets.only(bottom: 15),
          actions: [
            FFButtonWidget(
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
                    color: FlutterFlowTheme.of(context).primaryColor))
          ],
        );
      },
    );
  }

  SingleChildScrollView ImagesViewRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          verificationImages.length,
          (index) => InkWell(
            onTap: (() {
              Navigator.of(context).push(
                HeroDialogRoute(
                  builder: (context) => Center(
                    child: Hero(
                        createRectTween: (begin, end) {
                          return CustomRectTween(begin: begin, end: end);
                        },
                        tag: 'imageHero$index',
                        child: Align(
                          alignment: Alignment(0, -1),
                          child: SafeArea(
                            child: ImageExpandedViewHero(
                                maxWidth, maxHeight, index),
                          ),
                        )),
                  ),
                ),
              );
            }),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: maxWidth * 0.60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl:
                      verificationImages[verificationImages.length - index - 1],
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                  )),
                  errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40)),
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container ImageExpandedViewHero(
      double maxWidth, double maxHeight, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InteractiveViewer(
          panEnabled: true,
          child: CachedNetworkImage(
            imageUrl: verificationImages[verificationImages.length - index - 1],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
            width: maxWidth * 0.80,
            height: maxHeight * 0.70,
          ),
        ),
      ),
    );
  }

  Container SheetLever() {
    return Container(
      width: 40,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

void GoToChat(BuildContext context, DocumentReference jobRef) {
  context.pushNamed(
    'ChatScreen',
    queryParams: {
      'jobRef': serializeParam(
        jobRef,
        ParamType.DocumentReference,
      ),
    }.withoutNulls,
    extra: {
      kTransitionInfoKey: TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.scale,
        alignment: Alignment.bottomCenter,
        duration: Duration(milliseconds: 400),
      ),
    },
  );
}
