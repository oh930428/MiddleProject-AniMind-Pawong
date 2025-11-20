import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/comments_viewmodel.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/posts_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'features/auth/domain/viewmodel/auth_viewmodel.dart';
import 'features/home/data/datasources/home_supabase_data.dart';
import 'features/home/data/repositories/home_repository.dart';
import 'features/notification/data/datasources/notification_supabase_data.dart';
import 'features/notification/data/repositories/notification_repository.dart';
import 'features/notification/domain/viewmodel/notification_viewmodel.dart';
import 'features/posts/data/datasources/comments_supabase_data.dart';
import 'features/posts/data/datasources/posts_supabase_data.dart';
import 'features/posts/data/repositories/comments_repository.dart';
import 'features/posts/data/repositories/posts_repository.dart';

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
        Provider(create: (_) => PostsRepository(PostsSupabaseDataSource())),
        Provider(
          create: (_) => CommentsRepository(CommentsSupabaseDataSource()),
        ),
        Provider(
          create: (_) =>
              NotificationRepository(NotificationSupabaseDataSource()),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (context) => PostsViewModel(context.read<PostsRepository>()),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              NotificationViewModel(context.read<NotificationRepository>()),
        ),
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
      title: "ANIMIND",
    );
  }
}
