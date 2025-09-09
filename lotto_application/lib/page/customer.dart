import 'package:flutter/material.dart';

import 'login.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข่อยเป็นลูกค้า'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // if (value == 'profile') {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("ไปที่ข้อมูลส่วนตัว 📋")),
              //   );
              //   // Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              // }
              if (value == 'logout') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false, // เคลียร์ทุกหน้าออกจาก stack
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ออกจากระบบสำเร็จ ✅")),
                );
              }
            },
            itemBuilder: (context) => [
              // const PopupMenuItem(
              //   value: 'profile',
              //   child: Text('ข้อมูลส่วนตัว'),
              // ),
              const PopupMenuItem(value: 'logout', child: Text('ออกจากระบบ')),
            ],
          ),
        ],
      ),
      body: Container(color: Colors.amber),
    );
  }
}
