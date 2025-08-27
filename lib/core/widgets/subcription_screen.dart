import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:serviceapp/core/widgets/custom_elevatedbutton.dart';
import 'package:serviceapp/core/widgets/paying_card.dart';

enum PaymentType { online, cash }

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static const String name = '/subscription';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool? _selectedPlan = true; // true = monthly, false = yearly
  PaymentType? _paymentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Set up Your Payment &\nBuy Subscription",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Plan selection
                const Text(
                  "Starter Plan",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: _selectedPlan,
                        onChanged: (value) {
                          setState(() {
                            _selectedPlan = value;
                          });
                        },
                        title: const Text(
                          "Pay Monthly",
                          style: TextStyle(color: Colors.black87),
                        ),
                        subtitle: const Text(
                          "\$2.0 / Month / Member",
                          style: TextStyle(color: Colors.black87),
                        ),
                        activeColor: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: _selectedPlan,
                        onChanged: (value) {
                          setState(() {
                            _selectedPlan = value;
                          });
                        },
                        title: const Text(
                          "Pay Annually",
                          style: TextStyle(color: Colors.black87),
                        ),
                        subtitle: const Text(
                          "\$20.0 / Year / Member",
                          style: TextStyle(color: Colors.black87),
                        ),
                        activeColor: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Payment type
                const Text(
                  "Payment type",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PayingCard(
                      title: "Online",
                      isSelected: _paymentType == PaymentType.online,
                      onTap: () {
                        setState(() {
                          _paymentType = PaymentType.online;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    PayingCard(
                      title: "Cash",
                      isSelected: _paymentType == PaymentType.cash,
                      onTap: () {
                        setState(() {
                          _paymentType = PaymentType.cash;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Conditional payment details
                if (_paymentType == PaymentType.online) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Paying on this number:",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "01839478324",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter  Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Enter transcation id',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ] else if (_paymentType == PaymentType.cash) ...[
                  SizedBox(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            "Contact Us",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Phone
                          _contactItem(
                            icon: Icons.phone,
                            color: Colors.limeAccent,
                            text: "+92 347 096 35",
                          ),
                          _contactItem(
                            icon: Icons.email_outlined,
                            color: Colors.limeAccent,
                            text: "contact@mafimumshkil.services",
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            children: const [
                              _socialIcon(Icons.linked_camera), // placeholder
                              _socialIcon(Icons.facebook),

                              _socialIcon(Icons.camera_alt_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 50),
                CustomButton(
                  name: "Submit",
                  width: double.infinity,
                  height: 50,
                  color: Colors.black87,
                  onPressed: () {
                    Get.toNamed("/navigation");
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _contactItem({
  required IconData icon,
  required Color color,
  required String text,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
      const SizedBox(height: 8),
      Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
    ],
  );
}

class _socialIcon extends StatelessWidget {
  final IconData icon;

  const _socialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
