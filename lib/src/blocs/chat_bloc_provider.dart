import 'package:flutter/material.dart';
import 'chat_bloc.dart';
export 'chat_bloc.dart';
class ChatBlocProvider extends InheritedWidget{
  final bloc = ChatBloc();

  ChatBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static ChatBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ChatBlocProvider) as ChatBlocProvider).bloc;
  }
}