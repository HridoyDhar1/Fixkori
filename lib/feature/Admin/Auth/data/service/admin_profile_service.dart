
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/admin_model.dart';

class AdminProfileService {
  final CollectionReference adminsCollection =
  FirebaseFirestore.instance.collection('admins_profile');

  Future<AdminModel?> getAdminProfile(String userId) async {
    try {
      QuerySnapshot snapshot = await adminsCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return AdminModel.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching admin profile: $e");
      return null;
    }
  }
}
