import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<int> authenticateUser(String email, String password) async {

//    final QuerySnapshot result = await _firestore
//        .collection("users")
//        .where("email", isEqualTo: email)
//        .getDocuments();
//    final List<DocumentSnapshot> docs = result.documents;
//    if (docs.length == 0) {
//      return 0;
//    } else {
//      return 1;
//    }
  }

  Future<void> createChat(String currentUserId, String toUser) async {
    print('Create chat $currentUserId - $toUser');

    QuerySnapshot doc = await _firestore.collection('users').where('nickUid', isEqualTo: int.parse(toUser)).getDocuments();

    if(doc.documents != null){
      DocumentSnapshot toUserDoc = doc.documents.first;
      DocumentReference fromUserDoc = _firestore.collection('users').document(currentUserId);

      //TODO ugly hack
      QuerySnapshot chat1 = await _firestore.collection('chats')
          .where('from', isEqualTo: toUserDoc.reference)
          .where('to', isEqualTo: fromUserDoc)
          .getDocuments();

      QuerySnapshot chat2 = await _firestore.collection('chats')
          .where('from', isEqualTo: fromUserDoc)
          .where('to', isEqualTo: toUserDoc.reference)
          .getDocuments();

      print(chat1.documents.isEmpty);
      print(chat2.documents.isEmpty);

      // ignore: unrelated_type_equality_checks
      if(chat1.documents.isEmpty && chat2.documents.isEmpty){
        return _firestore.collection('chats').document().setData({
          'isPending': true,
          'isBlock': false,
          'helloText': '',
          'to': toUserDoc.reference,
          'from': fromUserDoc,
          'users': [
            toUserDoc.documentID,
            currentUserId
          ],
          'created_at': FieldValue.serverTimestamp(),
          'lastActivityAt': FieldValue.serverTimestamp(),
        });
      }
      else{
        return throw('User don\'t exists');
      }
    }
    else {
      return throw('User don\'t exists');
    }
//    return _firestore
//        .collection("users");
  }

  Future<void> confirmChat(String chatId, bool status) async {
    print('Confirm chat $chatId - $status');
    if(status) {
      return _firestore
          .collection("chats")
          .document(chatId)
          .delete();
//          .document(chatId)
//          .updateData({"isBlock": true});
    }
    else {
      return _firestore
          .collection("chats")
          .document(chatId)
          .updateData({"isPending": status});
    }
  }

  Future<void> createMsg(String currentUserId, String chatId, String text) async {
    print('createMsg $currentUserId to $chatId with $text');

    _firestore.collection('messages').document().setData({
      'text': text,
      'chatID': chatId,
      'creatorID': currentUserId,
      'created_at': FieldValue.serverTimestamp(),
    }).then((v){
    });

    _firestore
        .collection('chats')
        .document(chatId).updateData({
      'lastActivityAt': FieldValue.serverTimestamp()
    });



  }

  Future<void> setTokenToUser(String currentUserId, String token) async {
    print('Set token for $currentUserId');
    return _firestore
            .collection('tokens')
            .document(currentUserId)
            .setData({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'lastActivityAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> chatList(String currentUserId) {
    return _firestore.collection("chats")
        .where('users', arrayContains: currentUserId)
        .orderBy('lastActivityAt').snapshots();
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return _firestore.collection("users").document(userId).get();
  }

  Stream<QuerySnapshot> othersGoalList() {
    return _firestore
        .collection("users")
        .where('goalAdded', isEqualTo: true)
        .snapshots();
  }

  void removeGoal(String title, String documentId) async {
    DocumentSnapshot doc =
    await _firestore.collection("users").document(documentId).get();
    Map<String, String> goals = doc.data["goals"].cast<String, String>();
    goals.remove(title);
    if (goals.isNotEmpty) {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({"goals": goals});
    } else {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({'goals': FieldValue.delete(), 'goalAdded': false});
    }
  }
}