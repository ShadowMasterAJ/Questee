import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:u_grabv1/auth/auth_util.dart';
import 'package:u_grabv1/flutter_flow/flutter_flow_theme.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';

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
      FirebaseFirestore.instance.collection('chats');
  late CollectionReference _messageRef;
  String _userType = "";
  late DocumentReference _chatDocRef;

  @override
  void initState() {
    super.initState();
    _chatDocRef = _chatRef.doc(widget.jobRef.id);
    _messageRef = _chatDocRef.collection('messages');
    print("Message ref: $_messageRef");
    createChatDocument();
  }

  Future<void> createChatDocument() async {
    final jobSnapshot = await widget.jobRef.get();
    final poster = jobSnapshot.get("posterID");
    final acceptor = jobSnapshot.get("acceptorID");
    _userType = currentUserReference == acceptor ? 'acceptor' : 'poster';

    print(
        "Usertype in chat is: $_userType ($currentUserReference == $acceptor)");

    await _chatDocRef.set({
      'jobID': widget.jobRef,
      'posterID': poster,
      'acceptorID': acceptor,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Text(
                    _userType == 'acceptor'
                        ? 'Chat with the \nposter.'
                        : 'Chat with the \nacceptor.',
                    textAlign: TextAlign.center,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageRef
                  .orderBy('timestamp', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                final messages = snapshot.data!.docs;

                print("Messages-------------------------$messages");
                if (messages.length == 0) {
                  return Image.asset(
                    'assets/images/messagesEmpty@2x.png',
                    width: MediaQuery.of(context).size.width * 0.76,
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      print(
                          "Message-------------------------${message.data()}");
                      final sender = message['senderID'];
                      final messageText = message['message'];
                      final currentUser = currentUserUid;

                      return MessageBubble(
                        messageText: messageText,
                        sender: sender,
                        currentUser: currentUser,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (_textEditingController.text.isNotEmpty) {
                      await _messageRef.add({
                        'senderID': currentUserUid,
                        'message': _textEditingController.text,
                        'timestamp': DateTime.now(),
                      });
                      _textEditingController.clear();
                      _scrollController.animateTo(
                        0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: FlutterFlowTheme.of(context).secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String sender;
  final String currentUser;

  MessageBubble({
    required this.messageText,
    required this.sender,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = currentUser == sender;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) // show profile picture only for messages from other users
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.white),
            ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 5, 10),
            decoration: BoxDecoration(
              color: isMe
                  ? FlutterFlowTheme.of(context).primaryColorLight
                  : FlutterFlowTheme.of(context).secondaryColorLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
                bottomRight:
                    isMe ? Radius.circular(0.0) : Radius.circular(30.0),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Text(
              messageText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          ),
          if (isMe) // show profile picture only for messages from the current user
            CircleAvatar(
              backgroundColor: Colors.blueGrey[200],
              child: Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
