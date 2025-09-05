// import 'package:flutter/material.dart';

// import 'login.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   String text = 'หากมีบัญชีอยู่แล้ว?';

//   @override
//   Widget build(BuildContext context) {
//     void login() {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     }

//     // void register() {}

//     return Scaffold(
//       appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                 child: Text("ชื่อ-สกุล", style: TextStyle(fontSize: 15)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1),
//                     ),
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                 child: Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 15)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1),
//                     ),
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                 child: Text("อีเมล", style: TextStyle(fontSize: 15)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1),
//                     ),
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                 child: Text("รหัสผ่าน", style: TextStyle(fontSize: 15)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1),
//                     ),
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                 child: Text("ยืนนันรหัสผ่าน", style: TextStyle(fontSize: 15)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1),
//                     ),
//                   ),
//                 ),
//               ),

//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: FilledButton(
//                           onPressed: login,
//                           child: Text('สมัครสมาชิก'),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(text, style: const TextStyle(fontSize: 15)),
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: TextButton(
//                           onPressed: login,
//                           child: Text('เข้าสู่ระบบ'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lotto_application/model/request/customer_register_post_req.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullnameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();

  Future<void> registerUser() async {
    final user = CustomerRegisterPostRequest(
      fullname: fullnameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      image: "", // อาจจะเป็น path หรือ base64 ถ้ามีรูป
      password: passCtl.text,
    );

    var url = Uri.parse("http://192.168.46.66:3000/register"); // API Node.js
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: customerRegisterPostRequestToJson(user),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["success"]) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("สมัครสมาชิกสำเร็จ ✅")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ผิดพลาด: ${data["message"]}")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เชื่อมต่อเซิร์ฟเวอร์ไม่สำเร็จ ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ลงทะเบียนสมาชิกใหม่")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullnameCtl,
              decoration: const InputDecoration(hintText: "ชื่อ-สกุล"),
            ),
            TextField(
              controller: phoneCtl,
              decoration: const InputDecoration(hintText: "เบอร์โทร"),
            ),
            TextField(
              controller: emailCtl,
              decoration: const InputDecoration(hintText: "อีเมล"),
            ),
            TextField(
              controller: passCtl,
              obscureText: true,
              decoration: const InputDecoration(hintText: "รหัสผ่าน"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text("สมัครสมาชิก"),
            ),
          ],
        ),
      ),
    );
  }
}
