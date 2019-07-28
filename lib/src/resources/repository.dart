import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_provider.dart';
import 'fireauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _fireauthProvider = FireauthProvider();

  Future<String> authenticateUser() =>
      _fireauthProvider.authenticateUser();

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);


  Future<void> uploadGoal(String email, String title, String goal) =>
      _firestoreProvider.uploadGoal(title, email, goal);

  Stream<QuerySnapshot> chatList() =>
      _firestoreProvider.chatList();

  Future<DocumentSnapshot> getUser(String userId) =>
      _firestoreProvider.getUser(userId);
//
//  void removeGoal(String title, email) =>
//      _firestoreProvider.removeGoal(title, email);
}