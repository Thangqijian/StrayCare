import 'package:flutter/material.dart';
import 'Adoption_Data.dart';
import '../../widgets/Adoption/AdoptionCard.dart';
import 'Adoption_DetailPage.dart';
import 'Adoption_UploadPost.dart';
import 'Adoption_MyPosts.dart';
import '../../widgets/app_drawer.dart';
import 'Adoption_ApplicantList.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({super.key});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  String selectedFilter = "All";
  String selectedType = "All";
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, dynamic>> animalTypes = [
    {"type": "All", "emoji": "🐾"},
    {"type": "Dog", "emoji": "🐕"},
    {"type": "Cat", "emoji": "🐈"},
    {"type": "Bird", "emoji": "🦜"},
    {"type": "Rabbit", "emoji": "🐇"},
    {"type": "Other", "emoji": "🐾"},
  ];

  List<Map<String, dynamic>> get filteredAnimals {
    return AdoptionData.animals.where((animal) {
      final matchStatus = selectedFilter == "All" || animal["status"] == selectedFilter;
      final matchType = selectedType == "All" || animal["animalType"] == selectedType;
      final matchSearch = searchQuery.isEmpty ||
          animal["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          animal["breed"].toLowerCase().contains(searchQuery.toLowerCase());
      return matchStatus && matchType && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: const Text(
          '🐾 Adoption Center',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              icon: const Icon(Icons.people, size: 16),
              label: const Text('Applicants', style: TextStyle(fontSize: 12)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ApplicantListPage()));
              },
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppDrawer(),
      body: Column(
        children: [
          // Search + Filter Header
          Container(
            color: const Color(0xFFFF6B6B),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search by breed, size, or name',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => searchQuery = "");
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animal Type Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: animalTypes.map((type) {
                  final isSelected = selectedType == type["type"];
                  return GestureDetector(
                    onTap: () => setState(() => selectedType = type["type"]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(type["emoji"], style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            type["type"],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Status Filter Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: ["All", "Homeless", "Pending", "Adopted"].map((status) {
                final isSelected = selectedFilter == status;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilter = status),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6B6B).withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 4),

          // Animal Cards List
          Expanded(
            child: filteredAnimals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🐾', style: TextStyle(fontSize: 60)),
                        const SizedBox(height: 12),
                        Text('No animals found',
                            style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filteredAnimals.length,
                    itemBuilder: (context, index) {
                      final animal = filteredAnimals[index];
                      return AdoptionCard(
                        animal: animal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdoptionDetailPage(animal: animal),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        onFavourite: () {
                          setState(() {
                            AdoptionData.toggleFavourite(animal["id"]);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // FAB for uploading new post
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // My Posts button
          FloatingActionButton.small(
            heroTag: "myPosts",
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFF6B6B),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdoptionMyPostsPage()),
              ).then((_) => setState(() {}));
            },
            child: const Icon(Icons.list_alt),
          ),
          const SizedBox(height: 10),
          // Upload new post
          FloatingActionButton(
            heroTag: "upload",
            backgroundColor: const Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdoptionUploadPost()),
              ).then((_) => setState(() {}));
            },
            child: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
    );
  }
}