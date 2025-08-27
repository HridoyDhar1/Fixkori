import 'package:flutter/material.dart';
import '../../../Admin/Auth/data/model/admin_model.dart';
import '../../../Admin/Auth/data/service/admin_service.dart';


class OrderAssignScreen extends StatelessWidget {
  final AdminService _adminService = AdminService();
  static const String name = '/admin_assign';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admins Assign')),
      body: StreamBuilder<List<AdminModel>>(
        stream: _adminService.getAdmins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final admins = snapshot.data;
          if (admins == null || admins.isEmpty) {
            return Center(child: Text('No admins found'));
          }
          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    admin.imageUrl != null && admin.imageUrl!.isNotEmpty
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(admin.imageUrl!),
                    )
                        : CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 16),
                    // Admin info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(admin.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(admin.email,
                              style: TextStyle(color: Colors.grey[600])),
                          SizedBox(height: 4),
                          Text(admin.workType,
                              style: TextStyle(color: Colors.grey[800])),
                        ],
                      ),
                    ),
                    // Buttons
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement assign functionality
                            print('Assign ${admin.name}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Assign'),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Implement block functionality
                            print('Block ${admin.name}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Block'),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
