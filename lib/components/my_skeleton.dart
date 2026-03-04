import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MySkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const MySkeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}