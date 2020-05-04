class User {
  int _nickUid;
  String _id;
  String _displayName;
  String _color;
  bool _currentUser = false;

  User(this._id, this._nickUid, this._displayName, this._color);

  String get id => _id;
  String get displayName => _displayName;
  String get color => _color;
  int get nickUid => _nickUid;
  bool get currentUser => _currentUser;
//
//  // ignore: unnecessary_getters_setters
//  set nickUid(int value) => _nickUid = value;
}