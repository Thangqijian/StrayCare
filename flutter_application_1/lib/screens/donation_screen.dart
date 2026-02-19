import 'package:flutter/material.dart';
import '../widgets/individual_case_tab.dart';
import '../widgets/tnr_shelter_tab.dart';

class DonationScreen extends StatelessWidget {
  // FIXED: Removed 'const' from the constructor
  DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF6B6B),
          title: const Row(
            children: [
              Text('💰 ', style: TextStyle(fontSize: 24)),
              Text('Donations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Individual Cases'),
              Tab(text: 'TNR Programs'),
            ],
          ),
        ),
        // FIXED: Removed 'const' from TabBarView because its children are now dynamic
        body: TabBarView(
          children: [
            IndividualCaseTab(), // No 'const' here
            TNRShelterTab(),     // No 'const' here
          ],
        ),
      ),
    );
  }
}