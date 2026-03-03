import 'package:flutter/material.dart';
import 'package:untitled/models/food.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            // Adding a subtle background and rounded corners to the whole tile
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // 1. Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${food.price}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food.description,
                        maxLines: 2, // Keeps the UI clean if description is long
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // 2. Food Image with Modern Styling
                Hero(
                  tag: food.name, // Adds a smooth transition animation to the next page
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Match the card roundness
                    child: Image.asset(
                      food.imagePath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover, // Ensures the image fills the square perfectly
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Polished spacing instead of a harsh line
        const SizedBox(height: 10),
      ],
    );
  }
}