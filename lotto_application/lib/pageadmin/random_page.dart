import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  List<String> winners = [];
  bool isLoading = false;

  Future<void> drawNumbers() async {
    setState(() => isLoading = true);
    try {
      final res = await http.post(
        Uri.parse("http://192.168.0.103:3000/api/lotto/draw"),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(res.body);
      if (data["success"] == true) {
        setState(() {
          winners = List<String>.from(data["winners"]);
        });
      } else {
        debugPrint("API error: ${data["message"]}");
      }
    } catch (e) {
      debugPrint("Request error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: drawNumbers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
              ),
              child: const Text(
                "สุ่มออกรางวัลใหม่",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading && winners.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: winners.length,
                  itemBuilder: (context, i) => Card(
                    color: Colors.teal[100],
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        "รางวัลที่ ${i + 1} : ${winners[i]}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
