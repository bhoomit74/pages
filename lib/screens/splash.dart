import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/styles/colors.dart';
import 'package:pages/styles/styles.dart';

import '../utils/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      GoRouter.of(context).go(Routes.dashboardRoute);
    });
    return Scaffold(
      backgroundColor: AppColor.shadowWhite,
      body: Center(
        child: Text(
          "Pages",
          style: AppStyles.h1,
        ).animate().fadeIn(
            curve: Curves.easeInBack, duration: const Duration(seconds: 1)),
      ),
    );
  }
}
