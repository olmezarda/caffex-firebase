import 'package:caffex_firebase/data/models/caffe_model.dart';
import 'package:caffex_firebase/data/models/caffe_order_model.dart';
import 'package:caffex_firebase/data/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String surname,
    required String address,
    required String gender,
  }) async {
    final userDoc = _firestore.collection('users').doc(uid);

    await userDoc.set({
      'name': name,
      'surname': surname,
      'address': address,
      'gender': gender,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  Future<List<CartItem>> getUserCart(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return CartItem(
        caffe: CaffeModel(
          id: doc.id,
          name: data['name'] ?? 'Unnamed',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          imagePath: data['imagePath'] ?? '',
          description: data['description'] ?? '',
          isTopSeller: data['isTopSeller'] ?? false,
          category: CaffeCategory.values.firstWhere(
            (e) => e.name == data['category'],
            orElse: () => CaffeCategory.hot,
          ),
        ),
        quantity: data['quantity'] ?? 1,
      );
    }).toList();
  }

  Future<void> addItemToCart(String uid, CartItem item) async {
    final cartDocRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(item.caffe.id);

    final docSnapshot = await cartDocRef.get();

    if (docSnapshot.exists) {
      final existingQuantity = (docSnapshot.data()?['quantity'] ?? 0) as int;
      final newQuantity = existingQuantity + item.quantity;

      await cartDocRef.update({
        'quantity': newQuantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await cartDocRef.set({
        'name': item.caffe.name,
        'price': item.caffe.price,
        'imagePath': item.caffe.imagePath,
        'description': item.caffe.description,
        'isTopSeller': item.caffe.isTopSeller,
        'category': item.caffe.category.name,
        'quantity': item.quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeItemFromCart(String uid, String caffeId) async {
    final cartDocRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(caffeId);
    await cartDocRef.delete();
  }

  Future<void> clearUserCart(String uid) async {
    final cartRef = _firestore.collection('users').doc(uid).collection('cart');
    final snapshot = await cartRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addOrder({
    required String uid,
    required CaffeOrderModel order,
  }) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final address = userDoc.data()?['address'] ?? '';

    await _firestore.collection('orders').add({
      'uid': uid,
      'caffeId': order.id,
      'name': order.name,
      'price': order.price,
      'imagePath': order.imagePath,
      'quantity': order.quantity,
      'address': address,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<CaffeOrderModel>> getUserOrders(String uid) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CaffeOrderModel(
        id: data['caffeId'],
        name: data['name'],
        price: (data['price'] as num).toDouble(),
        imagePath: data['imagePath'],
        quantity: data['quantity'],
        address: data['address'],
      );
    }).toList();
  }

  Future<void> updateUserAddress(String uid, String newAddress) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'address': newAddress,
    });
  }

  Future<void> addFeedback(String message) async {
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
