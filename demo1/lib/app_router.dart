import 'package:demo1/core/theme/app_theme.dart';
import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:demo1/features/auth/presentation/viewmodels/session_view_model.dart';
import 'package:demo1/features/auth/presentation/views/login_view.dart';
import 'package:demo1/features/climate/presentation/views/climate_view.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';
import 'package:demo1/features/overview/presentation/viewmodels/overview_view_model.dart';
import 'package:demo1/features/overview/presentation/views/overview_view.dart';
import 'package:demo1/features/plant_health/presentation/views/plant_health_view.dart';
import 'package:demo1/features/resources/presentation/resource_type.dart';
import 'package:demo1/features/resources/presentation/views/resources_view.dart';
import 'package:demo1/features/shell/presentation/views/app_shell.dart';
import 'package:demo1/features/soil/presentation/views/soil_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(SessionViewModel session) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: session,
    redirect: (context, state) {
      final loggedIn = session.isLoggedIn;
      final atLogin = state.matchedLocation == '/login';
      if (!loggedIn && !atLogin) return '/login';
      if (loggedIn && atLogin) return '/overview';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => Theme(
          data: AppTheme.glass,
          child: ChangeNotifierProvider(
            create: (ctx) => LoginViewModel(
              ctx.read<AuthRepository>(),
              ctx.read<SessionViewModel>(),
            ),
            child: const LoginView(),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/overview',
                builder: (context, state) => ChangeNotifierProvider(
                  create: (ctx) =>
                      OverviewViewModel(ctx.read<GreenhouseRepository>())
                        ..load(),
                  child: const OverviewView(),
                ),
                routes: [
                  GoRoute(
                    path: 'resources/:type',
                    builder: (context, state) => ResourcesView(
                      type: ResourceType.fromName(state.pathParameters['type']),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/climate',
                builder: (context, state) => const ClimateView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/soil',
                builder: (context, state) => const SoilView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/plants',
                builder: (context, state) => const PlantHealthView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
