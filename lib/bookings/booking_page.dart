import 'package:flutter/material.dart';
import '../bookings/booking_model.dart';
import '../bookings/booking_service.dart';
import '../trainers/trainer_model.dart';
import '../trainers/trainer_detail_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with AutomaticKeepAliveClientMixin {
  late Future<List<BookingModel>> _bookingsFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    _bookingsFuture = BookingService.fetchBookings();
  }

  void _refresh() {
    setState(() => _loadBookings());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Bookings",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh, color: Colors.orange),
                  tooltip: "Refresh",
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your upcoming & past sessions",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 16),

          // ── Bookings List ─────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<BookingModel>>(
              future: _bookingsFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text("Something went wrong", style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        TextButton(onPressed: _refresh, child: const Text("Retry", style: TextStyle(color: Colors.orange))),
                      ],
                    ),
                  );
                }

                final bookings = snapshot.data ?? [];

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text("No bookings yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text("Book a trainer to see your sessions here", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: Colors.orange,
                  onRefresh: () async => _refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return _BookingCard(booking: bookings[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Booking Card ──────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  TrainerModel? get _matchedTrainer {
    try {
      return dummyTrainers.firstWhere((t) => t.id == booking.trainerId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainer = _matchedTrainer;

    return GestureDetector(
      onTap: trainer == null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TrainerDetailPage(trainer: trainer)),
              ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [

            // ── Orange header ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      booking.trainerImageUrl,
                      width: 52, height: 52, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 52, height: 52,
                        color: Colors.orange.shade200,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.trainerName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 3),
                        Text("${booking.trainerCategory} Session", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                    child: const Text("Confirmed", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

            // ── Card body ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.calendar_today, text: booking.selectedDate),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.access_time, text: "${booking.selectedSlot}  •  60 min"),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.location_on, text: booking.trainerLocation),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.payment, text: booking.paymentMethod),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ID: ${booking.bookingId}", style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                        child: Text("${booking.trainerPrice} / Session", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                  if (trainer != null) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("View trainer profile", style: TextStyle(fontSize: 13, color: Colors.orange.shade600, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.orange.shade600),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87))),
      ],
    );
  }
}