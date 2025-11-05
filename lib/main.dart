import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'features/auth/domain/viewmodel/auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_BASE_URL"),
    anonKey: dotenv.get("SUPABASE_API_KEY"),
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MaterialApp.router(
      title: 'Animind',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
