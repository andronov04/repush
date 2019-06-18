import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

//    final logoutButton = Container(
//      padding: EdgeInsets.all(10.0),
//      child: FlatButton(
//        color: Colors.white,
//        onPressed: () {
//          signOut();
//        },
//        child: Text(
//          "Sign Out",
//          style: TextStyle(color: Colors.black),
//        ),
//      ),
//    );

    return Scaffold(
      backgroundColor: Colors.lightBlue,
//      appBar: AppBar(
//        title: Text("RePush Login"),
//      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            loginbutton,
//            logoutButton,
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static final String route = "home-page";

  final FirebaseUser user;

  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
//      appBar: AppBar(
//        title: Text("RePush"),
//      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${user.uid}"),
            Text("${user.displayName}"),
            Text("${user.isAnonymous}")
          ],
        ),
      ),
    );
  }
}