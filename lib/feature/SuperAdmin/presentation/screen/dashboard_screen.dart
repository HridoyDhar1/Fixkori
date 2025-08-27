import 'package:flutter/material.dart';
import 'package:serviceapp/feature/SuperAdmin/presentation/widget/admin_detalis.dart';
import '../../../Admin/Auth/data/model/admin_model.dart';
import '../../../Admin/Auth/data/service/admin_service.dart';


class AdminDashboardScreen extends StatelessWidget {
  final AdminService _adminService = AdminService();
  static const String name='/admin_dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),
      appBar: AppBar(
automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent

          ,title: Text('Admins')),
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
              return GestureDetector(
                onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDetailsPage(adminId: admin.id!))); ; },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Admin Avatar
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(admin.email, style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 4),
                            Text(admin.workType, style: TextStyle(color: Colors.grey[800])),
                          ],
                        ),
                      ),
                      // Block button
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Implement your block functionality here
                              print('Block ${admin.name}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Assign',style: TextStyle(color: Colors.white),),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your block functionality here
                              print('Block ${admin.name}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Block',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
