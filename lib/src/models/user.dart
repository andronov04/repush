class User {
  int _nickUid;
  String _id;
  String _displayName;
  bool _currentUser = false;

  User(this._id, this._nickUid, this._displayName);

  String get id => _id;
  String get displayName => _displayName;
  int get nickUid => _nickUid;
  bool get currentUser => _currentUser;
//
//  // ignore: unnecessary_getters_setters
//  set nickUid(int value) => _nickUid = value;
}