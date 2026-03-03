import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/restaurant.dart';

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Order Confirmed!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // The "Paper Ticket" Container
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            padding: const EdgeInsets.all(25),
            child: Consumer<Restaurant>(
              builder: (context, restaurant, child) {
                final cart = restaurant.cart;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("RECEIPT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                        Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const Divider(height: 30),

                    // List of Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${item.quantity} x ${item.food.name}"),
                                  Text("₹${(item.food.price * item.quantity).toStringAsFixed(2)}"),
                                ],
                              ),
                              // Show Addons if they exist
                              if (item.selectedAddons.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 4),
                                  child: Text(
                                    item.selectedAddons.map((a) => a.name).join(", "),
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    const Divider(thickness: 1, height: 1),
                    const SizedBox(height: 20),

                    // Totals Section
                    _buildTotalRow("Subtotal", "₹${restaurant.getTotalPrice().toStringAsFixed(2)}"),
                    _buildTotalRow("Delivery Fee", "₹40.00"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TOTAL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "₹${(restaurant.getTotalPrice() + 40).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 25),
          const Text("Estimated delivery: 4:10 PM", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}