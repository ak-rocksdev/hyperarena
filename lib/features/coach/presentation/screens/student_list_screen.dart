import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/coach/providers/student_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class StudentListScreen extends ConsumerWidget {
  const StudentListScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Murid Saya')),
      body: AsyncValueWidget<List<String>>(
        value: studentsAsync,
        loading: () => Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            children: List.generate(
              4,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: ShimmerLoading.card(height: 64),
              ),
            ),
          ),
        ),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(studentListProvider),
        ),
        data: (students) {
          if (students.isEmpty) {
            return const EmptyState(
              message: 'Belum ada murid',
              icon: Icons.people_outline,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final name = students[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.studentDetail(name));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.base),
                    decoration: BoxDecoration(
                      color: AppSurfaces.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                      boxShadow: AppShadows.xs,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppDimensions.avatarMd / 2,
                          backgroundColor: AppColors.primary50,
                          child: Text(
                            _initials(name),
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Text(name, style: AppTypography.titleSmall),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.neutral400,
                          size: AppDimensions.iconMd,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
