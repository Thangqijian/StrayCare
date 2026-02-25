import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';

class LostMyPostsPage extends StatefulWidget {
  const LostMyPostsPage({super.key});

  @override
  State<LostMyPostsPage> createState() => _LostMyPostsPageState();
}

// ... imports

class _LostMyPostsPageState extends State<LostMyPostsPage> {
  List<Map<String, dynamic>> get myPosts => LostAndFoundData.lostPets
      .where((p) => p["ownerId"] == LostAndFoundData.currentUserId)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFFF6B6B), title: const Text(
          '📋 My Lost Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),),
      body: myPosts.isEmpty
          ? const Center(child: Text("You haven't posted any lost pets yet", style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final pet = myPosts[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(pet["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("${pet["location"]} • ${pet["reward"]}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: const Color(0xFFFF6B6B)),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text("Delete Post?"),
                            content: const Text("This action cannot be undone."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          setState(() => LostAndFoundData.removeLostPet(pet["id"]));
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}