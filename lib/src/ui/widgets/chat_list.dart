import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../blocs/chat_bloc_provider.dart';
import '../../models/chat.dart';
import 'chat_item.dart';

class ChatListScreen extends StatefulWidget {
  final String _currentUserUid;

  ChatListScreen(this._currentUserUid);

  @override
  _ChatListState createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatListScreen> {
  ChatBloc _bloc;
  int chatActiveIndex = -1;

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
    print(widget._currentUserUid);
    return Container(
      alignment: Alignment(0.0, 0.0),
      child:
      StreamBuilder(
          stream: _bloc.chatList(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot docs = snapshot.data;
              List<Chat> chatList = _bloc.mapToList(docs: docs);

              return buildList(chatList);
            } else {
              return Text("No chats");
            }
          }),
    );
  }

  ListView buildList(List<Chat> chatList) {
    return ListView.builder(
//        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final item = chatList[index];
          return ChatItemScreen(widget._currentUserUid, item, index);
        });
  }
}