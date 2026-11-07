// Contain : Material App, Theme, Router

import 'package:demo1/core/theme/app_theme.dart';
import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:demo1/features/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => FakeAuthRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant-Tech',
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<AuthRepository>()),
          child: const LoginView(),
        ),
      ),
    );
  }
}
