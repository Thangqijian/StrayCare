import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';


class LostDetailPage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const LostDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final phone = pet["ownerPhone"] ?? pet["phone"] ?? "Not provided";

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFFF6B6B), title: Text(pet["name"])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Image
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.pets, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(pet["name"], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("📍 ${pet["location"]}", style: const TextStyle(fontSize: 16)),
            Text("💰 Reward: ${pet["reward"]}", style: const TextStyle(fontSize: 16)),
            Text("📞 Contact: $phone", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text(pet["description"], style: const TextStyle(fontSize: 16, height: 1.5)),

            const SizedBox(height: 40),
            if (pet["status"] == "Lost")
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
                    LostAndFoundData.markAsFound(pet["id"]);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🎉 Marked as Found!")));
                    Navigator.pop(context);
                  },
                  child: const Text("MARK AS FOUND", style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}