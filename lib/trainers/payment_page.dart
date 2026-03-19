import 'package:flutter/material.dart';
import '../trainers/trainer_model.dart';
import '../bookings/booking_model.dart';
import '../bookings/booking_service.dart';
import 'booking_confirmation_page.dart';

class PaymentPage extends StatefulWidget {
  final TrainerModel trainer;
  final String selectedDate;
  final String selectedSlot;

  const PaymentPage({
    super.key,
    required this.trainer,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? selectedPaymentIndex;
  bool isProcessing = false;

  final List<_PaymentMethod> paymentMethods = [
    _PaymentMethod(icon: Icons.credit_card, name: "Credit / Debit Card", subtitle: "Visa, Mastercard, Rupay", type: PaymentType.card),
    _PaymentMethod(icon: Icons.phone_android, name: "UPI", subtitle: "GPay, PhonePe, Paytm", type: PaymentType.upi),
    _PaymentMethod(icon: Icons.account_balance, name: "Net Banking", subtitle: "All major banks", type: PaymentType.netBanking),
    _PaymentMethod(icon: Icons.account_balance_wallet, name: "Wallet", subtitle: "Paytm, Amazon Pay", type: PaymentType.wallet),
  ];

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _upiController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  bool get canProceed {
    if (selectedPaymentIndex == null) return false;
    final type = paymentMethods[selectedPaymentIndex!].type;
    if (type == PaymentType.card) {
      return _cardNumberController.text.length >= 16 &&
          _expiryController.text.length == 5 &&
          _cvvController.text.length == 3;
    }
    if (type == PaymentType.upi) return _upiController.text.contains("@");
    return true;
  }

  void _confirmPayment() async {
    setState(() => isProcessing = true);

    final bookingId = "EVT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final paymentMethodName = paymentMethods[selectedPaymentIndex!].name;

    final booking = BookingModel(
      bookingId: bookingId,
      trainerId: widget.trainer.id,
      trainerName: widget.trainer.name,
      trainerCategory: widget.trainer.category,
      trainerLocation: widget.trainer.location,
      trainerImageUrl: widget.trainer.imageUrl,
      trainerPrice: widget.trainer.price,
      selectedDate: widget.selectedDate,
      selectedSlot: widget.selectedSlot,
      paymentMethod: paymentMethodName,
      bookedAt: DateTime.now(),
    );

    // Save Firestore in background — no await
    BookingService.saveBooking(booking);

    if (!mounted) return;
    setState(() => isProcessing = false);

    // Show success dialog instantly
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _PaymentSuccessDialog(),
    );

    if (!mounted) return;

    // Navigate to confirmation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationPage(
          trainer: widget.trainer,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedSlot,
          paymentMethod: paymentMethodName,
          bookingId: bookingId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Booking Summary ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Booking Summary", style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  _SummaryRow(icon: Icons.person, label: "Trainer", value: widget.trainer.name),
                  const Divider(height: 16),
                  _SummaryRow(icon: Icons.category, label: "Category", value: widget.trainer.category),
                  const Divider(height: 16),
                  _SummaryRow(icon: Icons.calendar_today, label: "Date", value: widget.selectedDate),
                  const Divider(height: 16),
                  _SummaryRow(icon: Icons.access_time, label: "Time", value: "${widget.selectedSlot} (60 min)"),
                  const Divider(height: 16),
                  _SummaryRow(icon: Icons.location_on, label: "Location", value: widget.trainer.location),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(widget.trainer.price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text("Choose Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ...List.generate(paymentMethods.length, (index) {
              final method = paymentMethods[index];
              final isSelected = selectedPaymentIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedPaymentIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade200, width: isSelected ? 2 : 1),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(method.icon, color: isSelected ? Colors.orange : Colors.grey.shade600, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(method.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(method.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade400, width: 2),
                            ),
                            child: isSelected ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle))) : null,
                          ),
                        ],
                      ),
                      if (isSelected && method.type == PaymentType.card) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildTextField(controller: _cardNumberController, label: "Card Number", hint: "1234 5678 9012 3456", keyboardType: TextInputType.number, maxLength: 16),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(child: _buildTextField(controller: _expiryController, label: "Expiry", hint: "MM/YY", maxLength: 5)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField(controller: _cvvController, label: "CVV", hint: "•••", keyboardType: TextInputType.number, maxLength: 3, obscureText: true)),
                        ]),
                      ],
                      if (isSelected && method.type == PaymentType.upi) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildTextField(controller: _upiController, label: "UPI ID", hint: "yourname@upi", keyboardType: TextInputType.emailAddress),
                      ],
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
        child: ElevatedButton(
          onPressed: isProcessing ? null : (!canProceed ? null : _confirmPayment),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            disabledBackgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: isProcessing
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Text("Confirm & Pay →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.orange)),
          ),
        ),
      ],
    );
  }
}

// ── Payment Success Dialog ─────────────────────────────────────────
class _PaymentSuccessDialog extends StatefulWidget {
  const _PaymentSuccessDialog();
  @override
  State<_PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<_PaymentSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
    // Auto close after 1.8s
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade200, width: 2),
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 20),
              const Text("Payment Successful!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Your session has been booked", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.orange,
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Flexible(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
      ],
    );
  }
}

enum PaymentType { card, upi, netBanking, wallet }

class _PaymentMethod {
  final IconData icon;
  final String name;
  final String subtitle;
  final PaymentType type;
  const _PaymentMethod({required this.icon, required this.name, required this.subtitle, required this.type});
}