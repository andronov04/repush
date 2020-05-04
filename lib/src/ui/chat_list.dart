import 'package:repush/src/ui/widgets/add_user_header.dart';
import 'package:repush/src/ui/widgets/user_header.dart';

import 'package:flutter/material.dart';
import 'widgets/chat_list.dart';

class ChatList extends StatefulWidget {
  final String _currentUserUid;

  ChatList(this._currentUserUid);

  @override
  ChatListState createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
//  TabController _tabController;

  @override
  void initState() {
    super.initState();
//    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
//    _tabController.removeListener(_handleTabIndex);
//    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      backgroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: new Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            left: 30.0,
            right: 25.0,
            top: 24.0
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              UserHeaderScreen(widget._currentUserUid),
              AddUserHeaderScreen(widget._currentUserUid)
            ],
          ),
        ),
      ),
      body: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
        child: ChatListScreen(widget._currentUserUid),
      ),
    );
  }
}