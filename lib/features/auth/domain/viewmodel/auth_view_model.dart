import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthViewModel extends ChangeNotifier {
  String? userId;
  String? userEmail;

  bool isLoading = false;

  AuthViewModel() {
    _listenAuthState();
  }

  void _listenAuthState() {
    supabase.auth.onAuthStateChange.listen((data) {
      final newUserId = data.session?.user.id;
      final newUserEmail = data.session?.user.email;

      if (newUserId != userId) {
        userId = newUserId;
        userEmail = newUserEmail;
        notifyListeners();
      }
    });
  }

  // 구글 로그인
  Future<void> loginWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final scopes = ['email', 'profile'];
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: dotenv.get("GOOGLE_WEB_CLIENT_ID"),
        clientId: dotenv.get("GOOGLE_ANDROID_CLIENT_ID"),
      );
      final googleUser = await googleSignIn.attemptLightweightAuthentication();
      print("user: $googleUser");
      if (googleUser == null) {
        throw AuthException('Failed to sign in with Google.');
      }

      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
          await googleUser.authorizationClient.authorizeScopes(scopes);

      final idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        throw AuthException('No ID Token found.');
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      return;
    } catch (e) {
      debugPrint("Google 로그인 실패: $e");
      rethrow;
    } finally {
      if (userId == null) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // 로그아웃
  Future<void> logOut() async {
    try {
      isLoading = true;
      notifyListeners();

      await supabase.auth.signOut(); // 수파베이스
      await GoogleSignIn.instance.signOut(); // 구글 로그인 해당
      userId = null;
    } catch (error) {
      debugPrint("로그아웃 실패: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
