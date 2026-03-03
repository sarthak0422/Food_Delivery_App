import 'package:flutter/material.dart';
import 'package:untitled/cart_page.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // Increased to 600 to accommodate Map (200) + Description + Location
      expandedHeight: 600,
      collapsedHeight: 120,
      floating: false,
      pinned: true,
      actions: [
        // Cart button with a subtle background for better visibility over maps
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,

      // Secondary Title (Visible when collapsed)
      title: const Text(
        "GharKaLunch",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            // Bottom padding of 60 ensures content doesn't sit under the TabBar
            padding: const EdgeInsets.only(bottom: 60.0),
            child: child,
          ),
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        // Keeps the TabBar size consistent while scaling
        expandedTitleScale: 1.0,
      ),
    );
  }
}