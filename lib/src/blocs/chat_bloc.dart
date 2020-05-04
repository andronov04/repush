import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../utils/strings.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final _repository = Repository();
  final _activeIndex = BehaviorSubject<int>.seeded(0);

  Observable<int> get activeIndex => _activeIndex.stream;

  void setActiveIndex(int index) {
    _activeIndex.add(index);
  }

  void submit(String email) {

  }

  Future<void> createMsg(String currentUserId, String chatId, String text) {
    return _repository.createMsg(currentUserId, chatId, text);
  }

  void extractText(var image) {
//    _repository.extractText(image).then((text) {
//      _goalMessage.sink.add(text);
//    });
  }

  Stream<QuerySnapshot> chatList(String currentUserId) {
    return _repository.chatList(currentUserId).asyncMap((snap) async  {
      int index = 0;
      await Future.wait(snap.documents.map((doc) async {
        DocumentSnapshot fr = await getUser(doc['from'].documentID);
        doc.data['from'] = fr.data;

        DocumentSnapshot to = await getUser(doc['to'].documentID);

        doc.data['to'] = to.data;
        snap.documents[index] = doc;
        index++;
        return doc;
      }));

      return snap;
    });
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return _repository.getUser(userId);
  }

  Future<void> confirmChat(String chatId, bool status) {
    return _repository.confirmChat(chatId, status);
  }

  Future<void> createChat(String currentUserId, String toUser) {
    return _repository.createChat(currentUserId, toUser);
  }


  //dispose all open sink
  void dispose() async {
    await _activeIndex.drain();
    _activeIndex.close();
  }

  //Convert map to goal list
  List mapToList({QuerySnapshot docs, List<DocumentSnapshot> docList}) {
    List<Chat> chatList = [];

    docs.documents.forEach((DocumentSnapshot doc) async {
      User from = User(doc['from']['uid'],
          doc['from']['nickUid'], doc['from']['displayName'],
          doc['from']['color']);
      User to = User(doc['to']['uid'],
          doc['to']['nickUid'], doc['to']['displayName'],
          doc['to']['color']);


      DateTime dt = DateTime.now();

      if(doc['lastActivityAt'] != null){
        dt = doc['lastActivityAt'].toDate();
      }

      Chat chat = Chat(doc.documentID, doc['isPending'], doc['isBlock'],
          doc['helloText'], from, to, dt);

      chatList.add(chat);
    });

    chatList.sort((Chat a, Chat b){
      return b.lastActivityAt.compareTo(a.lastActivityAt);
    });

    return chatList;
  }
}