import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Save user to Firestore
  Future<void> saveUser(UserModel user) async {
    await _db.collection(_collection).doc(user.uid).set(user.toMap());
  }

  // Update specific fields
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db
        .collection(_collection)
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(_collection).doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Check if onboarding is complete
  Future<bool> isOnboardingDone(String uid) async {
    final doc = await _db.collection(_collection).doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    return data['gender'] != null &&
        data['age'] != null &&
        data['interests'] != null;
  }
}