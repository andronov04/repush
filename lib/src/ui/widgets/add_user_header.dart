import 'package:flutter/material.dart';
import 'package:repush/src/blocs/chat_bloc.dart';
import 'package:repush/src/blocs/chat_bloc_provider.dart';

import '../../../utils.dart';


class AddUserHeaderScreen extends StatefulWidget {
  final String _currentUserUid;

  AddUserHeaderScreen(this._currentUserUid);

  @override
  AddUserHeaderState createState() {
    return AddUserHeaderState();
  }
}

class AddUserHeaderState extends State<AddUserHeaderScreen> {
  ChatBloc _bloc;

  final TextEditingController controller = new TextEditingController();

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


//      width: 50.0,
      child: new Container(
          decoration: BoxDecoration(
//            color: HexColor('#002b36').withOpacity(0.25),
            border: Border.all(
                width: 2.0,
                color: HexColor('#002b36').withOpacity(0.35)
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(50.0) //         <--- border radius here
            ),
          ),
          child: new Container(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  width: 100.0,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 12.0
                    ),
                    onTap: (){},
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5.0),
                      hintText: "Enter ID to add",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 12.0
                      )
                    ),
                    onSubmitted: (String str) {
                      print(str);
//                                text += str;
                    },
                    controller: controller,
                  ),
                ),
                Container(
                  width: 27,
                  child: FlatButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textColor: Colors.white,
                    color: HexColor('#002b36'),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                    onPressed: () {
                      print(controller.text);
                      if(controller.text != ''){
                        _bloc.createChat(widget._currentUserUid, controller.text);
                      }
                      controller.text = '';
                    },
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}