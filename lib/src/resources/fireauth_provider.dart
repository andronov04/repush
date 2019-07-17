import 'package:firebase_auth/firebase_auth.dart';

class FireauthProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<int> authenticateUser() async { //FirebaseUser
    FirebaseUser user = await firebaseAuth.signInAnonymously();
    print("Signed in ${user.uid}");
    return 1;
  }

  Future<int> authenticateUserOld(String email, String password) async {

//    final QuerySnapshot result = await _firestore
//        .collection("users")
//        .where("email", isEqualTo: email)
//        .getDocuments();
//    final List<DocumentSnapshot> docs = result.documents;
//    if (docs.length == 0) {
//      return 0;
//    } else {
//      return 1;
//    }
  }
}