import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/admin_model.dart';


class AdminService {
  final CollectionReference _adminsCollection =
  FirebaseFirestore.instance.collection('admins');

  // Fetch all admins as a stream
  Stream<List<AdminModel>> getAdmins() {
    return _adminsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add Firestore document ID
        return AdminModel.fromMap(data);
      }).toList();
    });
  }

  // Fetch once (optional)
  Future<List<AdminModel>> getAdminsOnce() async {
    final snapshot = await _adminsCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return AdminModel.fromMap(data);
    }).toList();
  }
}
