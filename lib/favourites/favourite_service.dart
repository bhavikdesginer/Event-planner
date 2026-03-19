import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  // ── Add to favourites ────────────────────────────────────────
  static Future<void> addFavourite(String trainerId) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favourites')
        .doc(trainerId)
        .set({'trainerId': trainerId, 'savedAt': FieldValue.serverTimestamp()});
  }

  // ── Remove from favourites ───────────────────────────────────
  static Future<void> removeFavourite(String trainerId) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favourites')
        .doc(trainerId)
        .delete();
  }

  // ── Toggle favourite ─────────────────────────────────────────
  static Future<bool> toggleFavourite(String trainerId) async {
    final isFav = await isFavourite(trainerId);
    if (isFav) {
      await removeFavourite(trainerId);
      return false;
    } else {
      await addFavourite(trainerId);
      return true;
    }
  }

  // ── Check if favourite ───────────────────────────────────────
  static Future<bool> isFavourite(String trainerId) async {
    if (_uid == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favourites')
        .doc(trainerId)
        .get();
    return doc.exists;
  }

  // ── Fetch all favourite trainer IDs ─────────────────────────
  static Future<List<String>> fetchFavouriteIds() async {
    if (_uid == null) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favourites')
        .orderBy('savedAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // ── Real-time stream of favourite IDs ────────────────────────
  static Stream<List<String>> favouritesStream() {
    if (_uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('favourites')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.id).toList());
  }
}