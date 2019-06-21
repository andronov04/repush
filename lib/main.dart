import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repush/src/App.dart';
import 'dart:io' show Platform;


//void main() {
//  runApp(MyApp());
//}

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.instance;

  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MyApp(firestore: firestore));
}