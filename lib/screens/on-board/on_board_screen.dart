import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingPageView extends StatefulWidget {
  const OnBoardingPageView({Key? key}) : super(key: key);

  @override
  State<OnBoardingPageView> createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  late PageController _pageController;
  double offset = 0.0;
  double page = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        offset = _pageController.offset;
        page = _pageController.page ?? 0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        offset = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.mirror,
                  colors: [Colors.grey.shade200, Colors.blueGrey])),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                itemCount: 3,
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
              MountainView(offset: offset, page: page),
              TreesView(offset: offset, page: page),
              BirdView(offset: offset, page: page),
              OnboardingText1(offset: offset, page: page),
              OnboardingText2(offset: offset, page: page),
              OnboardingText3(offset: offset, page: page),
              const PageIndexBackground(),
              PageIndexView(offset: offset, page: page)
            ],
          ),
        ),
      ),
    );
  }
}

class MountainView extends StatelessWidget {
  final double offset;
  final double page;
  const MountainView({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: -offset,
        bottom: 10,
        width: MediaQuery.of(context).size.width * 3,
        child: IgnorePointer(
            child: Center(
                child: Image.asset(
          "assets/mountains.png",
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ))));
  }
}

class TreesView extends StatelessWidget {
  final double offset;
  final double page;
  const TreesView({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: (-offset / 4) + offset / (screenWidth / 2),
        bottom: 0,
        width: screenWidth * 2,
        child: IgnorePointer(
            child: Center(child: Image.asset("assets/trees.png"))));
  }
}

class BirdView extends StatelessWidget {
  final double offset;
  final double page;
  const BirdView({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: (-offset / 2) + offset / (screenWidth / 2),
        top: 300 - (page * 20),
        width: screenWidth * 1.5,
        child: IgnorePointer(
            child: Center(
                child: SizedBox(
                    width: 80, child: Image.asset("assets/birds_black.png")))));
  }
}

/*class SunView extends StatelessWidget {
  final double offset;
  final double page;
  const SunView({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: ((page * screenWidth / 2)) -
            screenWidth * 0.25,
        top: (MediaQuery.of(context).size.width - offset).isNegative
            ? 120 - (MediaQuery.of(context).size.width - offset)
            : 120 + (MediaQuery.of(context).size.width - offset),
        child: IgnorePointer(
            child: Center(
                child: Opacity(
                    opacity: 1 -
                        (((MediaQuery.of(context).size.width - offset)
                                    .isNegative
                                ? -(MediaQuery.of(context).size.width - offset)
                                : (MediaQuery.of(context).size.width -
                                    offset)) /
                            360),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset("assets/sun.png"),
                    )))));
  }
}*/

class OnboardingText1 extends StatelessWidget {
  final double offset;
  final double page;
  const OnboardingText1({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: 0,
        bottom: 200 - (offset - (screenWidth * page.floor())) / 2,
        width: screenWidth,
        child: IgnorePointer(
            child: Opacity(
          opacity: page < 1 ? 1 - (page - page.floor()) : 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Text(
                  "Travel the world",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w900)
                              .fontFamily,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  "Experience the most breathtaking views across the world",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w200),
                ),
              ],
            )),
          ),
        )));
  }
}

class OnboardingText2 extends StatelessWidget {
  final double offset;
  final double page;
  const OnboardingText2({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: 0,
        bottom:
            200 - (page >= 1 ? (offset - (screenWidth * page.floor())) / 2 : 0),
        width: MediaQuery.of(context).size.width,
        child: IgnorePointer(
            child: Opacity(
          opacity: page > 0.7 && page < 1
              ? -(0.69 - page) * 3
              : page < 2 && page >= 1
                  ? 1 - (page - page.floor())
                  : 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Text(
                  "Find best deals",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w900)
                              .fontFamily,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  "Find deal that suits your need anytime, anywhere hassle free!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w200),
                ),
              ],
            )),
          ),
        )));
  }
}

class OnboardingText3 extends StatelessWidget {
  final double offset;
  final double page;
  const OnboardingText3({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        left: 0,
        bottom:
            200 - (page > 2 ? (offset - (screenWidth * page.floor())) / 2 : 0),
        width: MediaQuery.of(context).size.width,
        child: IgnorePointer(
            child: Opacity(
          opacity: page > 1.7 && page < 2
              ? -(1.69 - page) * 3
              : page < 3 && page >= 2
                  ? 1 - (page - page.floor())
                  : 0
          /*(((MediaQuery.of(context).size.width - offset).isNegative
                  ? -(MediaQuery.of(context).size.width - offset)
                  : (MediaQuery.of(context).size.width - offset)) /
              360)*/
          ,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Text(
                  "And simply enjoy",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w900)
                              .fontFamily,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  "Enjoy every second of your holiday & enjoy experience of different cultures!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w200),
                ),
              ],
            )),
          ),
        )));
  }
}

class PageIndexView extends StatelessWidget {
  final double offset;
  final double page;
  const PageIndexView({Key? key, required this.offset, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 36 + (page * 24),
      bottom: 36,
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 24,
            height: 10,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PageIndexBackground extends StatelessWidget {
  const PageIndexBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 36,
        bottom: 36,
        child: IgnorePointer(
            child: Center(
          child: Container(
            width: 72,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.4),
            ),
            alignment: Alignment.centerLeft,
          ),
        )));
  }
}
