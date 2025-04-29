import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/TabBar/tab_bar.dart';
import 'package:saleapp/Screens/TabBar/tabbar_controller.dart';

import '../Profile/profile_controller.dart';


class MyTabBar extends StatelessWidget
{
  final HomeController homeController= Get.find<HomeController>();
  final  profileController = Get.find<ProfileController>();
  final TabBarController tabbarController= Get.put<TabBarController>(TabBarController());

  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.width;
    var width=MediaQuery.of(context).size.width;

    return     Obx(
      ()=>
       Padding(
         padding: const EdgeInsets.only(left: 2),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              onTap: homeController.chnageTabIndex,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              tabs: [

                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.newLeadsStream,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "New",
                        count: count,
                        tabIndex: 0,
                        homeController: homeController,
                        profileController:profileController
                      );
                    },
                  ),
                ),
                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.followupLeads,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "Followup",
                        count: count,
                        tabIndex: 1,
                        homeController: homeController,
                          profileController:profileController
                      );
                    },
                  ),
                ),
                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.visitfixedLeads,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "Visit Fixed",
                        count: count,
                        tabIndex: 2,
                        homeController: homeController,
                          profileController:profileController
                      );
                    },
                  ),
                ),

                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.visitdoneLeads,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "Visit Done",
                        count: count,
                        tabIndex: 3,
                        homeController: homeController,
                          profileController:profileController
                      );
                    },
                  ),
                ),

                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.negotiationsLeads,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "Negotiations",
                        count: count,
                        tabIndex: 4,
                        homeController: homeController,
                          profileController:profileController
                      );
                    },
                  ),
                ),

                Tab(
                  child: StreamBuilder<int>(
                    stream: homeController.notIntrestedLeads,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return CustomTab(
                        title: "Not Intrested",
                        count: count,
                        tabIndex: 5,
                        homeController: homeController,
                          profileController:profileController
                      );
                    },
                  ),
                ),


                Tab(
                  child:     Container(
                      height: MediaQuery.of(context).size.height* 0.055,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            //: homeController.tabIndex == 6
                            //?  Color.fromRGBO(89, 66, 60, 1)
                           // : Color.fromRGBO(30, 30, 30, 1),
                        Colors.white
                      ),
                      child:  Center(
                        child: Text("Projects",style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                      )
                  ),
                ),
                Tab(
                  child:  Container(
                      height: MediaQuery.of(context).size.height* 0.055,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                        //homeController.tabIndex == 7
                          //  ?  Color.fromRGBO(89, 66, 60, 1)
                            //: Color.fromRGBO(30, 30, 30, 1),
                        Colors.white
                      ),
                      child:  Center(
                        child: Text("Participants",style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                      )
                  ),

                )


              ],
             dividerColor:(profileController.isLightMode==true)?
                 Colors.white:
             Colors.black,
             labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor:(profileController.isLightMode==true)?
              Colors.white:
              Colors.black,
            ),
            SizedBox(height: height*0.03 ,),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: StreamBuilder<int>(
                stream: homeController.getCurrentTabStream(homeController.tabIndex.value, homeController),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Text(
                    'you have $count due events',
                    style: TextStyle(
                     color: (profileController.isLightMode==true)?
                      Colors.black:
                      Colors.white,
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              )

            ),
           // SizedBox(height: height*0.02 ,),

          ],
               ),
       ),
    );
  }

}




class CustomTab extends StatelessWidget {
  final String title;
  final int? count;
  final int tabIndex;
  final HomeController homeController;
  final ProfileController profileController;


  const CustomTab({
    Key? key,
    required this.title,
    this.count,
    required this.tabIndex,
    required this.homeController, required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> Container(
        height: MediaQuery.of(context).size.height * 0.07,


        width: (title=="Negotiations " || title=="NotIntrested") ?
        MediaQuery.of(context).size.width * 0.25:
        MediaQuery.of(context).size.width * 0.29,

        decoration: BoxDecoration(
          color:
          homeController.tabIndex == tabIndex
              ?( (profileController.isLightMode==true) ?
          Color(0xFFE6E0FA):
          Color.fromRGBO(89, 66, 60, 1)):
          ( (profileController.isLightMode==true) ?
          Color.fromRGBO(242, 242, 247, 1):
          Color.fromRGBO(28, 28, 30, 1)
          )


          //  Color.fromRGBO(30, 30, 30, 1),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (count != null) // Show count only if it's provided
                Text(
                  "$count",
                  style: TextStyle(
                    color:(profileController.isLightMode==true)?
                        Colors.black:
                    Colors.white,
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color:(profileController.isLightMode==true)?
                  Colors.black:
                  Colors.white,

                  fontFamily: 'SpaceGrotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







