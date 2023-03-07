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
    createChatDocument();
  }

  Future<void> createChatDocument() async {
    final jobSnapshot = await widget.jobRef.get();
    final poster = jobSnapshot.get("posterID");
    final acceptor = jobSnapshot.get("acceptorID");
    _userType = currentUserReference == acceptor ? 'acceptor' : 'poster';

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
      body: SafeArea(
        child: Column(
          children: [
            Header(userType: _userType),
            MessagesArea(
                messageRef: _messageRef, scrollController: _scrollController),
            MessageBar(
                textEditingController: _textEditingController,
                messageRef: _messageRef,
                scrollController: _scrollController),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required String userType,
  })  : _userType = userType,
        super(key: key);

  final String _userType;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class MessagesArea extends StatelessWidget {
  const MessagesArea({
    Key? key,
    required CollectionReference<Object?> messageRef,
    required ScrollController scrollController,
  })  : _messageRef = messageRef,
        _scrollController = scrollController,
        super(key: key);

  final CollectionReference<Object?> _messageRef;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}

class MessageBar extends StatelessWidget {
  const MessageBar({
    Key? key,
    required TextEditingController textEditingController,
    required CollectionReference<Object?> messageRef,
    required ScrollController scrollController,
  })  : _textEditingController = textEditingController,
        _messageRef = messageRef,
        _scrollController = scrollController,
        super(key: key);

  final TextEditingController _textEditingController;
  final CollectionReference<Object?> _messageRef;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _textEditingController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    minLines: 1,
                    maxLines: 10, // Set maxLines to null or a high number
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
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
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String messageText;
  final String sender;
  final String currentUser;

  MessageBubble({
    required this.messageText,
    required this.sender,
    required this.currentUser,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isMe = widget.currentUser == widget.sender;
    final bool isLong = widget.messageText.length > 100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) // show profile picture only for messages from other users
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.white),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 300),
              margin: EdgeInsets.fromLTRB(10, 0, 5, 10),
              decoration: BoxDecoration(
                color: isMe
                    ? FlutterFlowTheme.of(context).primaryColorLight
                    : FlutterFlowTheme.of(context).secondaryColorLight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  topLeft: isMe ? Radius.circular(20.0) : Radius.circular(0.0),
                  topRight: isMe ? Radius.circular(0.0) : Radius.circular(20.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.messageText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                    maxLines: _isExpanded ? null : 10,
                    overflow: TextOverflow.fade,
                  ),
                  if (isLong && !_isExpanded)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Read more',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_isExpanded)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Show less',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
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
