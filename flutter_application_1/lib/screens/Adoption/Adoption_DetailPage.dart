import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Adoption_Data.dart';
import 'Adoption_ChatPage.dart';

class AdoptionDetailPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const AdoptionDetailPage({super.key, required this.animal});

  @override
  State<AdoptionDetailPage> createState() => _AdoptionDetailPageState();
}

class _AdoptionDetailPageState extends State<AdoptionDetailPage>
    with SingleTickerProviderStateMixin {
  double _slideValue = 0.0;
  bool _messageSent = false;
  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );

    // ✅ Check if user already contacted this owner before — keep button green
    final animal = widget.animal;
    if (AdoptionData.hasContacted(animal["id"], animal["ownerId"])) {
      _messageSent = true;
      _successController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _onSlideComplete() {
    final animal = widget.animal;
    final chatId = AdoptionData.getChatId(animal["id"], animal["ownerId"]);

    AdoptionData.startOrOpenChat(
      animalId: animal["id"],
      animalName: animal["name"],
      ownerId: animal["ownerId"],
      ownerName: animal["ownerName"],
      ownerPhone: animal["ownerPhone"],
      initialMessage:
          "Hi! I'm interested in adopting ${animal["name"]} 🐾 Could you tell me more about them?",
    );

    setState(() {
      _messageSent = true;
      _slideValue = 1.0;
    });
    _successController.forward();
    HapticFeedback.mediumImpact();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _openChatPage(chatId);
    });
  }

  void _openChatPage(String chatId) {
    final animal = widget.animal;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdoptionChatPage(
          chatId: chatId,
          animalName: animal["name"],
          ownerName: animal["ownerName"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animal = widget.animal;
    final bool isFav = animal["isFavourited"] ?? false;
    final bool isAvailable = animal["status"] == "Homeless";

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B6B),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    AdoptionData.toggleFavourite(animal["id"]);
                    animal["isFavourited"] = !(animal["isFavourited"] ?? false);
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? const Color(0xFFFF6B6B) : Colors.grey[400],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    animal["image"],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.orange[100],
                      child: Center(
                        child: Text(
                          animal["animalType"] == "Cat"
                              ? "🐈"
                              : animal["animalType"] == "Bird"
                                  ? "🦜"
                                  : animal["animalType"] == "Rabbit"
                                      ? "🐇"
                                      : "🐕",
                          style: const TextStyle(fontSize: 100),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pet Name:  ${animal["name"]}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${animal["distance"]} km nearby · ${animal["location"]}',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: animal["status"] == "Homeless"
                                ? Colors.green[100]
                                : animal["status"] == "Pending"
                                    ? Colors.orange[100]
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            animal["status"],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: animal["status"] == "Homeless"
                                  ? Colors.green[800]
                                  : animal["status"] == "Pending"
                                      ? Colors.orange[800]
                                      : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Info Tag Grid
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.4,
                      children: [
                        _buildInfoTag(
                          animal["sex"] == "Male" ? "♂ Male" : "♀ Female",
                          "Sex",
                          animal["sex"] == "Male"
                              ? const Color(0xFFB3D9FF)
                              : const Color(0xFFFFB3D9),
                          animal["sex"] == "Male"
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFFE91E8C),
                        ),
                        _buildInfoTag(
                          animal["age"],
                          "Age",
                          const Color(0xFFFFF0B3),
                          const Color(0xFFF57F17),
                        ),
                        _buildInfoTag(
                          animal["breed"],
                          "Breed",
                          const Color(0xFFE8F5E9),
                          const Color(0xFF2E7D32),
                        ),
                        _buildInfoTag(
                          animal["weight"],
                          "Weight",
                          const Color(0xFFF3E5F5),
                          const Color(0xFF6A1B9A),
                        ),
                        _buildInfoTag(
                          animal["vaccinated"] ? "✓ Yes" : "✗ No",
                          "Vaccinated",
                          animal["vaccinated"]
                              ? const Color(0xFFB3F0C8)
                              : const Color(0xFFFFCDD2),
                          animal["vaccinated"]
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                        _buildInfoTag(
                          '${animal["favourites"] ?? 0} ♥',
                          "Favourites",
                          const Color(0xFFFFE0E6),
                          const Color(0xFFFF6B6B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // About
                    Text(
                      'About ${animal["name"]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      animal["description"],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),

                    // Tags
                    if (animal["tags"] != null) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (animal["tags"] as List).map<Widget>((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFFF6B6B)
                                      .withOpacity(0.3)),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Owner Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                const Color(0xFFFF6B6B).withOpacity(0.2),
                            child: Text(
                              animal["ownerName"]
                                  .toString()[0]
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  animal["ownerName"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Animal Owner',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          // Call button
                          GestureDetector(
                            onTap: () =>
                                _showPhoneNumber(animal["ownerPhone"]),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green[200]!),
                              ),
                              child: Icon(Icons.call,
                                  color: Colors.green[700], size: 20),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Chat button
                          GestureDetector(
                            onTap: () => _openDirectChat(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B6B)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFFF6B6B)
                                        .withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.chat_bubble_outline,
                                  color: Color(0xFFFF6B6B), size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Slide to contact / Already contacted / Not available
                    if (isAvailable) ...[
                      if (_messageSent)
                        // ✅ Green button stays permanently after slide
                        GestureDetector(
                          onTap: () {
                            final chatId = AdoptionData.getChatId(
                                animal["id"], animal["ownerId"]);
                            _openChatPage(chatId);
                          },
                          child: ScaleTransition(
                            scale: _successAnimation,
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Message Sent · Tap to Open Chat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        _buildSlideToContact(),
                    ] else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            animal["status"] == "Adopted"
                                ? '🎉 Already Adopted'
                                : '⏳ Pending Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideToContact() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        const thumbWidth = 56.0;
        final maxSlide = trackWidth - thumbWidth - 8;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.12),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3)),
          ),
          child: Stack(
            children: [
              // Background fill that grows as user slides
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: (_slideValue * maxSlide) + thumbWidth + 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              // Center text
              Center(
                child: Opacity(
                  opacity: 1.0 - (_slideValue * 1.5).clamp(0.0, 1.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 60),
                      Text(
                        'Slide to Contact Owner  →',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Draggable thumb
              Positioned(
                left: 4 + (_slideValue * maxSlide),
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _slideValue =
                          (_slideValue + details.delta.dx / maxSlide)
                              .clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (_slideValue > 0.75) {
                      _onSlideComplete();
                    } else {
                      setState(() => _slideValue = 0.0);
                    }
                  },
                  child: Container(
                    width: thumbWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.pets, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTag(
      String value, String label, Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhoneNumber(String phone) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.call, color: Colors.green, size: 40),
            const SizedBox(height: 12),
            const Text('Contact Owner',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Tap the number below to call',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling $phone...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _openDirectChat() {
    final animal = widget.animal;
    final chatId = AdoptionData.getChatId(animal["id"], animal["ownerId"]);

    AdoptionData.startOrOpenChat(
      animalId: animal["id"],
      animalName: animal["name"],
      ownerId: animal["ownerId"],
      ownerName: animal["ownerName"],
      ownerPhone: animal["ownerPhone"],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdoptionChatPage(
          chatId: chatId,
          animalName: animal["name"],
          ownerName: animal["ownerName"],
        ),
      ),
    );
  }
}