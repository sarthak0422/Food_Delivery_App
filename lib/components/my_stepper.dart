import 'package:flutter/material.dart';

class MyOrderStepper extends StatelessWidget {
  final int currentStep; // 0: Placed, 1: Preparing, 2: On the Way
  const MyOrderStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Row(
        children: [
          _buildStep(context, Icons.check_circle, "Placed", currentStep >= 0),
          _buildLine(context, currentStep >= 1),
          _buildStep(context, Icons.restaurant, "Preparing", currentStep >= 1),
          _buildLine(context, currentStep >= 2),
          _buildStep(context, Icons.delivery_dining, "On the Way", currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? Theme.of(context).colorScheme.inversePrimary : Colors.grey)),
      ],
    );
  }

  Widget _buildLine(BuildContext context, bool isActive) {
    return Expanded(
      child: Divider(
        thickness: 2,
        indent: 10,
        endIndent: 10,
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
      ),
    );
  }
}