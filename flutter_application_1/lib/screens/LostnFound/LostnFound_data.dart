class LostAndFoundData {
  static List<Map<String, dynamic>> lostPets = [
    {
      "id": "lost_001",
      "name": "Milo",
      "description":
          "Brown puppy with a red collar. Very friendly but scared of loud noises. Last seen near playground.",
      "location": "Kuala Lumpur",
      "reward": "RM500",
      "status": "Lost",
      "animalType": "Dog",
      "ownerId": "user_001",
      "ownerName": "Ahmad Razif",
      "ownerPhone": "0123456789",
      "postedDate": DateTime(2024, 2, 1),
    },
    {
      "id": "lost_002",
      "name": "Kitty",
      "description":
          "White cat with blue eyes. Wearing a pink bell collar. Very gentle and indoor cat.",
      "location": "Petaling Jaya",
      "reward": "RM300",
      "status": "Lost",
      "animalType": "Cat",
      "ownerId": "user_002",
      "ownerName": "Siti Aisyah",
      "ownerPhone": "0178889999",
      "postedDate": DateTime(2024, 2, 3),
    },
    {
      "id": "lost_003",
      "name": "Coco",
      "description":
          "Small brown poodle. Has curly fur and responds to her name quickly. Missing since Sunday evening.",
      "location": "Shah Alam",
      "reward": "RM800",
      "status": "Lost",
      "animalType": "Dog",
      "ownerId": "user_003",
      "ownerName": "Daniel Lim",
      "ownerPhone": "0191234567",
      "postedDate": DateTime(2024, 2, 5),
    },
    {
      "id": "lost_004",
      "name": "Snowy",
      "description":
          "Pure white rabbit with small grey spots on ears. Escaped from backyard.",
      "location": "Subang Jaya",
      "reward": "RM200",
      "status": "Lost",
      "animalType": "Rabbit",
      "ownerId": "user_004",
      "ownerName": "Wei Ling",
      "ownerPhone": "0112345678",
      "postedDate": DateTime(2024, 2, 7),
    },
    {
      "id": "lost_005",
      "name": "Kiwi",
      "description":
          "Bright green parakeet. Can whistle short tunes. Flew away when cage door was left open.",
      "location": "Ampang",
      "reward": "RM400",
      "status": "Lost",
      "animalType": "Bird",
      "ownerId": "user_005",
      "ownerName": "Priya Nair",
      "ownerPhone": "0134567890",
      "postedDate": DateTime(2024, 2, 10),
    },
    {
      "id": "lost_006",
      "name": "Rocky",
      "description":
          "Large Labrador mix. Black fur with white chest patch. Very active and friendly.",
      "location": "Bangsar",
      "reward": "RM1000",
      "status": "Lost",
      "animalType": "Dog",
      "ownerId": "user_006",
      "ownerName": "Raj Kumar",
      "ownerPhone": "0187654321",
      "postedDate": DateTime(2024, 2, 12),
    },
    {
      "id": "lost_007",
      "name": "Luna",
      "description":
          "Grey kitten with striped tail. Only 5 months old. Very shy and may hide under cars.",
      "location": "Cheras",
      "reward": "RM350",
      "status": "Lost",
      "animalType": "Cat",
      "ownerId": "user_007",
      "ownerName": "Hafizah Zain",
      "ownerPhone": "0145678901",
      "postedDate": DateTime(2024, 2, 15),
    },
  ];

  static String currentUserId = "current_user";
  static String currentUserName = "You";

  static void addLostPet(Map<String, dynamic> pet) {
    lostPets.insert(0, pet);   // newest on top
  }

  static void removeLostPet(String id) {
    lostPets.removeWhere((p) => p["id"] == id);
  }

  static void markAsFound(String id) {
    final pet = lostPets.firstWhere((p) => p["id"] == id);
    pet["status"] = "Found";
  }
}