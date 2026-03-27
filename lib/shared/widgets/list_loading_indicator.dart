import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

class ListLoadingIndicator extends StatelessWidget {
  const ListLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppDimensions.base),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
