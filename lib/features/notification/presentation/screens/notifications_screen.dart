import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/presentation/widgets/notification_tile.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _markAllAsRead(ref),
            child: Text(
              'Tandai Semua Dibaca',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(notificationListProvider);
        },
        child: AsyncValueWidget<List<NotificationItem>>(
          value: notificationsAsync,
          data: (notifications) {
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: AppColors.neutral300,
                    ),
                    SizedBox(height: AppDimensions.base),
                    Text(
                      'Tidak ada notifikasi',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            final groupedNotifications = _groupNotificationsByDate(notifications);

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.base),
              itemCount: groupedNotifications.length,
              itemBuilder: (context, index) {
                final group = groupedNotifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenHorizontal,
                        vertical: AppDimensions.sm,
                      ),
                      child: Text(
                        group.label,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Notifications in this group
                    ...group.notifications.map(
                      (notification) => NotificationTile(
                        notification: notification,
                        onTap: () => _handleNotificationTap(
                          context,
                          ref,
                          notification,
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.base),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<_NotificationGroup> _groupNotificationsByDate(
    List<NotificationItem> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <NotificationItem>[];
    final yesterdayList = <NotificationItem>[];
    final olderList = <NotificationItem>[];

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (notificationDate == today) {
        todayList.add(notification);
      } else if (notificationDate == yesterday) {
        yesterdayList.add(notification);
      } else {
        olderList.add(notification);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(_NotificationGroup('Hari Ini', todayList));
    }
    if (yesterdayList.isNotEmpty) {
      groups.add(_NotificationGroup('Kemarin', yesterdayList));
    }
    if (olderList.isNotEmpty) {
      groups.add(_NotificationGroup('Sebelumnya', olderList));
    }

    return groups;
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationItem notification,
  ) async {
    // Mark as read
    if (!notification.isRead) {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markAsRead(notification.id);

      // Invalidate providers to refresh UI
      ref.invalidate(notificationListProvider);
      ref.invalidate(unreadCountProvider);
    }

    // Navigate to action route if present
    if (notification.actionRoute != null && context.mounted) {
      context.push(notification.actionRoute!);
    }
  }

  Future<void> _markAllAsRead(WidgetRef ref) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllAsRead();

    // Invalidate providers to refresh UI
    ref.invalidate(notificationListProvider);
    ref.invalidate(unreadCountProvider);
  }
}

class _NotificationGroup {
  final String label;
  final List<NotificationItem> notifications;

  _NotificationGroup(this.label, this.notifications);
}
