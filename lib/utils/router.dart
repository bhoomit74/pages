import 'package:go_router/go_router.dart';
import 'package:pages/screens/dashboard/dashboard.dart';
import 'package:pages/screens/splash.dart';
import 'package:pages/utils/routes.dart';

GoRouter route = GoRouter(
  routes: [
    GoRoute(
      path: Routes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.dashboardRoute,
      builder: (context, state) => const Dashboard(),
    ),
  ],
);
