import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';
import '../LostnFound/LostnFound_upload.dart';
import '../LostnFound/LostnFound_detail.dart';
import '../LostnFound/LostnFound_mypost.dart';
import '../../widgets/LostnFound/LostPetCard.dart';
import '../../widgets/app_drawer.dart';

class LostHomePage extends StatefulWidget {
  const LostHomePage({super.key});

  @override
  State<LostHomePage> createState() => _LostHomePageState();
}


class _LostHomePageState extends State<LostHomePage> {
  String selectedLocation = "All";

  final List<String> locations = [
    "All",
    "Kuala Lumpur",
    "Petaling Jaya",
    "Shah Alam",
    "Subang Jaya",
    "Ampang",
    "Bangsar",
    "Cheras",
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredPets = selectedLocation == "All"
        ? LostAndFoundData.lostPets
        : LostAndFoundData.lostPets.where((p) => p["location"] == selectedLocation).toList();

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text(
          '📦 Lost & Found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: locations.map((loc) {
                  final bool isSelected = selectedLocation == loc;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(loc),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF6B6B),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      onSelected: (selected) => setState(() => selectedLocation = loc),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: filteredPets.isEmpty
                ? const Center(child: Text("No lost pets in this area 🥲", style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
                      return LostPetCard(
                        pet: pet,
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => LostDetailPage(pet: pet)));
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "my_posts",
            mini: true,
            backgroundColor: const Color(0xFFFF6B6B),
            child: const Icon(Icons.list_alt),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LostMyPostsPage())),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "add_post",
            backgroundColor: const Color(0xFFFF6B6B),
            child: const Icon(Icons.add, size: 30),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const LostAddPage()));
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}