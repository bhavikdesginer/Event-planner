import 'package:flutter/material.dart';
import '../trainers/trainer_model.dart';
import 'payment_page.dart';

class SlotBookingPage extends StatefulWidget {
  final TrainerModel trainer;

  const SlotBookingPage({super.key, required this.trainer});

  @override
  State<SlotBookingPage> createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  int selectedDateIndex = 0;
  int? selectedSlotIndex;

  /// Next 7 days from today
  final List<DateTime> dates = List.generate(
    7,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  final List<String> timeSlots = [
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
  ];

  /// Some slots marked unavailable (just for demo)
  final List<int> unavailableSlots = [1, 4, 7];

  String get selectedDateFormatted {
    final d = dates[selectedDateIndex];
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return "${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}";
  }

  String get selectedSlotTime =>
      selectedSlotIndex != null ? timeSlots[selectedSlotIndex!] : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Select a Slot"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ── TRAINER MINI CARD ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.trainer.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.orange.shade100,
                        child: const Icon(Icons.person, color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trainer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.trainer.category,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${widget.trainer.price} / Session",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ── DATE PICKER ────────────────────────────────────
            const Text(
              "Choose Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final isSelected = selectedDateIndex == index;
                  final dayNames = [
                    "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
                  ];
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedDateIndex = index;
                      selectedSlotIndex = null; // reset slot on date change
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      width: 54,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayNames[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected ? Colors.white70 : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            /// ── TIME SLOTS ─────────────────────────────────────
            const Text(
              "Available Slots",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            // Legend
            Row(
              children: [
                _LegendDot(color: Colors.white, border: Colors.grey.shade300),
                const SizedBox(width: 5),
                const Text("Available", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 14),
                _LegendDot(color: Colors.orange),
                const SizedBox(width: 5),
                const Text("Selected", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 14),
                _LegendDot(color: Colors.grey.shade200),
                const SizedBox(width: 5),
                const Text("Unavailable", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 14),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final isUnavailable = unavailableSlots.contains(index);
                final isSelected = selectedSlotIndex == index;

                return GestureDetector(
                  onTap: isUnavailable
                      ? null
                      : () => setState(() => selectedSlotIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isUnavailable
                          ? Colors.grey.shade200
                          : isSelected
                              ? Colors.orange
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        timeSlots[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isUnavailable
                              ? Colors.grey.shade400
                              : isSelected
                                  ? Colors.white
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ── SELECTED SUMMARY ───────────────────────────────
            if (selectedSlotIndex != null)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: selectedSlotIndex != null ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "$selectedDateFormatted  ·  $selectedSlotTime",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// ── PROCEED TO PAYMENT BUTTON ──────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed: selectedSlotIndex == null
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        trainer: widget.trainer,
                        selectedDate: selectedDateFormatted,
                        selectedSlot: selectedSlotTime,
                      ),
                    ),
                  ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            disabledBackgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Proceed to Payment →",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// ── LEGEND DOT ───────────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final Color? border;

  const _LegendDot({required this.color, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: border ?? color),
      ),
    );
  }
}


//import 'package:flutter/material.dart';
// import '../bookings/payment_page.dart';

// class SlotSelectionPage extends StatefulWidget {
//   const SlotSelectionPage({super.key});

//   @override
//   State<SlotSelectionPage> createState() => _SlotSelectionPageState();
// }

// class _SlotSelectionPageState extends State<SlotSelectionPage> {

//   int selectedIndex = -1;

//   final List<String> slots = [
//     "09:00 AM",
//     "10:00 AM",
//     "11:00 AM",
//     "12:00 PM",
//     "02:00 PM",
//     "03:00 PM",
//     "04:00 PM",
//     "05:00 PM",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Time Slot"),
//         backgroundColor: Colors.orange,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             const Text(
//               "Available Slots",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// SLOT GRID
//             Expanded(
//               child: GridView.builder(
//                 itemCount: slots.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                   childAspectRatio: 2.5,
//                 ),
//                 itemBuilder: (context, index) {

//                   bool isSelected = selectedIndex == index;

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },

//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.orange : Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.orange),
//                       ),
//                       child: Text(
//                         slots[index],
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.orange,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 10),

//             /// CONTINUE BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),

//                 onPressed: selectedIndex == -1
//                     ? null
//                     : () {

//                         String selectedSlot = slots[selectedIndex];
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentPage(
//                               trainerName: "Mike Johnson",
//                               slot: selectedSlot,
//                               price: "\$25 / Session",
//                             ),
//                           ),
//                         );

//                         /// Next step will be Payment Page
//                       },

//                 child: const Text(
//                   "Continue to Payment",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }