import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopbrewcrew/models/user.dart';
import 'package:kopbrewcrew/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  MyUser? _userFromFirebaseUser(User user) {

    return user != null ? MyUser(uid:user.uid) : null;
  }


  //auhchange user stream
  Stream<MyUser?> get user {

    return _auth.authStateChanges()
    .map((User? user) => _userFromFirebaseUser(user!));
    //.map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }

  }


  //sign in with email $ password
  Future SignInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  // register with email $ password

  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //crete a new document for the user with the uid
      if(user != null){

        DatabaseService databaseService = await DatabaseService(uid: user.uid);

        dynamic updateResult =  databaseService.updateUserData('0', 'new crew member', 100, Duration(seconds: 5));


        return _userFromFirebaseUser(user!);

      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}