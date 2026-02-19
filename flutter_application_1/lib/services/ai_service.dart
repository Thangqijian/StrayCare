import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _apiKey = 'AIzaSyCojgSUxVNbT8NOnyw0is1rlIvZ0xoi1oA';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  /// Analyzes the photo + text, ranks urgency, checks for fraud, 
  /// and converts image to Base64 for free Firestore storage.
  Future<Map<String, dynamic>> analyzeEmergencyWithImage(Uint8List imageBytes, String description) async {
    try {
      final prompt = """
        You are a veterinary triage assistant. Analyze this animal rescue photo and description: "$description"
        
        1. Rank medical urgency: critical, urgent, or moderate.
        2. Fraud check: Does this look like a real, unique rescue photo or a stock image? 
        
        Return ONLY in this format: RANK | STATUS (e.g., critical | legitimate)
      """;

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final parts = response.text?.split('|') ?? ["moderate", "legitimate"];

      // Convert image to Base64 string so we don't need Cloud Storage 
      String base64Image = base64Encode(imageBytes);

      return {
        'urgency': parts[0].trim().toLowerCase(),
        'isLegitimate': parts[1].toLowerCase().contains('legitimate'),
        'imageBase64': base64Image,
      };
    } catch (e) {
      print('AI Vision Error: $e');
      return {
        'urgency': 'moderate',
        'isLegitimate': true,
        'imageBase64': base64Encode(imageBytes),
      };
    }
  }

  /// Generate safety tips based on the AI rank (Your original logic)
  Future<List<String>> generateSafetyTips(String urgency, String description) async {
    try {
      final prompt = '''
        Generate 3 practical safety tips for someone helping with this $urgency animal emergency:
        Situation: $description
        Provide exactly 3 short, actionable safety tips.
        Format:
        1. [Tip]
        2. [Tip]
        3. [Tip]
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final result = response.text ?? '';

      final tips = <String>[];
      final lines = result.split('\n');
      for (var line in lines) {
        if (line.trim().startsWith(RegExp(r'[0-9]\.'))) {
          tips.add(line.substring(2).trim());
        }
      }
      return tips.isNotEmpty ? tips.take(3).toList() : _fallbackSafetyTips(urgency);
    } catch (e) {
      return _fallbackSafetyTips(urgency);
    }
  }

  /// Suggest help types (Your original logic)
  Future<List<String>> suggestHelpTypes(String description) async {
    try {
      final prompt = 'Based on: "$description", suggest help types (Medical, Transport, Food, Foster). Return comma separated list.';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text?.split(',').map((e) => e.trim()).toList() ?? ['Medical'];
    } catch (e) {
      return ['Medical'];
    }
  }

  List<String> _fallbackSafetyTips(String urgency) {
    return [
      'Keep a safe distance until you assess the animal\'s temperament.',
      'Use a blanket or towel to handle the animal if necessary.',
      'Contact a local vet or shelter immediately for professional guidance.'
    ];
  }
}