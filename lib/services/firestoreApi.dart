import 'package:bask_app/model/address.dart';
import 'package:bask_app/model/cart.dart';
import 'package:bask_app/model/donation.dart';
import 'package:bask_app/model/user.dart';
import 'package:bask_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirestoreApi {
  final db = FirebaseFirestore.instance;

  // firestore api for user -------

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

  Stream<User?> getCurrentUserDetailsStream(String userId) {
    DocumentReference ref = db.doc('users/${userId}');
    final snapshot = ref.snapshots();
    return snapshot.map((snapshot) => User.fromJson(snapshot.data()));
  }

  Future<Address> getUserDefaultAddress(
      String defaultAddressId, String uid) async {
    DocumentReference ref = db.doc('users/$uid/addresses/$defaultAddressId');
    final snapshot = await ref.get();
    return Address.fromJson(snapshot.data());
  }

  Future<bool> isNewIser(String userId) async {
    DocumentReference ref = db.doc('users/${userId}');
    final snapshot = await ref.get();
    return !snapshot.exists;
  }

  //--------------------------------------------------------------------------

  // firestore api for donation-------

  Stream<List<Donation>> getDonationStream() {
    CollectionReference reference = db.collection('Donations');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Donation.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<Donation> getDonationById(String id) async {
    DocumentReference ref = db.doc('Donations/$id');
    DocumentSnapshot snapshot = await ref.get();
    return Donation.fromJson(snapshot.data(), snapshot.id);
  }

  Future<void> postDonation(Donation donation) async {
    CollectionReference ref = db.collection('Donations');
    await ref.add(donation.toJson());
  }

  Future<void> editDonation(Donation donation, String oldDonationId) async {
    DocumentReference ref = db.doc('Donations/$oldDonationId');
    await ref.update(donation.toJson());
  }

  Stream<List<Donation>> getMyDonation({required String uid}) {
    final reference =
        db.collection('Donations').where('donor id', isEqualTo: uid);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Donation.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<void> deleteMyDonation(String donationId) async {
    DocumentReference ref = db.doc('Donations/$donationId');
    await ref.delete();
  }

  //--------------------------------------------------------------------------

  //firestore api for cart----------

  Stream<List<Cart>> getMyCartItemsStream({required String userid}) {
    CollectionReference reference = db.collection('users/$userid/cart');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Cart.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<void> addToCart(
      {required String userid,
      required Cart newCartItem,
      required BuildContext context}) async {
    CollectionReference ref = db.collection('users/$userid/cart');
    DocumentReference donationRef =
        db.doc('Donations/${newCartItem.donatonid}');
    return db.runTransaction((transaction) async {
      final cartSnapshot =
          await ref.where('donationId', isEqualTo: newCartItem.donatonid).get();
      if (cartSnapshot.size == 0) {
        final user = Provider.of<User?>(context, listen: false);
        transaction.set(ref.doc(), newCartItem.toJson());
        DocumentReference userref = db.doc('users/${userid}');
        transaction
            .update(userref, {'cart item count': user!.cartItemCount + 1});
      } else {
        final donationSnapshot = await transaction.get(donationRef);
        Donation donation =
            Donation.fromJson(donationSnapshot.data(), donationSnapshot.id);
        Cart cartItem =
            Cart.fromJson(cartSnapshot.docs[0].data(), cartSnapshot.docs[0].id);
        if (donation.remainingQuantity > cartItem.count) {
          DocumentReference ref =
              db.doc('users/$userid/cart/${cartSnapshot.docs[0].id}');
          Cart cartitem = Cart.fromJson(
              cartSnapshot.docs[0].data(), cartSnapshot.docs[0].id);
          transaction.update(ref, {'count': cartitem.count + 1});
        } else {
          throw Exception();
        }
      }
    });
  }

  Future<void> incrementCount(int cartid, String userId) async {
    final ref = db.doc('users/$userId/cart/$cartid');
    return db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await ref.get();
      Cart cart = Cart.fromJson(snapshot.data(), snapshot.id);
      if ((cart.count + 1) <= cart.item.remainingQuantity) {
        int newCount = cart.count + 1;
        transaction.update(ref, {'count': newCount});
      } else {
        throw Exception('does not have enough item to add');
      }
    });
  }

  Future<void> decrementCount(Cart cart, String userId) async {
    final ref = db.doc('users/$userId/cart/${cart.cartItemId}');
    await ref.update({'count': cart.count - 1});
  }

  Future<void> removeCartItem(
      Cart cart, String userId, BuildContext context) async {
    final ref = db.doc('users/$userId/cart/${cart.cartItemId}');
    final user = Provider.of<User?>(context, listen: false);
    DocumentReference userDoc = db.doc('users/${userId}');
    await ref.delete();
    userDoc.update({'cart item count': user!.cartItemCount - 1});
  }

  Future<void> removeAllCartItem(String userId) async {
    CollectionReference ref = db.collection('users/$userId/cart');
    var snapshots = await ref.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}
