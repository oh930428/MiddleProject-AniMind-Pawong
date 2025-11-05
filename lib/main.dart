import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'features/auth/domain/viewmodel/auth_view_model.dart';

import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/theme/app_theme.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/pet_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
