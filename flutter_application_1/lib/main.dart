import 'package:flutter/material.dart';
import 'screens/donation_screen.dart';
import 'screens/Adoption/Adoption_HomePage.dart';
import 'screens/chat_list_screen.dart';
import 'screens/LostnFound/LostnFound_page.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(const PawGuardApp());
}

class PawGuardApp extends StatelessWidget {
  const PawGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrayCare',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B6B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B6B),
          primary: const Color(0xFFFF6B6B),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SimpleHomeContent(),
    DonationScreen(),
    const AdoptionScreen(),
    const LostHomePage(),
    const ChatListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF6B6B),
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Text('🚨', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🚨', style: TextStyle(fontSize: 24)),
              label: 'Emergency',
            ),
            BottomNavigationBarItem(
              icon: Text('💰', style: TextStyle(fontSize: 22)),
              activeIcon: Text('💰', style: TextStyle(fontSize: 24)),
              label: 'Donation',
            ),
            BottomNavigationBarItem(
              icon: Text('🏠', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🏠', style: TextStyle(fontSize: 24)),
              label: 'Adoption',
            ),
            BottomNavigationBarItem(
              icon: Text('🔍', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🔍', style: TextStyle(fontSize: 24)),
              label: 'Lost/Found',
            ),
            BottomNavigationBarItem(
              icon: Text('💬', style: TextStyle(fontSize: 22)),
              activeIcon: Text('💬', style: TextStyle(fontSize: 24)),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleHomeContent extends StatelessWidget {
  const SimpleHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Row(
          children: [
            Text('🐾 ', style: TextStyle(fontSize: 24)),
            Text('StrayCare',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
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
      endDrawer: const AppDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🚨', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              'Emergency Feature',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text('(Coming Soon)',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚧', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              '$title Feature',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text('(Coming Soon)',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}