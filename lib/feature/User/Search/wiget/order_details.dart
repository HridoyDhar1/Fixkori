import 'package:flutter/material.dart';
import '../../../../core/widgets/contact_screen.dart';
import '../../../Admin/Auth/data/model/admin_model.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final String?serviceCategory;
  final String? title;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final AdminModel? adminData;

  const BookingConfirmationScreen({
    super.key,
    required this.service,
    this.selectedDate,
    this.selectedTime,
    this.title,
    this.adminData, this.serviceCategory,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to contact screen after 20 seconds
    Future.delayed(const Duration(seconds: 20), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ContactUsScreen()),
      );
    });
  }

  String getFormattedDate() {
    if (widget.selectedDate == null) return "Not selected";
    return "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}";
  }

  String getFormattedTime() {
    if (widget.selectedTime == null) return "Not selected";
    return "${widget.selectedTime!.hour}:${widget.selectedTime!.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final adminData = widget.adminData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top title
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Booking Confirmation",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.service["location"] ?? "Service Location",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Icon
              const Center(
                child: Icon(Icons.check_circle, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 16),

              const Text(
                "Thanks, your booking has been confirmed.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please check your email for receipt and booking details or visit Projects to review your booking.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              const Text(
                "Service Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Service card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: adminData?.imageUrl != null
                              ? NetworkImage(adminData!.imageUrl!)
                              : const AssetImage("assets/images/Mask group.jpg")
                          as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                        "${widget.service["post"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                adminData?.number ?? "No phone number",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.service["verified"] == true)
                          const Icon(Icons.verified, color: Colors.blue, size: 16),
                      ],
                    ),

                    const Divider(height: 24),

                    // Date & Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DetailColumn("Date", getFormattedDate()),
                        _DetailColumn("Time", getFormattedTime()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Service Name & Additional Info
                    _DetailColumn(
                        "Service", widget.service["post"] ?? "Service Title"),
                    const SizedBox(height: 16),

                    _DetailColumn(
                        "Price", "₦ ${widget.service["price"] ?? "0"}"),

                    const SizedBox(height: 16),

                    _DetailColumn(
                        "Address", widget.service["location"] ?? "Address"),

                    const SizedBox(height: 16),
                    const Divider(),

                    // Total Booking Cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Booking Cost",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₦ ${widget.service["price"] ?? "0"}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Booking Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Booking Cost",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₦ ${widget.service["price"] ?? "0"}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "You won’t be charged until the job is completed.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  final String title;
  final String value;

  const _DetailColumn(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
