import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/notification_repository.dart';
import '../entities/notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  RealtimeChannel? _realtimeChannel;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  bool isLoading = false;
  bool hasUnread = false;

  NotificationViewModel(this._notificationRepository);

  /// 초기 알림 로드 + 실시간 구독
  Future<void> initNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      // 기존 알림 불러오기
      _notifications = await _notificationRepository.getAllNotifications();
      _updateHasUnread();

      // 실시간 구독이 없으면 설정
      _realtimeChannel ??= _notificationRepository.subscribeNewNotifications((
        newItem,
      ) {
        _notifications.insert(0, newItem);
        _updateHasUnread();
        notifyListeners();
      });
    } catch (e) {
      _notifications = [];
      hasUnread = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateIsRead(NotificationItem item) async {
    if (item.isRead) return;

    try {
      await _notificationRepository.updateIsRead(item.id);
      final index = _notifications.indexWhere((n) => n.id == item.id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
      _updateHasUnread();
      notifyListeners();
    } catch (e) {
      debugPrint("🚨 알림 읽음 처리 실패: $e");
    }
  }

  /// 읽지 않은 알림 여부 갱신
  void _updateHasUnread() {
    hasUnread = _notifications.any((n) => !n.isRead);
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}
