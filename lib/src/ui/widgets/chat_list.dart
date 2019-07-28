import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../blocs/chat_bloc_provider.dart';
import '../../models/chat.dart';

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
    bool isFocus = false;

    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final item = chatList[index];
          return new Container(
            margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0
            ),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
//        height: MediaQuery.of(context).size.height,

              child: new Material(
//          borderRadius: BorderRadius.circular(100.0),
                child: new Container(
                    decoration: BoxDecoration(
                      color: isFocus ? Colors.blueAccent.withOpacity(0.25) : null,
                      border: Border.all(
                          width: 2.0,
                          color: Colors.blueAccent.withOpacity(isFocus ? 0.0 : 0.35)
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(150.0) //         <--- border radius here
                      ),
                    ),
                    child: new Container(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            width: 200.0,
                            child: TextField(
                              onTap: (){
//                        setState(() {
//                          isFocus = !isFocus;
//                        });
                              },
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10.0),
                                hintText: "Type a message",
                                border: InputBorder.none,
                              ),
                              onSubmitted: (String str) {
                                print(str);
//                                text += str;
                              },
//                              controller: controller,
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              'PUSH',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
//                              print(text);
//                      this.createMessage();
//                controller.text = '';
                            },
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
          );
//          return Dismissible(
//              key: Key(item.id.toString()),
//              onDismissed: (direction) {
////                _bloc.removeGoal(item.title, widget._emailAddress);
//              },
//              background: Container(color: Colors.red),
//              child: ListTile(
//                leading: Text(chatList[index].to.nickUid.toString()),
//                title: Text(chatList[index].userNameChat(widget._currentUserUid)),
//                subtitle: Text(chatList[index].from.nickUid.toString()),
//              ));
        });
  }
}