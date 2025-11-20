import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/notification.dart';
import '../datasources/notification_supabase_data.dart';

class NotificationRepository {
  final NotificationSupabaseDataSource notificationSupabaseDataSource;

  NotificationRepository(this.notificationSupabaseDataSource);

  // 전체 알림 조회
  Future<List<NotificationItem>> getAllNotifications() async {
    try {
      final notifications = await notificationSupabaseDataSource
          .getAllNotificationsWithDio();
      return notifications;
    } catch (e) {
      print("🚨 NotificationRepository.getAllNotifications 에러: $e");
      rethrow;
    }
  }

  Future<void> updateIsRead(int notificationId) async {
    try {
      await notificationSupabaseDataSource.updateIsReadWithDio(notificationId);
    } catch (e) {
      print("🚨 NotificationRepository.getAllNotifications 에러: $e");
      rethrow;
    }
  }

  // 콜백 전달 방식
  RealtimeChannel? subscribeNewNotifications(Function(NotificationItem) onNew) {
    return notificationSupabaseDataSource.subscribeNewNotifications(onNew);
  }
}
