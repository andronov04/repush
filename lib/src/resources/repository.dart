import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_provider.dart';
import 'fireauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _fireauthProvider = FireauthProvider();

  Future<String> authenticateUser() =>
      _fireauthProvider.authenticateUser();

//  Future<void> registerUser(String currentUserId) =>
//      _firestoreProvider.registerUser(currentUserId;


  Future<void> createMsg(String currentUserId, String chatId, String text) =>
      _firestoreProvider.createMsg(currentUserId, chatId, text);

  Stream<QuerySnapshot> chatList() =>
      _firestoreProvider.chatList();

  Future<DocumentSnapshot> getUser(String userId) =>
      _firestoreProvider.getUser(userId);

  Future<void> setTokenToUser(String currentUserId, String token) =>
      _firestoreProvider.setTokenToUser(currentUserId, token);

//
//  void removeGoal(String title, email) =>
//      _firestoreProvider.removeGoal(title, email);
}