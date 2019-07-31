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

  Future<void> registerUser(String email, String password) async {
    return _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'password': password, 'goalAdded': false});
  }

  Future<void> createMsg(String currentUserId, String chatId, String text) async {
    print('createMsg $currentUserId to $chatId with $text');
    return _firestore.collection('messages').document().setData({
      'text': text,
      'chatRef': '/chats/$chatId',
      'creatorID': currentUserId,
      'created_at': FieldValue.serverTimestamp(),
    });

  }

  Stream<QuerySnapshot> chatList() {
    return _firestore.collection("chats").snapshots();
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