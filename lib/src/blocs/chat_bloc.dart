import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../utils/strings.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _goalMessage = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Observable<String> get name => _title.stream.transform(_validateName);

  Observable<String> get goalMessage =>
      _goalMessage.stream.transform(_validateMessage);

  Observable<bool> get showProgress => _showProgress.stream;

  Function(String) get changeName => _title.sink.add;

  Function(String) get changeGoalMessage => _goalMessage.sink.add;

  final _validateMessage = StreamTransformer<String, String>.fromHandlers(
      handleData: (goalMessage, sink) {
        if (goalMessage.length > 10) {
          sink.add(goalMessage);
        } else {
          sink.addError(StringConstant.goalValidateMessage);
        }
      });

  final _validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String name, sink) {
        if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(name)) {
          sink.addError(StringConstant.nameValidateMessage);
        } else {
          sink.add(name);
        }
      });

  void submit(String email) {
    _showProgress.sink.add(true);
    _repository
        .uploadGoal(email, _title.value, _goalMessage.value)
        .then((value) {
      _showProgress.sink.add(false);
    });
  }

  void extractText(var image) {
//    _repository.extractText(image).then((text) {
//      _goalMessage.sink.add(text);
//    });
  }

  Stream<QuerySnapshot> chatList() {
    return _repository.chatList().asyncMap((snap) async  {
      // Mapping to and from
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


//  Stream<QuerySnapshot> othersGoalList() {
//    return _repository.othersGoalList();
//  }

  //dispose all open sink
  void dispose() async {
    await _goalMessage.drain();
    _goalMessage.close();
    await _title.drain();
    _title.close();
    await _showProgress.drain();
    _showProgress.close();
  }

  //Convert map to goal list
  List mapToList({QuerySnapshot docs, List<DocumentSnapshot> docList}) {
    List<Chat> chatList = [];

    docs.documents.forEach((DocumentSnapshot doc) async {
      User from = User(doc['from']['uid'],
          doc['from']['nickUid'], doc['from']['displayName']);
      User to = User(doc['to']['uid'],
          doc['to']['nickUid'], doc['to']['displayName']);

      Chat chat = Chat(doc.documentID, doc['isPending'], doc['isBlock'],
          doc['helloText'], from, to);

      chatList.add(chat);
    });

    print('EndList');

    return chatList;
  }

//  //Remove item from the goal list
//  void removeGoal(String title, String email) {
//    return _repository.removeGoal(title, email);
//  }
}