import 'package:flutter/material.dart';

class LostPetCard extends StatelessWidget {
  final Map<String, dynamic> pet;
  final VoidCallback onTap;

  const LostPetCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLost = pet["status"] == "Lost";
    final Color statusColor = isLost ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[100],
                child: pet["image"] != null
                    ? Image.asset(pet["image"], fit: BoxFit.cover)
                    : const Icon(Icons.pets, size: 80, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          pet["status"].toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet["description"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(pet["location"], style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      const Icon(Icons.monetization_on, size: 18, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        pet["reward"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}