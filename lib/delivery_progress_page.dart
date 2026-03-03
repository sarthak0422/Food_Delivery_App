import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_recipt.dart';
import 'package:untitled/models/restaurant.dart';
import 'components/my_buttons.dart';
import 'components/my_stepper.dart';
import 'home_page.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ UPDATED APPBAR WITH CLOSE BUTTON
      appBar: AppBar(
        title: const Text("T R A C K I N G"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<Restaurant>(context, listen: false)
                .saveOrderToHistory();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ),

      bottomNavigationBar: _buildBottomContactCard(context),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Estimated Time Header
            _buildEstimatedTimeHeader(),

            // ✅ Live Order Stepper
            const MyOrderStepper(currentStep: 1),

            const SizedBox(height: 20),

            // ✅ Receipt
            const MyReceipt(),

            const SizedBox(height: 30),

            // ✅ Back To Home Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MyButton(
                text: "Back to Home",
                onTap: () {
                  // 1️⃣ Save current order to history
                  final restaurant = Provider.of<Restaurant>(context, listen: false);
                  restaurant.saveOrderToHistory();

                  // 2️⃣ Navigate to Home and clear previous screens
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ------------------ HEADER ------------------

  Widget _buildEstimatedTimeHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Estimated Delivery",
                style:
                TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const Text(
                "25 - 30 Minutes",
                style:
                TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(
            Icons.delivery_dining_rounded,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // ------------------ DRIVER CONTACT CARD ------------------

  Widget _buildBottomContactCard(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 10),

          // Driver Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rohan Sharma",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Your Delivery Partner",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Buttons
          Row(
            children: [
              _buildCircularButton(Icons.message, Colors.white),
              const SizedBox(width: 10),
              _buildCircularButton(Icons.call, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildCircularButton(IconData icon, Color color) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(icon, color: color),
        ),
      ),
    );
  }
}