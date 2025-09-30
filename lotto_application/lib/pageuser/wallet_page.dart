import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lotto_application/page/login.dart';

class WalletPage extends StatefulWidget {
  final String userId;

  const WalletPage({super.key, required this.userId});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String fullname = "";
  String phone = "";
  int walletAmount = 0;
  String role = "";
  bool isLoading = true;
  String errorMessage = "";

  List<Map<String, dynamic>> winList = [
    {'number': '100010', 'price': 100, 'prize': 'รางวัลที่ 1 - 3500000 บาท'},
    {'number': '100011', 'price': 100, 'prize': 'รางวัลที่ 2 - 1000000 บาท'},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // ใช้ IP 10.0.2.2 สำหรับ Android Emulator
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.103:3000/api/lotto/customer/${widget.userId}",
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          setState(() {
            fullname = jsonData['data']['fullname'] ?? "";
            phone = jsonData['data']['phone'] ?? "";
            walletAmount = jsonData['data']['balance'] ?? 0;
            role = jsonData['data']['role'] ?? "";
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonData['message'] ?? "ไม่พบข้อมูลสมาชิก";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "เกิดข้อผิดพลาด: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "เกิดข้อผิดพลาดในการเชื่อมต่อ: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("บัญชีผู้ใช้"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("ออกจากระบบ"),
                  content: const Text("คุณต้องการออกจากระบบหรือไม่?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("ยกเลิก"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ออกจากระบบสำเร็จ ✅")),
                        );
                      },
                      child: const Text("ออกจากระบบ"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== ส่วนข้อมูลบัญชีเดิม ==========
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: const Color.fromARGB(255, 74, 74, 74),
              child: Text(
                "ยอดเงินในบัญชี: $walletAmount ฿",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: const Color.fromARGB(255, 2, 84, 177),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fullname,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "เบอร์ $phone",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: const Color.fromARGB(255, 2, 84, 177),
              child: Text(
                "Role: $role",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            ExpansionTile(
              title: const Text(
                "รายการที่ถูกรางวัล",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: winList.length,
                  itemBuilder: (context, index) {
                    final item = winList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.confirmation_number),
                        title: Text("เลข ${item['number']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ราคา: ${item['price']} บาท"),
                            Text(item['prize']),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "ขึ้นเงิน",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
