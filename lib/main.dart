import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'features/auth/domain/viewmodel/auth_viewmodel.dart';
import 'features/home/data/datasources/home_supabase_data.dart';
import 'features/home/data/repositories/home_repository.dart';
import 'features/pet/domain/viewmodel/setting_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_BASE_URL"),
    anonKey: dotenv.get("SUPABASE_API_KEY"),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => HomeRepository(HomeSupabaseDataSource())),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SettingViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(context),
      title: "Animind",
    );
  }
}
