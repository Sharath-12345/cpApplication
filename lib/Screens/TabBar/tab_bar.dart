import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/TabBar/tabbar_controller.dart';


class MyTabBar extends StatelessWidget
{
  final HomeController homeController= Get.find<HomeController>();
  final TabBarController tabbarController= Get.put<TabBarController>(TabBarController());

  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.width;
    var width=MediaQuery.of(context).size.width;

    return     Obx(
      ()=>
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            onTap: homeController.chnageTabIndex,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            tabs: [
              Tab(
                child:  Container(
                    height: MediaQuery.of(context).size.height* 0.09,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color:  homeController.tabIndex == 0
                          ?  Color.fromRGBO(89, 66, 60, 1)
                          : Color.fromRGBO(30, 30, 30, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${homeController.newleads.toString()}",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),),
                          SizedBox(height: 2,),
                          Text("New",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),)
                        ],
                      ),
                    )
                ),),
              Tab(child:  Container(
                  height: MediaQuery.of(context).size.height* 0.07,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color:  homeController.tabIndex == 1
                        ?  Color.fromRGBO(89, 66, 60, 1)
                        : Color.fromRGBO(30, 30, 30, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${homeController.followupleads.toString()}",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                        SizedBox(height: 2,),
                        Text("Followup",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),)
                      ],
                    ),
                  )
              ),),
              Tab(child:  Container(
                  height: MediaQuery.of(context).size.height* 0.07,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color:  homeController.tabIndex == 2
                        ?  Color.fromRGBO(89, 66, 60, 1)
                        : Color.fromRGBO(30, 30, 30, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${homeController.visitfixedleads.toString()}",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                        SizedBox(height: 2,),
                        Text("Visit Fixed",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),)
                      ],
                    ),
                  )
              ),),
              Tab(child:  Container(
                  height: MediaQuery.of(context).size.height* 0.07,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color:  homeController.tabIndex == 3
                        ?  Color.fromRGBO(89, 66, 60, 1)
                        : Color.fromRGBO(30, 30, 30, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${homeController.visitdoneleads.toString()}",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                        SizedBox(height: 2,),
                        Text("Vist Done",style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),)
                      ],
                    ),
                  )
              ),
              ),
              Tab(

                child:  Container(
                    height: MediaQuery.of(context).size.height* 0.07,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color:  homeController.tabIndex == 4
                          ?  Color.fromRGBO(89, 66, 60, 1)
                          : Color.fromRGBO(30, 30, 30, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${homeController.negotiationleads.toString()}",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),),
                          SizedBox(height: 2,),
                          Text("Negotiations",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),)
                        ],
                      ),
                    )
                ),),
              Tab(

                child:  Container(
                    height: MediaQuery.of(context).size.height* 0.07,
                    width: MediaQuery.of(context).size.width * 0.27,
                    decoration: BoxDecoration(
                      color:  homeController.tabIndex == 5
                          ?  Color.fromRGBO(89, 66, 60, 1)
                          : Color.fromRGBO(30, 30, 30, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${homeController.notintrestedleads.toString()}",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),),
                          SizedBox(height: 2,),
                          Text("Not Intrested",style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            //height: 0.8461538461538461
                          ),)
                        ],
                      ),
                    )
                ),),


              Tab(
                child:     Container(
                    height: MediaQuery.of(context).size.height* 0.07,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: homeController.tabIndex == 6
                          ?  Color.fromRGBO(89, 66, 60, 1)
                          : Color.fromRGBO(30, 30, 30, 1),
                    ),
                    child:  Center(
                      child: Text("Projects",style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
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
                    height: MediaQuery.of(context).size.height* 0.07,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color:  homeController.tabIndex == 7
                          ?  Color.fromRGBO(89, 66, 60, 1)
                          : Color.fromRGBO(30, 30, 30, 1),
                    ),
                    child:  Center(
                      child: Text("Participants",style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
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
            dividerColor: Colors.black,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
          SizedBox(height: height*0.03 ,),
          Text('you have ${homeController.showingLeadsCount} due events', style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'SpaceGrotesk',
            fontSize: 22,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
            //height: 0.8461538461538461
          ),),
          SizedBox(height: height*0.03 ,),

        ],
      ),
    );
  }

}