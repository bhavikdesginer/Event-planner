import 'package:flutter/material.dart';
import '../trainers/trainer_model.dart';
import 'slot_booking_page.dart';
import '../widgets/heart_button_widget.dart';

class TrainerDetailPage extends StatelessWidget {
  final TrainerModel trainer;

  const TrainerDetailPage({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [

          /// ── APP BAR WITH COVER IMAGE ──────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
             actions: [
               // ✅ Heart button AppBar ch
               Padding(
                 padding: const EdgeInsets.only(right: 12),
                 child: Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.9),
                     shape: BoxShape.circle,
                   ),
                   child: HeartButton(
                     trainerId: trainer.id,
                     size: 22,
                   ),
                  ),
                ),
              ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    trainer.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.orange.shade200,
                      child: const Icon(Icons.person,
                          size: 80, color: Colors.white),
                    ),
                  ),
                  // Gradient overlay for readability
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ── NAME + PRICE ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                trainer.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.orange.shade200),
                              ),
                              child: Text(
                                "${trainer.price} / Session",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              trainer.location,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: trainer.badges.map((badge) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.orange.shade200),
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        // Bio
                        Text(
                          trainer.bio,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ── STATS ROW ──────────────────────────────────
                  Row(
                    children: [
                      _StatBox(
                        value: "${trainer.totalSessions}+",
                        label: "Sessions",
                      ),
                      const SizedBox(width: 12),
                      _StatBox(
                        value: "${trainer.rating}",
                        label: "Rating",
                        icon: Icons.star,
                      ),
                      const SizedBox(width: 12),
                      _StatBox(
                        value: "${trainer.experience} yrs",
                        label: "Experience",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ── REVIEWS ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${trainer.totalReviews} total",
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ...trainer.reviews.map(
                    (review) => _ReviewCard(review: review),
                  ),

                  const SizedBox(height: 90), // space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      /// ── BOOK A SLOT BUTTON ─────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SlotBookingPage(trainer: trainer),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Book a Slot",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// ── STAT BOX WIDGET ──────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const _StatBox({
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                ],
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── REVIEW CARD WIDGET ───────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final TrainerReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              // Avatar initials
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange.shade100,
                child: Text(
                  review.reviewerName
                      .split(" ")
                      .map((w) => w[0])
                      .take(2)
                      .join(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.stars ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 16,
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            review.text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}