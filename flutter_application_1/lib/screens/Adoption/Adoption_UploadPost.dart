import 'package:flutter/material.dart';
import 'Adoption_Data.dart';

class AdoptionUploadPost extends StatefulWidget {
  const AdoptionUploadPost({super.key});

  @override
  State<AdoptionUploadPost> createState() => _AdoptionUploadPostState();
}

class _AdoptionUploadPostState extends State<AdoptionUploadPost> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  String selectedSex = "Male";
  String selectedType = "Dog";
  bool isVaccinated = false;
  bool _isSubmitting = false;

  final List<String> animalTypes = ["Dog", "Cat", "Bird", "Rabbit", "Other"];
  final List<String> sexOptions = ["Male", "Female"];
  final List<String> tagOptions = [
    "Playful", "Quiet", "Indoor", "Outdoor", "Friendly",
    "Trained", "Snuggly", "Active", "Gentle",
  ];
  List<String> selectedTags = [];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      await Future.delayed(const Duration(seconds: 2));

      // Build new animal map
      final newAnimal = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": _nameController.text.trim(),
        "description": _descController.text.trim(),
        "status": "Homeless",
        "age": _ageController.text.trim(),
        "sex": selectedSex,
        "breed": _breedController.text.trim(),
        "weight": "${_weightController.text.trim()} kg",
        "vaccinated": isVaccinated,
        "location": _locationController.text.trim(),
        "distance": (1.0 + (DateTime.now().millisecond % 50) / 10),
        "tags": selectedTags,
        "image": selectedType == "Cat"
            ? "assets/images/Image2.jpg"
            : "assets/images/Image1.jpg",
        "ownerName": "You",
        "ownerPhone": _phoneController.text.trim(),
        "ownerEmail": "",
        "ownerId": AdoptionData.currentUserId,
        "favourites": 0,
        "animalType": selectedType,
        "postedDate": DateTime.now().toIso8601String().substring(0, 10),
        "isMyPost": true,
      };

      AdoptionData.addAnimalPost(newAnimal);
      AdoptionData.addNotification(
        "Post Published 🎉",
        "${_nameController.text} has been listed for adoption!",
      );

      setState(() => _isSubmitting = false);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                const Text('Post Published!',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  '${_nameController.text} is now listed for adoption.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text(
          '📝 List for Adoption',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isSubmitting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFFFF6B6B),
                    strokeWidth: 5,
                  ),
                  const SizedBox(height: 24),
                  const Text('Publishing your post...',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Upload Area
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFFFF6B6B).withOpacity(0.4),
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 50, color: const Color(0xFFFF6B6B).withOpacity(0.6)),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to Upload Photos',
                              style: TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Upload clear photos of your pet',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _sectionCard([
                      _label('Animal Name *'),
                      _field(_nameController, 'e.g., Max, Luna, Buddy'),

                      const SizedBox(height: 16),
                      _label('Animal Type *'),
                      Wrap(
                        spacing: 8,
                        children: animalTypes.map((type) {
                          final isSelected = selectedType == type;
                          return GestureDetector(
                            onTap: () => setState(() => selectedType = type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF6B6B)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFF6B6B)
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),

                    const SizedBox(height: 14),

                    _sectionCard([
                      _label('Breed *'),
                      _field(_breedController, 'e.g., Golden Mix, Domestic Shorthair'),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Age *'),
                                _field(_ageController, 'e.g., 3 months'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Weight (kg) *'),
                                _field(_weightController, 'e.g., 2.5',
                                    isNumber: true),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _label('Sex *'),
                      Row(
                        children: sexOptions.map((sex) {
                          final isSelected = selectedSex == sex;
                          return GestureDetector(
                            onTap: () => setState(() => selectedSex = sex),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (sex == "Male"
                                        ? const Color(0xFFB3D9FF)
                                        : const Color(0xFFFFB3D9))
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? (sex == "Male"
                                          ? const Color(0xFF1A73E8)
                                          : const Color(0xFFE91E8C))
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(sex == "Male" ? "♂" : "♀",
                                      style: TextStyle(
                                          color: sex == "Male"
                                              ? const Color(0xFF1A73E8)
                                              : const Color(0xFFE91E8C))),
                                  const SizedBox(width: 6),
                                  Text(sex,
                                      style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: sex == "Male"
                                              ? const Color(0xFF1A73E8)
                                              : const Color(0xFFE91E8C))),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label('Vaccinated?'),
                          Switch(
                            value: isVaccinated,
                            onChanged: (v) => setState(() => isVaccinated = v),
                            activeColor: const Color(0xFFFF6B6B),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 14),

                    _sectionCard([
                      _label('Description *'),
                      TextFormField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Describe your pet\'s personality, habits, what they need...',
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Please add a description'
                            : null,
                      ),
                    ]),

                    const SizedBox(height: 14),

                    _sectionCard([
                      _label('Personality Tags'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tagOptions.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedTags.remove(tag);
                                } else {
                                  selectedTags.add(tag);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF6B6B).withOpacity(0.15)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFF6B6B)
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFFF6B6B)
                                      : Colors.grey[700],
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),

                    const SizedBox(height: 14),

                    _sectionCard([
                      _label('Location *'),
                      _field(_locationController, 'e.g., Petaling Jaya, Kuala Lumpur'),

                      const SizedBox(height: 16),
                      _label('Your Phone Number *'),
                      _field(_phoneController, 'e.g., 0123456789',
                          isNumber: true),
                    ]),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Publish Adoption Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'This field is required' : null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}