import 'package:flutter/material.dart';

import '../../data/repositories/notification_repository.dart';
import '../entities/notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  bool isLoading = false;
  bool hasUnread = false;

  NotificationViewModel(this._notificationRepository) {
    initNotifications();
  }

  /// 초기 알림 로드 + 실시간 구독
  Future<void> initNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1️⃣ 기존 알림 불러오기
      _notifications = await _notificationRepository.getAllNotifications();
      hasUnread = _notifications.any((n) => !n.isRead);
      notifyListeners();

      // 2️⃣ 실시간 새 알림 구독
      _notificationRepository.subscribeNewNotifications().listen((newItem) {
        _notifications.insert(0, newItem);
        hasUnread = true; // BottomNav 빨간 점 표시
        notifyListeners();
      });
    } catch (e) {
      _notifications = [];
      hasUnread = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateIsRead(NotificationItem item) async {
    if (item.isRead) return; // 이미 읽음이면 처리하지 않음

    try {
      // 1️⃣ 서버에 읽음 상태 업데이트
      await _notificationRepository.updateIsRead(item.id);

      // 2️⃣ 로컬 데이터에도 반영
      final index = _notifications.indexWhere((n) => n.id == item.id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }

      // 3️⃣ 전체 읽지 않은 알림 여부 갱신
      hasUnread = _notifications.any((n) => !n.isRead);

      // 4️⃣ 화면 갱신
      notifyListeners();
    } catch (e) {
      debugPrint("🚨 알림 읽음 처리 실패: $e");
    }
  }
}
