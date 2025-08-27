import 'package:get/get.dart';

import '../data/model/admin_model.dart';
import '../data/repository/admin_repostiory.dart';

class AdminProfileController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  late Stream<AdminModel> adminStream;

  void fetchAdmin(String adminId) {
    adminStream = _adminRepository.getAdminStream(adminId);
  }
}