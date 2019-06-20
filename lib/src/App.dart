import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.route: (BuildContext context) => LoginPage(),
    HomePage.route: (BuildContext context) => HomePage(),
  };

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
  bool _topicButtonsDisabled = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
  TextEditingController(text: 'topic');

//  Widget _buildDialog(BuildContext context, Item item) {
//    return AlertDialog(
//      content: Text("Item ${item.itemId} has been updated"),
//      actions: <Widget>[
//        FlatButton(
//          child: const Text('CLOSE'),
//          onPressed: () {
//            Navigator.pop(context, false);
//          },
//        ),
//        FlatButton(
//          child: const Text('SHOW'),
//          onPressed: () {
//            Navigator.pop(context, true);
//          },
//        ),
//      ],
//    );
//  }

//  void _showItemDialog(Map<String, dynamic> message) {
//    showDialog<bool>(
//      context: context,
//      builder: (_) => _buildDialog(context, _itemForMessage(message)),
//    ).then((bool shouldNavigate) {
//      if (shouldNavigate == true) {
//        _navigateToItemDetail(message);
//      }
//    });
//  }
//
//  void _navigateToItemDetail(Map<String, dynamic> message) {
//    final Item item = _itemForMessage(message);
//    // Clear away dialogs
//    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//    if (!item.route.isCurrent) {
//      Navigator.push(context, item.route);
//    }
//  }

  @override
  void initState() {
    super.initState();
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
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
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
            Text("It's working!")
          ],
        ),
      ),
    );
  }

  void _clearTopicText() {
    setState(() {
      _topicController.text = "";
      _topicButtonsDisabled = true;
    });
  }
}