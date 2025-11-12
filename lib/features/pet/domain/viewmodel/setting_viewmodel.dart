import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/users_supabase_data.dart';

class SettingViewModel extends ChangeNotifier {
  String? _userEmail;
  String? get userEmail => _userEmail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final UserSupabaseData _dataSource = UserSupabaseData();

  Future<void> loadUserEmail() async {
    _isLoading = true;
    notifyListeners();

    final currentUserId =
        Supabase.instance.client.auth.currentSession?.user?.id;

    if (currentUserId != null) {
      _userEmail = await _dataSource.fetchEmail(userId: currentUserId);
    } else {
      _userEmail = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
