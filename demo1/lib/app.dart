import 'package:demo1/app_router.dart';
import 'package:demo1/core/theme/app_theme.dart';
import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/session_view_model.dart';
import 'package:demo1/features/greenhouse/data/repositories/fake_greenhouse_repository.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SessionViewModel _session;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _session = SessionViewModel();
    _router = createRouter(_session);
  }

  @override
  void dispose() {
    _router.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _session),
        Provider<AuthRepository>(create: (_) => FakeAuthRepository()),
        Provider<GreenhouseRepository>(
          create: (_) => FakeGreenhouseRepository(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Plant-Tech',
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
