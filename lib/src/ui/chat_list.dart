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
//      appBar: AppBar(
//        title: Text(
//          StringConstant.goalListTitle,
//          style: TextStyle(
//            color: Colors.black,
//          ),
//        ),
//        backgroundColor: Colors.amber,
//        elevation: 0.0,
//        bottom: TabBar(
//          controller: _tabController,
//          tabs: <Tab>[
//            Tab(text: StringConstant.worldTab),
//            Tab(text: StringConstant.myTab),
//          ],
//        ),
//      ),
      body: ChatListScreen(widget._currentUserUid),
    );
  }

//  Widget _bottomButtons() {
//    if (_tabController.index == 1) {
////      return FloatingActionButton(
////          child: Icon(Icons.add),
////          onPressed: () {
////            Navigator.push(
////                context,
////                MaterialPageRoute(
////                    builder: (context) => AddGoalScreen(widget._emailAddress)));
////          });
//    } else {
//      return null;
//    }
//  }
}