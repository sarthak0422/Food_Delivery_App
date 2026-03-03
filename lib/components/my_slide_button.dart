import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MySlidingButton extends StatelessWidget {
  final String text;
  final VoidCallback onSubmit;

  const MySlidingButton({
    super.key,
    required this.text,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SlideAction(
        borderRadius: 12,
        elevation: 0,
        innerColor: Theme.of(context).colorScheme.primary, // The sliding icon color
        outerColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2), // The track color
        sliderButtonIcon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 18,
        ),
        text: text,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        sliderRotate: false,
        onSubmit: () {
          onSubmit();
          return null;
          },
      ),
    );
  }
}