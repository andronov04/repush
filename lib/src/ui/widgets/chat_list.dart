import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../blocs/chat_bloc_provider.dart';
import '../../models/chat.dart';

class MyGoalsListScreen extends StatefulWidget {
  final String _emailAddress;

  MyGoalsListScreen(this._emailAddress);

  @override
  _MyGoalsListState createState() {
    return _MyGoalsListState();
  }
}

class _MyGoalsListState extends State<MyGoalsListScreen> {
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
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: StreamBuilder(
          stream: _bloc.myGoalsList(widget._emailAddress),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot doc = snapshot.data;
              List<Chat> goalsList = _bloc.mapToList(doc: doc);
              if (goalsList.isNotEmpty) {
                return buildList(goalsList);
              } else {
                return Text("No Goals");
              }
            } else {
              return Text("No Goals");
            }
          }),
    );
  }

  ListView buildList(List<Chat> goalsList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: goalsList.length,
        itemBuilder: (context, index) {
          final item = goalsList[index];
          return Dismissible(
              key: Key(item.id.toString()),
              onDismissed: (direction) {
                _bloc.removeGoal(item.title, widget._emailAddress);
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(
                  goalsList[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(goalsList[index].message),
              ));
        });
  }
}