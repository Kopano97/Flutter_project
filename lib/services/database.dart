import 'dart:async';
import 'package:kopbrewcrew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopbrewcrew/models/user.dart';
import 'package:kopbrewcrew/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');
  Completer<void> completer = Completer<void>();

  Future<void> updateUserData(String sugars, String name, int strength, Duration timeout) async  {
    // Start the set operation
    brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    }).then((_) {
      // Resolve the completer when the set operation is successful
      completer.complete();
    }).catchError((error) {
      // Reject the completer with the error if there's an error
      completer.completeError(error);
    });

    // Set a timer for the specified duration
    Timer(timeout, () {
      if (!completer.isCompleted) {
        // If the set operation has not completed within the timeout, complete with an error
        completer.completeError('Set operation timed out.');
      }
    });

    // Await the completer to wait for the set operation to complete or timeout
    await completer.future;
  }

  //brew list from snapshot
  List<Brew>? _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
        name: doc.get('name') ?? '0',
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugars') ?? '0'
      );
    }).toList();
  }

  //user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(uid: uid,
        sugars: snapshot['sugars'],
        strength: snapshot['strength'],
        name: snapshot['name']
    );
  }
  // get brews stream
  Stream<List<Brew>?> get brews {
      return brewCollection.snapshots()
          .map(_brewListFromSnapshot);
  }

  //get user doc stream

Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
}

}
