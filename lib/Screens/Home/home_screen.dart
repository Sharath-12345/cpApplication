
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';





import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/LeadDetails.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController= Get.find<HomeController>();
  final AuthController authController=Get.find<AuthController>();
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    homeController.getleads();
    homeController.getnewleads();
    homeController.getfollowleads();
    homeController.getvisitfixedleads();
    homeController.getvisitdoneleads();
    homeController.getnegotiationleads();
    return Obx(()=>
      Scaffold(
        backgroundColor: const Color(0xff0D0D0D),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(11, 50, 0, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leads Manager', style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 22,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  //height: 0.8461538461538461
                ),),

                SizedBox(height: 6,),

                Row(
                  children: [
                    Container(

                        height: MediaQuery.of(context).size.height* 0.120,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(28, 28, 30, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("8",style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),

                                fontSize: 17,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                //height: 0.8461538461538461
                              ),),
                              SizedBox(height: 4,),
                              Text("Tasks",style: TextStyle(
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
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height* 0.120,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(89, 66, 60, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${homeController.totalleads.toString()}",style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),

                                fontSize: 17,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                //height: 0.8461538461538461
                              ),),
                              SizedBox(height: 4,),
                              Text("Leads",style: TextStyle(
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
                    )
                  ],
                ),

                SizedBox(height: 23,),
                 DefaultTabController(
                  length: 8,
                  initialIndex: 0,
                  child: Column(
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
                              height: MediaQuery.of(context).size.height* 0.07,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                  color: homeController.tabIndex == 0
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
                                color: homeController.tabIndex == 1
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
                                color: homeController.tabIndex == 2
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
                                color: homeController.tabIndex == 3
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
                                  color: homeController.tabIndex == 4
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
                                  color: homeController.tabIndex == 5
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
                                  color: homeController.tabIndex == 7
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
                      SizedBox(height: 15,),
                      Text('you have ${homeController.showingLeadsCount.value} due events', style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 22,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        //height: 0.8461538461538461
                      ),),

                      // TabBarView must be inside a constrained widget like Expanded
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.7,
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
                                                    // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                                                  // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                                                  // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                                                  // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                                                  // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                                                  // FlutterPhoneDirectCaller.callNumber(single['Mobile']);
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
                    ],
                  ),
                ),
              ],

          ),
                ),
        )
      ),
    );
  }
}