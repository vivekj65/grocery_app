import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_apk/models/banner.dart';
import 'package:grocery_apk/models/grocery_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_apk/models/cart_items.dart';
import 'package:grocery_apk/models/order.dart';
import 'package:grocery_apk/models/shipping_address.dart';

class APIs {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage ImageStore = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  // For creating a new User
  static Future<void> createUser() async {
    final User = GroceryUser(
      email: user.email.toString(),
      name: user.displayName.toString(),
      id: user.uid,
    );
    return await firestore.collection('users').doc(user.uid).set(User.toJson());
  }

  //for checking user exits or not..?
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

// Banner get from firebase
  static Future<List<Carousal>> getCarousal() async {
    List<Carousal> carousals = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('banner').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      carousals.add(
        Carousal.fromJson(doc.data() as Map<String, dynamic>),
      );
    }

    return carousals;
  }

  // Get user Data from firestore
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSelfInfo() {
    final groceryUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots();
    return groceryUser;
  }

  // Get Wishlist
  static Stream<QuerySnapshot> getWishlist(String userId) {
    return FirebaseFirestore.instance
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // final Product product;

  // For adding into Cart
  static Future<void> addToCart(CartItem cartItem) async {
    final userId = user.uid;

    final CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('carts');

    await cartCollection
        .doc(userId)
        .collection('cartItems')
        .doc(cartItem.cartItemId)
        .set(cartItem.toMap());
    log('Item added to cart successfully');
  }

  // For Remove Cart Item
  static Future<void> removeFromCart(String productId) async {
    final userId = user.uid;

    final DocumentReference cartItemDocRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('cartItems')
        .doc(productId);

    final cartItemDocSnapshot = await cartItemDocRef.get();

    if (cartItemDocSnapshot.exists) {
      await cartItemDocRef.delete();
      print('Item removed from cart successfully');
    } else {
      print('Item not found in the cart');
    }
  }

  static Future<void> addAddress(ShippingAddress address) async {
    final userId = user.uid;

    final CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('shipping_address');

    await cartCollection
        .doc(userId)
        .collection('address')
        .doc(address.id)
        .set(address.toMap());
    log('Address Saved');
  }

  static Future<void> deleteAddress(String addressId) async {
    final userId = APIs.auth.currentUser!.uid;

    final addressRef = FirebaseFirestore.instance
        .collection('shipping_address')
        .doc(userId)
        .collection('address')
        .doc(addressId);
    await addressRef.delete();
  }

  Future<List<Orders>> getUserOrders(String userId) async {
    List<Orders> userOrders = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_orders')
          .get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        userOrders.add(Orders.fromMap(data));
      });
    } catch (e) {
      print("Error fetching user orders: $e");
    }
    return userOrders;
  }
}
