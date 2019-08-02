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

    if(item.isPending){
      print(item.to.id);
      print(widget._currentUserUid);

      // check if i requested to another user
      bool to = item.to.id != widget._currentUserUid;
      print(to);

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
                child: new Container(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 4.0,
                    top: 4.0,
                    bottom: 4.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(to ? 'REQUESTED' : 'REQUEST',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10.0
                              )
                          ),
                          Text(item.userNameChat(widget._currentUserUid),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              )
                          )
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          !to ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.black54, size: 16.0),
                            padding: EdgeInsets.all(0.0),
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            iconSize: 2.0,
                            tooltip: 'Increase volume by 10',
                            onPressed: () {
//                              setState(() {
//                              });
                              _bloc.confirmChat(item.id, true);
                            },
                          ) : Text(''),
                          FlatButton(
                            child: Text(
                              to ? 'CANCEL' : 'CONFIRM',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            textColor: Colors.white,
                            color: Colors.black54,
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                                if(to){
                                  _bloc.confirmChat(item.id, true);
                                }
                                else{
                                  _bloc.confirmChat(item.id, false);
                                }
//                      this.createMessage();
                              controller.text = '';
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
            ),
          ),
        ),
      );
    }

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
                      width: 190.0,
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
                    new Container(
                      padding: EdgeInsets.only(
                        right: 10.0
                      ),
                      child: Text(
                        item.userNameChat(widget._currentUserUid),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
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
                      color: HexColor(item.useColorChat(widget._currentUserUid)),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        print(controller.text);
                        if(controller.text != ''){
                          _bloc.createMsg(widget._currentUserUid, item.id, controller.text);
                        }
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