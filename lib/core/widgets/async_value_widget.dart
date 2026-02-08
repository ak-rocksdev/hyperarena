import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';

/// Generic handler for AsyncValue — provides loading, error, and data states.
/// Usage: AsyncValueWidget(value: ref.watch(myProvider), data: (data) => ...)
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: loading ??
          () => Padding(
                padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppDimensions.md),
                      child: ShimmerLoading.card(height: 100),
                    ),
                  ),
                ),
              ),
      error: error ??
          (e, st) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppDimensions.iconXl,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppDimensions.base),
                      Text(
                        'Terjadi kesalahan',
                        style: AppTypography.headingSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        e.toString(),
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
      data: data,
    );
  }
}
