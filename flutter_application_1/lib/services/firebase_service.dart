import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Save any animal post (Emergency, Donation, or Adoption)
  // This makes you the hero of the team because everyone can use this one function!
  Future<String> savePost(Map<String, dynamic> caseData) async {
    try {
      final docRef = await _firestore.collection('posts').add({
        ...caseData,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      
      print('Post saved successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error saving post: $e');
      rethrow;
    }
  }
  
  // Get ONLY Emergency cases for your specific page
  Stream<List<Map<String, dynamic>>> getEmergencyCases() {
    return _firestore
        .collection('posts')
        .where('type', isEqualTo: 'Emergency') // Filters out non-emergencies
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        
        String timeAgo = 'Just now';
        if (data['timestamp'] != null) {
          final timestamp = (data['timestamp'] as Timestamp).toDate();
          timeAgo = _getTimeAgo(timestamp);
        }
        
        return {
          'id': doc.id,
          ...data,
          'timeAgo': timeAgo,
        };
      }).toList();
    });
  }
  
  // Get cases sorted by urgency (Critical → Urgent → Moderate)
  // Useful for the "High Priority" section on the Home Page
  Stream<List<Map<String, dynamic>>> getCasesByUrgency() {
    return _firestore
        .collection('posts')
        .where('type', isEqualTo: 'Emergency')
        .orderBy('urgencyPriority') // Requires a field like 0, 1, 2
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        
        String timeAgo = 'Just now';
        if (data['timestamp'] != null) {
          final timestamp = (data['timestamp'] as Timestamp).toDate();
          timeAgo = _getTimeAgo(timestamp);
        }
        
        return {
          'id': doc.id,
          ...data,
          'timeAgo': timeAgo,
        };
      }).toList();
    });
  }
  
  // Update post status (e.g., when an animal is "Rescued" or "Adopted")
  Future<void> updatePostStatus(String postId, String status) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating status: $e');
      rethrow;
    }
  }
  
  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
      rethrow;
    }
  }
  
  // Helper: Calculate time ago for the UI
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
  
  // Helper: Convert AI rank text to a number for sorting
  int getUrgencyPriority(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return 0;
      case 'urgent':
        return 1;
      case 'moderate':
        return 2;
      default:
        return 3;
    }
  }
}