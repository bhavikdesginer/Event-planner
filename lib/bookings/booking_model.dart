import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String trainerId;
  final String trainerName;
  final String trainerCategory;
  final String trainerLocation;
  final String trainerImageUrl;
  final String trainerPrice;
  final String selectedDate;
  final String selectedSlot;
  final String paymentMethod;
  final DateTime bookedAt;

  const BookingModel({
    required this.bookingId,
    required this.trainerId,
    required this.trainerName,
    required this.trainerCategory,
    required this.trainerLocation,
    required this.trainerImageUrl,
    required this.trainerPrice,
    required this.selectedDate,
    required this.selectedSlot,
    required this.paymentMethod,
    required this.bookedAt,
  });

  /// Firestore → BookingModel
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: data['bookingId'] ?? '',
      trainerId: data['trainerId'] ?? '',
      trainerName: data['trainerName'] ?? '',
      trainerCategory: data['trainerCategory'] ?? '',
      trainerLocation: data['trainerLocation'] ?? '',
      trainerImageUrl: data['trainerImageUrl'] ?? '',
      trainerPrice: data['trainerPrice'] ?? '',
      selectedDate: data['selectedDate'] ?? '',
      selectedSlot: data['selectedSlot'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      bookedAt: (data['bookedAt'] as Timestamp).toDate(),
    );
  }

  /// BookingModel → Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'trainerCategory': trainerCategory,
      'trainerLocation': trainerLocation,
      'trainerImageUrl': trainerImageUrl,
      'trainerPrice': trainerPrice,
      'selectedDate': selectedDate,
      'selectedSlot': selectedSlot,
      'paymentMethod': paymentMethod,
      'bookedAt': Timestamp.fromDate(bookedAt),
    };
  }
}