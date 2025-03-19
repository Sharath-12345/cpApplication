

import 'package:call_log_new/call_log_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';





import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/LeadDetails.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:workmanager/workmanager.dart';

import '../TabBar/tab_bar.dart';


class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeController homeController= Get.find<HomeController>();
  final AuthController authController=Get.find<AuthController>();
  Iterable<CallLogResponse> callLogs = [];
  @override
   initState()  {
    fetchCallLogs();


  }


  void fetchCallLogs() async {
    try {
      final logs = await CallLog.fetchCallLogs();
      for (var log in logs)
        {
          print(log.number);
        }


    } catch (e) {
      print("Error fetching call logs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;



    homeController.getleads();
    homeController.getnewleads();
    homeController.getfollowleads();
    homeController.getvisitfixedleads();
    homeController.getvisitdoneleads();
    homeController.getnegotiationleads();
    return Obx(()=>
      Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0D0D0D),
          title:
          Text('Leads Manager', style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'SpaceGrotesk',
            fontSize: 22,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
            //height: 0.8461538461538461
          ),),

        ),
        backgroundColor: const Color(0xff0D0D0D),
        body: DefaultTabController(
          initialIndex: 0,
          length: 8,
          child: Padding(
            padding: EdgeInsets.fromLTRB(11, 0, 0, 8),
            child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [

                      SliverAppBar(
                        backgroundColor: Color(0xff0D0D0D),
                        expandedHeight: height*0.16,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.120,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.45,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(28, 28, 30, 1),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text("8", style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 1),

                                              fontSize: 17,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              //height: 0.8461538461538461
                                            ),),
                                            SizedBox(height: 4,),
                                            Text("Tasks", style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                              fontFamily: 'SpaceGrotesk',
                                              fontSize: 17,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              //height: 0.8461538461538461
                                            ),)
                                          ],
                                        ),
                                      )

                                  ),
                                  SizedBox(width: 9,),
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.45,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.120,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(89, 66, 60, 1),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text("${homeController.totalleads
                                                .toString()}", style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 1),

                                              fontSize: 17,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              //height: 0.8461538461538461
                                            ),),
                                            SizedBox(height: 4,),
                                            Text("Leads", style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                              fontFamily: 'SpaceGrotesk',
                                              fontSize: 17,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              //height: 0.8461538461538461
                                            ),),

                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                              SizedBox(height: height*0.01,)
                            ],
                          ),
                        ), // FlexibleSpaceBar
                      ),


                      SliverPersistentHeader(

                        pinned: true,
                        delegate: _TabBarDelegate(MyTabBar()),
                      ),
                    ];
                  },
                body:
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(Duration(seconds: 1),
                          );
                          setState(() {
          
                          });
                        },
                        child: ListView.builder(
                            itemCount: homeController.newleads.value,
                            itemBuilder:(context,index)
                            {
                              final single=homeController.newleadslist[index];
                              return InkWell(
                                onTap: ()
                                {
                                  Get.to(LeadDetailsScreen(), arguments: single);
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width*90,
                                    height: MediaQuery.of(context).size.height*0.1,
                                    decoration: BoxDecoration(
                                      color : Color.fromRGBO(28, 28, 30, 1),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${single['Name']}",style: TextStyle(
                                                  color: Colors.white,fontWeight: FontWeight.bold,
                                                  fontFamily: 'SpaceGrotesk'
                                              ),),
                                              Text("NA",style: TextStyle(
                                                  color: Colors.white,fontFamily: 'SpaceGrotesk'
                                              )),
                                              Text("new",style: TextStyle(
                                                  color: Colors.white,fontFamily: 'SpaceGrotesk'
                                              ))
                                            ],
                                          ),
                                          Spacer(),
                                          InkWell(
                                            child: Container(
                                                width: 55,
                                                height: 33,
                                                child:Center(child: Text("Call")),
                                                decoration: BoxDecoration(
                                                  color : Color.fromRGBO(255, 255, 255, 1),
                                                )
                                            ),
                                            onTap: ()
                                            {
                                              FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                            },
                                          )
                                        ],
                                      ),
                                    )
          
                                ),
                              );
                            }
          
                        ),
                      ),
                      ListView.builder(
                          itemCount: homeController.followupleads.value,
                          itemBuilder:(context,index)
                          {
                            final single=homeController.followupleadslist[index];
                            return InkWell(
                              onTap: ()
                              {
                                Get.to(()=>LeadDetailsScreen(),arguments:single);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width*90,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: BoxDecoration(
                                    color : Color.fromRGBO(28, 28, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${single['Name']}",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk'
                                            ),),
                                            Text("NA",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            )),
                                            Text("followup",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            ))
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: ()
                                          {
                                            FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                          },
                                          child: Container(
                                              width: 55,
                                              height: 33,
                                              child:Center(child: Text("Call")),
                                              decoration: BoxDecoration(
                                                color : Color.fromRGBO(255, 255, 255, 1),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
          
                              ),
                            );
                          }
          
                      ),
          
                      ListView.builder(
                          itemCount: homeController.visitfixedleads.value,
                          itemBuilder:(context,index)
                          {
                            final single=homeController.visitfixedleadslist[index];
                            return InkWell(
                              onTap: ()
                              {
                                Get.to(()=>LeadDetailsScreen(),arguments: single);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width*90,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: BoxDecoration(
                                    color : Color.fromRGBO(28, 28, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${single['Name']}",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk'
                                            ),),
                                            Text("NA",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            )),
                                            Text("visitfixed",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            ))
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: ()
                                          {
                                            FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                          },
                                          child: Container(
                                              width: 55,
                                              height: 33,
                                              child:Center(child: Text("Call")),
                                              decoration: BoxDecoration(
                                                color : Color.fromRGBO(255, 255, 255, 1),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
          
                              ),
                            );
                          }
          
                      ),
                      ListView.builder(
                          itemCount: homeController.visitdoneleads.value,
                          itemBuilder:(context,index)
                          {
                            final single=homeController.visitdoneleadslist[index];
                            return InkWell(
                              onTap: ()
                              {
                                Get.to(()=>LeadDetailsScreen(),arguments:single);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width*90,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: BoxDecoration(
                                    color : Color.fromRGBO(28, 28, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${single['Name']}",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk'
                                            ),),
                                            Text("NA",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            )),
                                            Text("visitdone",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            ))
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: ()
                                          {
                                            FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                          },
                                          child: Container(
                                              width: 55,
                                              height: 33,
                                              child:Center(child: Text("Call")),
                                              decoration: BoxDecoration(
                                                color : Color.fromRGBO(255, 255, 255, 1),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
          
                              ),
                            );
                          }
          
                      ),
                      ListView.builder(
                          itemCount: homeController.negotiationleads.value,
                          itemBuilder:(context,index)
                          {
                            final single=homeController.negotiationleadslist[index];
                            return InkWell(
                              onTap: ()
                              {
                                Get.to(()=>LeadDetailsScreen(),arguments: single);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width*90,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: BoxDecoration(
                                    color : Color.fromRGBO(28, 28, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${single['Name']}",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk'
                                            ),),
                                            Text("NA",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            )),
                                            Text("visitfixed",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            ))
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: ()
                                          {
                                            FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                          },
                                          child: Container(
                                              width: 55,
                                              height: 33,
                                              child:Center(child: Text("Call")),
                                              decoration: BoxDecoration(
                                                color : Color.fromRGBO(255, 255, 255, 1),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
          
                              ),
                            );
          
                          }
          
                      ),
                      ListView.builder(
                          itemCount: homeController.notintrestedleads.value,
                          itemBuilder:(context,index)
                          {
                            final single=homeController.notintrestedleadslist[index];
                            return InkWell(
                              onTap: ()
                              {
                                Get.to(()=>LeadDetailsScreen(),arguments: single);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width*90,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: BoxDecoration(
                                    color : Color.fromRGBO(28, 28, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 9, 23, 4),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${single['Name']}",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk'
                                            ),),
                                            Text("NA",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            )),
                                            Text("visitfixed",style: TextStyle(
                                                color: Colors.white,fontFamily: 'SpaceGrotesk'
                                            ))
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: ()
                                          {
                                            FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                          },
                                          child: Container(
                                              width: 55,
                                              height: 33,
                                              child:Center(child: Text("Call")),
                                              decoration: BoxDecoration(
                                                color : Color.fromRGBO(255, 255, 255, 1),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
          
                              ),
                            );
          
                          }
          
                      ),
                      Text("   "),
                      Text("   "),
                    ],
                  ),
                ),
          
          ),
                ),
        )
      ),
    );
  }
}
  class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  _TabBarDelegate(this.tabBar);
   var height;


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var height=MediaQuery.of(context).size.width;
    height=height;
    var width=MediaQuery.of(context).size.width;
  return Container(
  color: Colors.black, // Background color
  child: tabBar, // Use MyTabBar here
  );
  }

  @override
  double get maxExtent =>  MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height * 0.15;
  @override
  double get minExtent =>  MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height * 0.15;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
  }

