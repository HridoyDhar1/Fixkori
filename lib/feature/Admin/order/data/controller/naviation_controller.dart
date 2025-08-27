import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var notificationCount = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    // 🔥 Listen to Firestore orders with "pending" status
    FirebaseFirestore.instance.collection("serviceApp")
        .doc("appData")
        .collection("orders")
        .where("status", isEqualTo: "pending")
        .snapshots()
        .listen((snapshot) {
      notificationCount.value = snapshot.docs.length;
    });
  }
}
