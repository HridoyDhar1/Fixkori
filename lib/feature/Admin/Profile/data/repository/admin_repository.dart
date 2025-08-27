import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Auth/data/model/admin_model.dart';


class AdminRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch admin profile data for the current user
  Future<AdminModel?> fetchAdminData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final snapshot = await _firestore
          .collection("serviceApp")
          .doc("appData")
          .collection("admins_profile")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return AdminModel.fromMap(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
