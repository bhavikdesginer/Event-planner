import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_model.dart';

class BookingService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Current logged-in user's uid
  static String? get _uid => _auth.currentUser?.uid;

  /// Save booking to Firestore
  /// Path: users/{uid}/bookings/{bookingId}
  static Future<void> saveBooking(BookingModel booking) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('bookings')
        .doc(booking.bookingId)
        .set(booking.toMap());
  }

  /// Fetch all bookings for current user (newest first)
static Future<List<BookingModel>> fetchBookings() async {
  try {
    if (_uid == null) {
      print("DEBUG: uid is null — user not logged in");
      return [];
    }

    print("DEBUG: fetching for uid = $_uid");

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('bookings')
        .orderBy('bookedAt', descending: true)
        .get();

    print("DEBUG: docs found = ${snapshot.docs.length}");

    return snapshot.docs
        .map((doc) => BookingModel.fromFirestore(doc))
        .toList();

  } catch (e) {
    print("DEBUG ERROR: $e");
    rethrow;
  }
}


  /// Stream — real-time updates
  static Stream<List<BookingModel>> bookingsStream() {
    if (_uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('bookings')
        .orderBy('bookedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => BookingModel.fromFirestore(doc)).toList());
  }
}