
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saleapp/Screens/Login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../themes/themes.dart';
import 'onboard_controller.dart';


class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});
  final PageController _pageController = PageController();

  final List<String> _images = [
    'assets/images/onboard.png',
    'assets/images/onboardsecond.png',
    'assets/images/onboardthrid.png'
  ];
  final List<String> title = [
    'Collaborate',
    'Track progress',
    'Share documents'
  ];

  final List<String> caption = [
    'Work together with your Team members in Real-time.',
    'Monitor task completion, identify potential roadblocks, and make real-time adjustments.',
    'Share contracts, blueprints, and so much more.'
  ];

  OnboardController _onboardController = Get.put(OnboardController());

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: appLightTheme.backgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.080,
          ),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.67,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _onboardController.pageController,
                  onPageChanged: _onboardController.onPageChnaged,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Stack(
                        children: [
                          Positioned(
                              child: Image.asset("assets/images/bglines.png")),
                          Positioned(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.170,
                              left: index == 2
                                  ? MediaQuery.of(context).size.width * 0.150
                                  : index == 1
                                      ? MediaQuery.of(context).size.width * 0.50
                                      : MediaQuery.of(context).size.width *
                                          -0.140,
                              child: Image.asset("assets/images/bgsquare.png")),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                title[index],
                                style: headline1,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.020),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.370,
                                  child: Image.asset(
                                    _images[index],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.10),
                                child: Text(
                                  caption[index],
                                  style: headline6,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
          SmoothPageIndicator(
            controller: _onboardController.pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: Color(0xFFDBD3FD),
              dotColor: Colors.grey[400]!,
              dotHeight: height * 0.012,
              dotWidth:width* 0.03,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            width:  width* 0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDBD3FD),
                padding: EdgeInsets.symmetric(vertical: height* 0.016),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: height* 0.022,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.020,
          ),

        ],
      )),
    );
  }
}
