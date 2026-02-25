import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';

class LostAddPage extends StatefulWidget {
  const LostAddPage({super.key});

  @override
  State<LostAddPage> createState() => _LostAddPageState();
}

class _LostAddPageState extends State<LostAddPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final rewardController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedAnimal = "Dog";

  final List<String> animalTypes = ["Dog", "Cat", "Rabbit", "Bird", "Other"];

  void submit() {
    if (_formKey.currentState!.validate()) {
      LostAndFoundData.addLostPet({
        "id": "lost_${DateTime.now().millisecondsSinceEpoch}",
        "name": nameController.text.trim(),
        "description": descController.text.trim(),
        "location": locationController.text.trim(),
        "reward": "RM${rewardController.text.trim()}",
        "status": "Lost",
        "animalType": selectedAnimal,
        "ownerId": LostAndFoundData.currentUserId,
        "ownerName": LostAndFoundData.currentUserName,
        "ownerPhone": phoneController.text.trim(),  // consistent key
        "postedDate": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Post created successfully!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
         title: const Text(
          'Report Lost Pet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Photo Placeholder ────────────────────────────────
              Center(
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Add Pet Photo",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "(Upload feature coming soon)",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Animal Type Chips ────────────────────────────────
              const Text(
                "Animal Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: animalTypes.map((type) {
                  final isSelected = selectedAnimal == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF6B6B),
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => selectedAnimal = type);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Form Fields ──────────────────────────────────────
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Pet Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) => v!.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Last Seen Location",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: rewardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Reward (RM)",
                  border: OutlineInputBorder(),
                  prefixText: "RM ",
                ),
                validator: (v) => v!.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Your Contact Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 32),

              // ── Submit Button ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: submit,
                  child: const Text(
                    "POST LOST PET",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    locationController.dispose();
    rewardController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}