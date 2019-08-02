import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_provider.dart';
import 'fireauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _fireauthProvider = FireauthProvider();

  Future<String> authenticateUser() =>
      _fireauthProvider.authenticateUser();

  Future<FirebaseUser> currentAuthUser() =>
      _fireauthProvider.currentAuthUser();

//  Future<void> registerUser(String currentUserId) =>
//      _firestoreProvider.registerUser(currentUserId;


  Future<void> createMsg(String currentUserId, String chatId, String text) =>
      _firestoreProvider.createMsg(currentUserId, chatId, text);

  Future<void> confirmChat(String chatId, bool status) =>
      _firestoreProvider.confirmChat(chatId, status);

  Future<void> createChat(String currentUserId, String toUser) =>
      _firestoreProvider.createChat(currentUserId, toUser);

  Stream<QuerySnapshot> chatList(String currentUserId) =>
      _firestoreProvider.chatList(currentUserId);

  Future<DocumentSnapshot> getUser(String userId) =>
      _firestoreProvider.getUser(userId);

  Future<void> setTokenToUser(String currentUserId, String token) =>
      _firestoreProvider.setTokenToUser(currentUserId, token);

//
//  void removeGoal(String title, email) =>
//      _firestoreProvider.removeGoal(title, email);
}