import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'dart:async';

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.route: (BuildContext context) => LoginPage(),
    HomePage.route: (BuildContext context) => HomePage(),
  };

  MyApp({this.firestore});
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RePush',
      theme: ThemeData.dark(),
      home: LoginPage(),
      routes: routes,
    );
  }
}

class LoginPage extends StatefulWidget {
  static final String route = "login-page";
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signInAnon() async {
    FirebaseUser user = await firebaseAuth.signInAnonymously();
    print("Signed in ${user.uid}");
    return user;
  }

  void signOut() {
    firebaseAuth.signOut();
    print('Signed Out!');
  }

  @override
  Widget build(BuildContext context) {
    final loginbutton = Container(
      padding: EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.white,
        elevation: 10.0,
        child: MaterialButton(
          minWidth: 150.0,
          height: 50.0,
          color: Colors.white,
          textColor: Colors.black87,
          child: Text('Login as Anonymus'),
          onPressed: () {
            signInAnon().then((FirebaseUser user) {
              Navigator
                  .of(context)
                  .push(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                    user: user,
                  )))
                  .catchError((e) => print(e));
            });
          },
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            loginbutton,
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  static final String route = "home-page";

  final FirebaseUser user;

  HomePage({this.user});

  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();

}

class _PushMessagingExampleState extends State<HomePage> {
  String _homeScreenText = "Waiting for token...";

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//  CollectionReference get messages => widget.firestore.collection('messages');
//
//  Future<void> _addMessage() async {
//    await messages.add(<String, dynamic>{
//      'message': 'Hello world!',
//      'created_at': FieldValue.serverTimestamp(),
//    });
//  }

  void createUserIfNotExists()  {
    print('Create user');
    Firestore.instance.collection('users').document(widget.user.uid)
        .setData({ 'uid': widget.user.uid});

//    _firebaseDatabase.reference().child('messages').child('id')
//        .set({
//      'title': 'Realtime db rocksssss',
//    });
  }


  @override
  void initState() {
    super.initState();

    createUserIfNotExists();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");

      _firebaseMessaging.subscribeToTopic("ios");
      print('subscirebd');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
        // TODO add token to user in firestore and update token
      });
      print(_homeScreenText);
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserInfo(user: widget.user),
//            Text("It's working!"),
//            Text("${widget.user.uid}")
          ],
        ),
      ),
    );
  }
}


class UserInfo extends StatelessWidget {

  final Firestore firestore = Firestore.instance;
  final FirebaseUser user;

  UserInfo({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('users').document(user.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return Text('Loading...');
        switch (snapshot.connectionState) {
          case ConnectionState.none: return Text('Select lot');
          case ConnectionState.waiting: return Text('Awaiting bids...');
          case ConnectionState.active: return Text('YOUR ID: ${snapshot.data['nickUid']}  ');
          case ConnectionState.done: return Text('\$${snapshot.data} (closed)');
        }
        return null; // unreachable
      },
    );
  }
}