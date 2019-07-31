import 'package:repush/src/ui/widgets/user_header.dart';

import '../utils/strings.dart';
import 'package:flutter/material.dart';
import 'widgets/chat_list.dart';
//import 'widgets/people_goals_list.dart';
//import 'add_goal.dart';

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
      appBar: PreferredSize(
        preferredSize: Size(null, 35),
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: 35,
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              UserHeaderScreen(widget._currentUserUid),
              Text('add user')
            ],
          ),
        ),
      ),
      body: ChatListScreen(widget._currentUserUid),
    );
  }
}