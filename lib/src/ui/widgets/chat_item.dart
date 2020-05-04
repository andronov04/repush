import 'package:flutter/material.dart';
import 'package:repush/src/blocs/chat_bloc_provider.dart';
import 'package:repush/src/models/chat.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    var item = widget.chat;


    if(item.isPending){
      // check if i requested to another user
      bool to = item.to.id != widget._currentUserUid;

      return new Container(
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: new Container(
            margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0
            ),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              child: new Material(
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
          ),
        ),
      );
    }

    return new Container(

      margin: EdgeInsets.only(
        right: 20.0,
        left: 20.0,
        top: 20.0
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            icon: Icons.delete,
            color: Colors.transparent,
            foregroundColor: HexColor(item.useColorChat(widget._currentUserUid)),
            onTap: (){
              _bloc.confirmChat(item.id, true);
            },
          ),
        ],
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          child: new Material(
            child: StreamBuilder(
                stream: _bloc.activeIndex,
                builder:
                (BuildContext context, snapshot){
                  return new Container(
                      decoration: BoxDecoration(
                        color: snapshot.data == index ?
                        HexColor(item.useColorChat(widget._currentUserUid)).withOpacity(0.25)
                            : null,
                        border: Border.all(
                            width: 2.0,
                            color: HexColor(item.useColorChat(widget._currentUserUid)).withOpacity(snapshot.data == index ? 0.0 : 0.35)
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
                            Expanded(
                                flex: 6,
                                child: new Container(
                                  padding: EdgeInsets.only(
                                      right: 10.0
                                  ),
                                  child: TextField(
                                    onTap: (){
                                      _bloc.setActiveIndex(index);
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
                                )
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
                                if(controller.text != ''){
                                  _bloc.createMsg(widget._currentUserUid, item.id, controller.text);
                                }
                                controller.text = '';
                              },
                            ),
                          ],
                        ),
                      )
                  );
                }
            )
          ),
        ),
      ),
    );
  }
}