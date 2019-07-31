import 'package:flutter/material.dart';
import 'package:repush/src/blocs/chat_bloc_provider.dart';
import 'package:repush/src/models/chat.dart';
import '../../../utils.dart';

class ChatItemScreen extends StatefulWidget {
  final String _currentUserUid;
  final Chat chat;

  final int indexChat;

  ChatItemScreen(this._currentUserUid, this.chat, this.indexChat);

  @override
  _ChatItemState createState() {
    return _ChatItemState();
  }
}

class _ChatItemState extends State<ChatItemScreen> {
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

  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var index = widget.indexChat;
    var chatActiveIndex = -1;
    var item = widget.chat;

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
                color: chatActiveIndex == index ?
                HexColor(item.useColorChat(widget._currentUserUid)).withOpacity(0.25)
                    : null,
                border: Border.all(
                    width: 2.0,
                    color: HexColor(item.useColorChat(widget._currentUserUid)).withOpacity(chatActiveIndex == index ? 0.0 : 0.35)
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
                          setState(() {
                            chatActiveIndex = index;
                          });
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
                        controller: controller,
                      ),
                    ),
                    Text(item.userNameChat(widget._currentUserUid)),
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
                      color: HexColor(item.useColorChat(widget._currentUserUid)),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        print(controller.text);
                        _bloc.createMsg(widget._currentUserUid, item.id, controller.text);
//                      this.createMessage();
                        controller.text = '';
                      },
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}