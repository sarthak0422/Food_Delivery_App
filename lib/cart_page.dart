import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_cart_tile.dart';
import 'package:untitled/models/restaurant.dart';
import 'package:untitled/payment_page.dart';

import 'components/my_slide_button.dart';

// class CartPage extends StatelessWidget {
//   const CartPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Restaurant>(
//       builder: (context, restaurant, child) {
//         //cart
//         final userCart = restaurant.cart;
//
//         //scaffold UI
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Cart"),
//             backgroundColor: Colors.transparent,
//             foregroundColor: Theme.of(context).colorScheme.inversePrimary,
//             actions: [
//               //clear cart button
//               IconButton(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("Are you sure you want to clear the cart?"),
//                           actions: [
//                             //cancle button
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text("Cancle"),
//                             ),
//                             //yes button
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 restaurant.clearCart();
//                               },
//                               child: const Text("Yes"),
//                             ),
//
//                           ],
//                         ),
//                         );
//                   },
//                   icon: Icon(Icons.delete)
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//
//               //list of cart
//               Expanded(
//                 child: Column(
//                   children: [
//                    userCart.isEmpty ?
//                    const Expanded(
//                      child: Center(
//                        child: Text("Cart is Empty...."),
//                      ),
//                    )
//                        : Expanded(
//                         child: ListView.builder(
//                           itemCount: userCart.length,
//                             itemBuilder: (context, index) {
//
//                             //get individual cart item
//                               final cartItem = userCart[index];
//
//                               //return cart title UI
//                               return MyCartTile(cartItem: cartItem);
//                             },
//                         ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               //button to pay
//
//               MyButton(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PaymentPage(),
//                   ),
//                   ),
//                   text: "Go to Checkout"
//               ),
//               const SizedBox(height: 25,)
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface, // Clean background
          appBar: AppBar(
            title: const Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // Styled Trash Icon
              IconButton(
                onPressed: () => _showClearCartDialog(context, restaurant),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              // List of cart items
              Expanded(
                child: userCart.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: userCart.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => MyCartTile(cartItem: userCart[index]),
                ),
              ),

              // Summary & Checkout Section (The "Shiny" part)
              if (userCart.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // Total Price Row (Add this to your Restaurant model)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text("Total Items", style: TextStyle(fontSize: 16)),
                      //     Text("${userCart.length}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      // MyButton(
                      //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage())),
                      //   text: "Go to Checkout",
                      // ),
                      // Checkout Summary Card
                      if (userCart.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: SafeArea( // Ensures padding on notched phones
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Item Count Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Items",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // The Count Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${restaurant.getTotalItemCount()}", // Add this method to your Restaurant model
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Total Price Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Subtotal",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "₹${restaurant.getTotalPrice().toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Checkout Button
                                // MyButton(
                                //   onTap: () => Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => const PaymentPage()),
                                //   ),
                                //   text: "Go to Checkout",
                                // ),
                                // Slide to Pay Button
                                MySlidingButton(
                                  text: "Slide to Checkout",
                                  onSubmit: () {
                                    // Delay slightly so the user sees the "finish" animation
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const PaymentPage()),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Refactored Empty State
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 15),
          const Text("Your cart is lonely...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const Text("Add some delicious food to start!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Refactored Dialog
  void _showClearCartDialog(BuildContext context, Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Clear Cart?"),
        content: const Text("This will remove all items from your order."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              restaurant.clearCart();
              Navigator.pop(context);
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}