import 'package:cloud_firestore/cloud_firestore.dart';

class StrayAnimal {
  final String? id;
  final String description;
  final String type;           
  final String status;         
  // Change DateTime to Timestamp to make the import useful!
  final Timestamp timestamp; 
  final String? imageBase64; 
  final bool isVerified;       
  final double? goalAmount;    
  final String? contactInfo;   

  StrayAnimal({
    this.id,
    required this.description,
    required this.type,
    required this.status,
    required this.timestamp,
    this.imageBase64,
    this.isVerified = false,
    this.goalAmount,
    this.contactInfo,
  });

  // This factory helps you convert Firestore data BACK into a StrayAnimal object
  factory StrayAnimal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return StrayAnimal(
      id: doc.id,
      description: data['description'] ?? '',
      type: data['type'] ?? 'Emergency',
      status: data['status'] ?? 'Moderate',
      timestamp: data['timestamp'] ?? Timestamp.now(), // Uses the import
      imageBase64: data['imageBase64'],
      isVerified: data['isVerified'] ?? false,
      goalAmount: data['goalAmount']?.toDouble(),
      contactInfo: data['contactInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'type': type,
      'status': status,
      'timestamp': timestamp, // Firestore loves receiving Timestamps
      'imageBase64': imageBase64,
      'isVerified': isVerified,
      'goalAmount': goalAmount,
      'contactInfo': contactInfo,
    };
  }
}