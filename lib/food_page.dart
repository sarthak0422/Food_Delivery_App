import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_buttons.dart';
import 'package:untitled/models/food.dart';
import 'package:untitled/models/restaurant.dart';

class FoodPage extends StatefulWidget {
  final Food food;

  const FoodPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // Store selected addons here so the UI updates correctly
  final Map<Addons, bool> selectedAddons = {};

  @override
  void initState() {
    super.initState();
    // Initialize addons to false
    for (Addons addon in widget.food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  // Method to add to cart
  void addToCart() {
    // Close the current food page
    Navigator.pop(context);

    // Format the selected addons
    List<Addons> currentlySelectedAddons = [];
    for (Addons addon in widget.food.availableAddons) {
      if (selectedAddons[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }

    // Add to cart using Provider
    context.read<Restaurant>().addToCart(widget.food, currentlySelectedAddons);
    ScaffoldMessenger.of(context).clearSnackBars(); // Clears any existing ones
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Added ${widget.food.name} to cart!",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "View Cart",
          textColor: Colors.white,
          onPressed: () {
            // You could navigate to CartPage here if you want
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main UI
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Hero Food Image (Matches the tile animation)
                Hero(
                  tag: widget.food.name,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    child: Image.asset(
                      widget.food.imagePath,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Name & Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.food.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            '₹${widget.food.price}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Food Description
                      Text(
                        widget.food.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(height: 25),

                      Divider(color: Theme.of(context).colorScheme.tertiary),
                      const SizedBox(height: 10),

                      // Add-ons Header
                      const Text(
                        "Add-ons",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Add-ons List with Safety Checks
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.food.availableAddons.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).colorScheme.tertiary,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            // 1. Get the individual addon
                            Addons addon = widget.food.availableAddons[index];

                            // 2. Return the tile with a fallback value to prevent "Assertion Failed"
                            return CheckboxListTile(
                              title: Text(addon.name),
                              subtitle: Text(
                                '+ ₹${addon.price}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // SAFE CHECK: If the map doesn't have the key yet, default to false
                              value: selectedAddons[addon] ?? false,
                              activeColor: Theme.of(context).colorScheme.primary,
                              checkColor: Colors.white,
                              controlAffinity: ListTileControlAffinity.trailing, // Puts checkbox on the right
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedAddons[addon] = value!;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Button -> Add to cart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MyButton(
                    onTap: addToCart,
                    text: "Add To Cart",
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),

        // Polished Back Button
        SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}