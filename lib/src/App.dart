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
      theme: ThemeData.light(),
//      home: LoginPage(),
      home: TestPage(),
      routes: routes,
    );
  }
}


class TestPage extends StatelessWidget {

  final topBar = new AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    elevation: 1.0,
    leading: new Icon(Icons.notifications_none),
    title: Text('Repush'),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(Icons.add_circle_outline),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: topBar,
        body: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
//            new ListTile(
//              title: Text('@stevejobs'),
//              trailing: FlatButton(
//                color: Colors.lightBlue,
//                textColor: Colors.white,
//                child: Text('PUSH'),
//                onPressed: () {},
//              ),
//              subtitle: TextField(
//                decoration: InputDecoration(
//                    hintText: 'Hi dude!'
//                ),
//              ),
//            ),

            new Container(
              padding: EdgeInsets.all(10.0),
              height: 100.0,
              color: Colors.transparent,
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey,
                      borderRadius: new BorderRadius.all(Radius.circular(8.0))),
                  child: new Center(
                    child:
                    new ListTile(
                        title: Text('@stevejobs'),
                        trailing: FlatButton(
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          child: Text('PUSH'),
                          onPressed: () {},
                        ),
                        subtitle: TextField(
                          decoration: InputDecoration(
                              hintText: 'Hi dude!'
                          ),
                        ),
                    ),
                  )),
            ),

            new Divider(
              height: 1.0,
            ),

          ],
        )
      )

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

  Future<void> createUserIfNotExists()  async{
    print('Create user');
//    Firestore.instance.collection('users').document(widget.user.uid)
//        .setData({ 'uid': widget.user.uid});

//    _firebaseDatabase.reference().child('messages').child('id')
//        .set({
//      'title': 'Realtime db rocksssss',
//    });
  }

  @override
  void initState() {
    super.initState();

//    createUserIfNotExists();

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


        Firestore.instance
            .collection('tokens')
            .document(widget.user.uid)
            .setData({
              'token': token,
              'createdAt': FieldValue.serverTimestamp(), // optional
            });
      });
      print(_homeScreenText);
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children:[
          Positioned(
            left: 35,
            top: 50,
            height: 50,
            child: new Container(
              width: 150.0,
              child: UserInfo(user: widget.user)
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
//            margin: EdgeInsets.only(left:10.0),
            child:
            Chat(user: widget.user),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Chat(user: widget.user),
////                PushText(),
////                Text("It's working!"),
////                Text("${widget.user.uid}")
//              ],
//            ),
          )

        ]
      ),
    );
  }
}

class PushText extends StatefulWidget {

  @override
  _PushTextState createState() => _PushTextState();
}

class _PushTextState extends State<PushText> {
  String results = "";

  final TextEditingController controller = new TextEditingController();
  final Firestore firestore = Firestore.instance;

  Future<void> createMessage(String text)  async{
    print('Create message');

     firestore.collection('messages').document().setData({ 'text': text});
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new TextField(
          decoration: new InputDecoration(hintText: "Enter text here..."),
          onSubmitted: (String str) {
            this.createMessage(controller.text);
            setState(() {
              results = results + "\n" + str;
              controller.text = "";
            });
          },
          controller: controller,
        ),
        new Text(results)
      ],
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

class Chat extends StatelessWidget {

  final Firestore firestore = Firestore.instance;
  final FirebaseUser user;

  Chat({this.user});

  Widget _buildChatItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(document['avatarUrl']),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            document['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            document['time'],
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
        ],
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          document['message'],
          style: TextStyle(color: Colors.grey, fontSize: 15.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('chats').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                index == 0
                    ? Container()
                    : Divider(
                  height: 10.0,
                ),
                _buildChatItem(context, snapshot.data.documents[index]),
                index == snapshot.data.documents.length-1
                    ? Divider(
                  height: 10.0,
                )
                    : Container(),
              ],
            ));
      },
    );
  }
}