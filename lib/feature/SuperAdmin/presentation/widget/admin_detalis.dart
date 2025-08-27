import 'package:flutter/material.dart';

import '../../../Admin/Auth/data/model/admin_model.dart';
import '../../../Admin/Auth/data/service/admin_profile_service.dart';


class AdminDetailsPage extends StatelessWidget {
  final String adminId; // Pass this when navigating to details
  final AdminProfileService _adminService = AdminProfileService();

  AdminDetailsPage({required this.adminId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Details')),
      body: FutureBuilder<AdminModel?>(
        future: _adminService.getAdminProfile(adminId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final admin = snapshot.data;
          if (admin == null) {
            return Center(child: Text('Admin not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: admin.imageUrl != null && admin.imageUrl!.isNotEmpty
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(admin.imageUrl!),
                  )
                      : CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                ),
                SizedBox(height: 20),
                Text('Name: ${admin.name}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Email: ${admin.email}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Number: ${admin.number}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Location: ${admin.location}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Work Type: ${admin.workType}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Country: ${admin.country}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Employees: ${admin.employees}', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
