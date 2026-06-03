import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconData();
    final iconColor = _getIconColor();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppSurfaces.surface
            : AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.base),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unread indicator dot
                if (!notification.isRead) ...[
                  Container(
                    width: AppDimensions.sm,
                    height: AppDimensions.sm,
                    margin: EdgeInsets.only(
                      top: AppDimensions.md,
                      right: AppDimensions.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ] else ...[
                  SizedBox(width: AppDimensions.base),
                ],

                // Icon circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 20,
                  ),
                ),

                SizedBox(width: AppDimensions.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight:
                              notification.isRead ? FontWeight.w500 : FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppDimensions.xs),
                      Text(
                        notification.body,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.sm),
                      Text(
                        _timeAgo(notification.createdAt),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (notification.type) {
      case NotificationType.paymentReminder:
        return Icons.payment;
      case NotificationType.sessionReminder:
        return Icons.access_time;
      case NotificationType.reviewRequest:
        return Icons.rate_review;
      case NotificationType.assessmentReceived:
        return Icons.assessment;
      case NotificationType.bookingConfirmed:
        return Icons.check_circle;
      case NotificationType.sessionFull:
        return Icons.group;
      case NotificationType.sessionCancelled:
        return Icons.cancel;
      case NotificationType.paymentConfirmed:
        return Icons.check_circle;
      case NotificationType.paymentRejected:
        return Icons.cancel;
      case NotificationType.badge:
        return Icons.emoji_events;
      case NotificationType.general:
        return Icons.notifications;
      case NotificationType.coachAssignedToSession:
        return Icons.sports;
      case NotificationType.sessionScheduleChange:
        return Icons.edit_calendar;
      case NotificationType.assessmentReminder:
        return Icons.assignment_late;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.paymentReminder:
        return AppColors.warning;
      case NotificationType.sessionReminder:
        return AppColors.info;
      case NotificationType.reviewRequest:
        return AppColors.accent;
      case NotificationType.assessmentReceived:
        return AppColors.secondary;
      case NotificationType.bookingConfirmed:
      case NotificationType.paymentConfirmed:
        return AppColors.success;
      case NotificationType.sessionFull:
        return AppColors.primary;
      case NotificationType.sessionCancelled:
      case NotificationType.paymentRejected:
        return AppColors.error;
      case NotificationType.badge:
        return AppColors.accent;
      case NotificationType.general:
        return AppColors.neutral500;
      case NotificationType.coachAssignedToSession:
      case NotificationType.sessionScheduleChange:
        return AppColors.info;
      case NotificationType.assessmentReminder:
        return AppColors.warning;
    }
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }
}
