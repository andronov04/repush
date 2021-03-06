import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/strings.dart';
import 'package:flutter/material.dart';
import '../../blocs/login_bloc_provider.dart';
import '../chat_list.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  LoginBloc _bloc;

  String _homeScreenText = "Waiting for token...";
  String _token = '';



  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void currentAuthUser() async {
    print('currentUser');
    _bloc.currentAuthUser().then((FirebaseUser user) {
      // ignore: unrelated_type_equality_checks
      print(user.uid);
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatList(user.uid)));
      }
    });
  }

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

      _firebaseMessaging.subscribeToTopic("ios");
      print('subscirebd');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";

        setState(() {
          _token = token;
        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    currentAuthUser();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        loginButton()
      ],
    );
  }


  Widget loginButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return RaisedButton(
        child: Text(StringConstant.submit),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          authenticateUser();
        });
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.submit().then((value) {
      if (value != null) {

        if(_token != ''){
          _bloc.setTokenToUser(value, _token);
        }

        //New User
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatList(value)));
//        _bloc.registerUser().then((value) {
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => ChatList(value)));
//        });
      } else {
        // TODO check
        if(_token != ''){
          _bloc.setTokenToUser(value, _token);
        }
        //Already registered
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatList(value)));
      }
    });
  }
}