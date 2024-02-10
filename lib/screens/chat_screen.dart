import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_wb/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_wb/constants.dart';

class ChatScreen extends StatefulWidget {

  static const String id = 'ChatScreen';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final textFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  User? user;
  late String messsage;

  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    user = _auth.currentUser;
  }

  // Todo: - ini Contoh yang Async
  /*
  // void getMessages() async {
  //
  //   final messages = await _db.collection('messages').get().then((value) {
  //     for(var message in value.docs) {
  //       print("${message.id} => ${message.data()['text']}");
  //     }
  //   });
  // }
   */

  // Todo: - Ini Contoh yang Stream
  /*
  void messagesStream() async {
    await for(var snapshot in _db.collection('messages').snapshots()) {
      final messageList = snapshot.docs;
      print(messageList.first);
    }
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                signOut(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _db.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const SizedBox.shrink();
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                        return handleMessageWidget(snapshot);
                      case ConnectionState.done:
                        return const SizedBox.shrink();
                    }
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        messsage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldController.clear();
                      sendMessages();
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget handleMessageWidget(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {

    if (snapshot.hasError) {
      return const SizedBox.shrink();
    }

    final messageData = snapshot.data;

    if (messageData == null) {
      return const SizedBox.shrink();
    }

    final docs = messageData.docs;

    return _getMessages(docs);
  }

  Widget _getMessages(Iterable<QueryDocumentSnapshot<Object?>> messages) {
    List<MessageBubble> messageText = [];
    for(var message in messages) {
      final text = message['text'].toString();
      final sender = message['sender'].toString();
      final isFromSender = user?.email == sender;
      final textWidget = MessageBubble(text: text, sender: sender, isFromSender: isFromSender,);
      messageText.add(textWidget);
    }

    return Expanded(
      child: ListView(
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        children: messageText,
      ),
    );
  }

  void signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  void sendMessages() {
    final message = <String, dynamic>{
      "text": messsage,
      "sender": user?.email,
    };

    _db.collection("messages").add(message);
  }
}

class MessageBubble extends StatelessWidget {

  final String text;
  final String sender;
  final bool isFromSender;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isFromSender,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isFromSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
        ),
        ),
        Material(
          elevation: 2,
          borderRadius: getBorderRadius(),
          color: isFromSender ? Colors.blue : Colors.orange,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(text, style: kChatTextStyle,),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  BorderRadiusGeometry getBorderRadius() {
    if (isFromSender) {
      return const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8));
    }

    return const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8), topRight: Radius.circular(8));
  }
}
