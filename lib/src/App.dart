import 'package:flutter/material.dart';
import 'ui/login.dart';
import 'blocs/login_bloc_provider.dart';
import 'blocs/chat_bloc_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
      child: ChatBlocProvider(
        child: MaterialApp(
          theme: ThemeData(
            accentColor: Colors.black,
            primaryColor: Colors.lightBlueAccent,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                "Repush",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.lightBlueAccent,
              elevation: 0.0,
            ),
            body: LoginScreen(),
          ),
        ),
      ),
    );
  }
}