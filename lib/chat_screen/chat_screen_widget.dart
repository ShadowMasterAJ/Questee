// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import '../flutter_flow/chat/index.dart';
// import '../flutter_flow/flutter_flow_icon_button.dart';
// import '../flutter_flow/flutter_flow_theme.dart';

// class ChatScreenWidget extends StatefulWidget {
//   const ChatScreenWidget({
//     Key? key,
//     this.chatRef,
//     this.chatUser,
//   }) : super(key: key);

//   final DocumentReference? chatRef;
//   final UsersRecord? chatUser;

//   @override
//   _ChatScreenWidgetState createState() => _ChatScreenWidgetState();
// }

// class _ChatScreenWidgetState extends State<ChatScreenWidget> {
//   FFChatInfo? _chatInfo;
//   bool isGroupChat() {
//     if (widget.chatUser == null) {
//       return true;
//     }
//     if (widget.chatRef == null) {
//       return false;
//     }
//     return _chatInfo?.isGroupChat ?? false;
//   }

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     FFChatManager.instance
//         .getChatInfo(
//       otherUserRecord: widget.chatUser,
//       chatReference: widget.chatRef,
//     )
//         .listen((info) {
//       if (mounted) {
//         setState(() => _chatInfo = info);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     context.watch<FFAppState>();

//     return StreamBuilder<List<UsersRecord>>(
//       stream: queryUsersRecord(
//         singleRecord: true,
//       ),
//       builder: (context, snapshot) {
//         // Customize what your widget looks like when it's loading.
//         if (!snapshot.hasData) {
//           return Center(
//             child: SizedBox(
//               width: 50,
//               height: 50,
//               child: CircularProgressIndicator(
//                 color: FlutterFlowTheme.of(context).primaryColor,
//               ),
//             ),
//           );
//         }
//         List<UsersRecord> chatScreenUsersRecordList = snapshot.data!;
//         // Return an empty Container when the document does not exist.
//         if (snapshot.data!.isEmpty) {
//           return Container();
//         }
//         final chatScreenUsersRecord = chatScreenUsersRecordList.isNotEmpty
//             ? chatScreenUsersRecordList.first
//             : null;
//         return Scaffold(
//           key: scaffoldKey,
//           appBar: AppBar(
//             backgroundColor: FlutterFlowTheme.of(context).primaryColor,
//             automaticallyImplyLeading: false,
//             leading: FlutterFlowIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 60,
//               icon: Icon(
//                 Icons.arrow_back_rounded,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 size: 24,
//               ),
//               onPressed: () async {
//                 context.pop();
//               },
//             ),
//             title: Stack(
//               children: [
//                 Text(
//                   widget.chatUser!.displayName!,
//                   style: FlutterFlowTheme.of(context).bodyText1.override(
//                         fontFamily: 'Lexend Deca',
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ],
//             ),
//             actions: [],
//             centerTitle: false,
//             elevation: 2,
//           ),
//           body: SafeArea(
//             child: StreamBuilder<FFChatInfo>(
//               stream: FFChatManager.instance.getChatInfo(
//                 otherUserRecord: widget.chatUser,
//                 chatReference: widget.chatRef,
//               ),
//               builder: (context, snapshot) => snapshot.hasData
//                   ? FFChatPage(
//                       chatInfo: snapshot.data!,
//                       allowImages: true,
//                       backgroundColor:
//                           FlutterFlowTheme.of(context).primaryBackground,
//                       timeDisplaySetting: TimeDisplaySetting.visibleOnTap,
//                       currentUserBoxDecoration: BoxDecoration(
//                         color: FlutterFlowTheme.of(context).primaryColor,
//                         border: Border.all(
//                           color: FlutterFlowTheme.of(context).primaryColor,
//                         ),
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(15),
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15)),
//                       ),
//                       otherUsersBoxDecoration: BoxDecoration(
//                         color: FlutterFlowTheme.of(context).secondaryColor,
//                         border: Border.all(
//                           color: Color.fromARGB(0, 255, 255, 255),
//                         ),
//                         borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(15),
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15)),
//                       ),
//                       currentUserTextStyle: GoogleFonts.getFont(
//                         'DM Sans',
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         fontStyle: FontStyle.normal,
//                       ),
//                       otherUsersTextStyle: GoogleFonts.getFont(
//                         'DM Sans',
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                       inputHintTextStyle: GoogleFonts.getFont(
//                         'DM Sans',
//                         color: Color(0xFF95A1AC),
//                         fontWeight: FontWeight.normal,
//                         fontSize: 14,
//                       ),
//                       inputTextStyle: GoogleFonts.getFont(
//                         'DM Sans',
//                         color: Color.fromARGB(255, 0, 0, 0),
//                         fontWeight: FontWeight.normal,
//                         fontSize: 14,
//                       ),
//                       emptyChatWidget: Image.asset(
//                         'assets/images/messagesEmpty@2x.png',
//                         width: MediaQuery.of(context).size.width * 0.76,
//                       ),
//                     )
//                   : Center(
//                       child: SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: CircularProgressIndicator(
//                           color: FlutterFlowTheme.of(context).primaryColor,
//                         ),
//                       ),
//                     ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_util.dart';

class ChatScreenWidget extends StatefulWidget {
  final DocumentReference jobRef;

  ChatScreenWidget({required this.jobRef});

  @override
  _ChatScreenWidgetState createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CollectionReference _chatRef =
      FirebaseFirestore.instance.collection('chat');
  late Query _messageQuery;
  late String _userType;
  @override
  void initState() {
    super.initState();
    _messageQuery = _chatRef
        .where('jobID', isEqualTo: widget.jobRef)
        .orderBy('timestamp', descending: true)
        .limit(50);

    // _chatRef.where('senderID', isEqualTo: currentUserUid).toString();
    print('-----------------------------');
    print("Chatref:${_chatRef.where('jobID', isEqualTo: widget.jobRef)}");
    print(_userType.toString());
    print("Current userid ${currentUserUid.toString()}");
    print('-----------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messageQuery.snapshots(),
                builder: (context, snapshot) {
                  print("Snapshot: $snapshot");
                  if (!snapshot.hasData) {
                    return ClipRRect(
                      child: Image.asset(
                        'assets/images/messagesEmpty@2x.png',
                        width: MediaQuery.of(context).size.width * 0.76,
                      ),
                    );
                  }
                  List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? data =
                          docs[index].data() as Map<String, dynamic>?;
                      return ListTile(
                        title: Text(data!['text']),
                        subtitle: Text(data['senderID'].id),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                    child: Text('Send'),
                    onPressed: () async {
                      String text = _textEditingController.text;
                      if (text.isEmpty) {
                        return;
                      }
                      DocumentReference messageRef =
                          await _chatRef.doc().collection('messages').add({
                        'senderID': FirebaseFirestore.instance
                            .doc('users/${currentUserReference!.id}'),
                        'text': text,
                        'timestamp': DateTime.now(),
                        'jobID': widget.jobRef,
                      });
                      _textEditingController.clear();
                      _scrollController.animateTo(0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
