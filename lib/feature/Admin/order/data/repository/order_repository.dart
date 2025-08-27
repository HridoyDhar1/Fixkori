import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serviceapp/feature/Admin/order/data/model/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore
        .collection("serviceApp")
        .doc("appData")
        .collection("orders")
        .add(order.toMap());
  }
}
