import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pages/screens/on-board/on_board_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  double mobileWidth = 120;
  double width = 120;
  double height = 27;
  double radius = 16;
  double notificationTileScale = 0;
  double musicScale = 1;
  bool isOpen = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mobileWidth = MediaQuery.of(context).size.width - 40;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    return const OnBoardingPageView();
  }
}
