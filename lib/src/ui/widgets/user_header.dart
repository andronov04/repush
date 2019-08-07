import 'package:flutter/material.dart';
import 'package:repush/src/blocs/chat_bloc.dart';
import 'package:repush/src/blocs/chat_bloc_provider.dart';


class UserHeaderScreen extends StatefulWidget {
  final String _currentUserUid;

  UserHeaderScreen(this._currentUserUid);

  @override
  UserHeaderState createState() {
    return UserHeaderState();
  }
}

class UserHeaderState extends State<UserHeaderScreen> {
  ChatBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = ChatBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('YOUR ID',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 10.0
              )
          ),
          new FutureBuilder(
              future: _bloc.getUser(widget._currentUserUid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!=null) {
                    print(snapshot.data);
                    return Text(snapshot.data['nickUid'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 16.0
                      ),
                    );
                  } else {
                    return new CircularProgressIndicator();
                  }
                }
                else{
                  return Text('No data');
                }
              }
          )
        ],
      )
    );
  }
}