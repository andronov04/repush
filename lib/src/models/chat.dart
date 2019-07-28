import 'user.dart';

class Chat {
  final String _helloText;
  final bool _isPending;
  final bool _isBlock;
  final String _id;
  final User _from;
  final User _to;

  Chat(this._id, this._isPending, this._isBlock, this._helloText,
      this._from, this._to);

  String get id => _id;
  String get helloText => _helloText;
  bool get isPending => _isPending;
  bool get isBlock => _isBlock;

  User get from => _from;
  User get to => _to;

  String userNameChat(String currentUserUid) {
    if(currentUserUid == this.to.id){
      return this.from.nickUid.toString();
    }
    return this.to.nickUid.toString();
  }
}