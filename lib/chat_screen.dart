import 'dart:io';

import 'package:chat_online/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessageToFirebase({String? text, File? imgFile}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    Map<String, dynamic> data = {};

    if (imgFile != null) {
      final File file = File(imgFile.path);
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);

      TaskSnapshot taskSnapshot = await task.whenComplete(() => this);
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá'),
        elevation: 0,
      ),
      body: TextComposer(_sendMessageToFirebase),
    );
  }
}
