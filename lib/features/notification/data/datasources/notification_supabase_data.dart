import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:middleproject_animind_pawong/features/notification/domain/viewmodel/notification_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/notification.dart';

class NotificationSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";

  NotificationSupabaseDataSource() {
    final String apiKey = dotenv.env["SUPABASE_API_KEY"] ?? "";
    final String authorization = dotenv.env["SUPABASE_API_KEY"] ?? "";

    _dio = Dio(
      BaseOptions(
        headers: {
          "apikey": apiKey,
          "Authorization": "Bearer $authorization",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  String? get _userId => Supabase.instance.client.auth.currentSession?.user.id;

  // 알림 목록 - API 응답 및 요청
  Future<List<NotificationItem>> getAllNotificationsWithDio() async {
    final response = await _dio.get(
      '$_baseUrl/notifications',
      queryParameters: {
        "select": "*, to_user:to_user_id(name), from_user:from_user_id(name)",
        "to_user_id": 'eq.$_userId',
        "order": "created_at.desc",
      },
    );

    return (response.data as List)
        .map((json) => NotificationItem.fromJson(json))
        .toList();
  }

  // 알림 읽음 - API 응답 및 요청
  Future<void> updateIsReadWithDio(int notificationId) async {
    await _dio.patch(
      '$_baseUrl/notifications?id=eq.$notificationId',
      data: {'is_read': true},
    );
  }

  // NotificationSupabaseDataSource
  RealtimeChannel? subscribeNewNotifications(Function(NotificationItem) onNew) {
    final supabase = Supabase.instance.client;

    return supabase
        .channel('notification_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'to_user_id',
            value: _userId,
          ),
          callback: (payload) {
            final newNotification = NotificationItem.fromJson(
              payload.newRecord,
            );
            onNew(newNotification); // 콜백 호출
          },
        )
        .subscribe();
  }
}
