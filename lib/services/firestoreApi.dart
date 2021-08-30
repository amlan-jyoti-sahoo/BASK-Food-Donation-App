import 'package:bask_app/model/address.dart';
import 'package:bask_app/model/donation.dart';
import 'package:bask_app/model/user.dart';
import 'package:bask_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirestoreApi {
  final db = FirebaseFirestore.instance;

  Future<void> userSignUp1(User user, String userId) async {
    DocumentReference ref = db.doc('users/$userId');
    await ref.set(user.toJson());
  }

  Future<void> userSignUpWithEmail(
      User newUser, Address address, BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = await auth.createUserWithEmailAndPassword(
      newUser.email,
      newUser.password!,
    );
    if (user != null) {
      DocumentReference ref = db.doc('users/${user.uid}');
      await ref.set(newUser.toJson()).then((_) async {
        DocumentReference ref =
            db.doc('users/${user.uid}/addresses/first_address');
        await ref.set(address.toJson());
      });
      user.updateDisplayName('BASK USER');
      auth.signOut();
    }
  }

  Future<void> userSignUpWithThirdparyProvider(
      User newUser, Address address, BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = auth.currentuser;
    if (user != null) {
      DocumentReference ref = db.doc('users/${user.uid}');
      await ref.set(newUser.toJson()).then((_) async {
        DocumentReference ref =
            db.doc('users/${user.uid}/addresses/first_address');
        await ref.set(address.toJson());
      });
    }
    user!.updateDisplayName('BASK USER');
  }

  Stream<List<Donation>> getDonationStream() {
    CollectionReference reference = db.collection('Donations');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Donation.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }
}
