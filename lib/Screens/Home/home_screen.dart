

import 'package:call_log_new/call_log_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_contacts/flutter_contacts.dart';






import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/LeadDetails.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:saleapp/Screens/TaskRemainder/task_reminder_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../helpers/supaase_help.dart';
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

  Iterable<CallLogResponse> callLogs = <CallLogResponse>[
    CallLogResponse(name: "Loading...", number: "0000000000")
  ];

  var leadsphonenumberlist=[];

  @override
   initState()  {
   fetchCallLogs();
   matchAndStoreCallLogs();
  }


  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }


  Future<void> matchAndStoreCallLogs() async {


    if(homeController.Totalleadslist!=null) {
      List<Map<String, dynamic>> matchedLogs = [];


      for (var call in callLogs!) {
        for (var lead in homeController.Totalleadslist) {
          if (call.number == lead['Mobile']) {
            print(call.number);
            matchedLogs.add({
              'call_log': call,
              'lead_id': lead.id
            });
          }
        }
      }



      DbSupa.instance.getLeadCallLogs(authController.currentUserObj['orgId'])
          .then((existingCallLogs) {
        if (!existingCallLogs.isEmpty) {
          for (var logandid in matchedLogs) {
            var log = logandid['call_log'];
            var lead_id = logandid['lead_id'];
            var existsInSupabase = existingCallLogs!.any((supabaseLog) =>
            supabaseLog['customerNo'] == log.number &&
                supabaseLog['startTime'] == log.timestamp
            );

            // If call log doesn't exist in Supabase, insert it
            // if (!existsInSupabase) {

            //  print(authController.currentUserObj['orgId']);
            //print(lead_id);
            //print(log.number);


            DbSupa.instance.addCallLog(
                authController.currentUserObj['orgId'], lead_id, log);
            //  }

          }
        } else {
          for (var logandid in matchedLogs) {
            var log = logandid['call_log'];
            var lead_id = logandid['lead_id'];
            DbSupa.instance.addCallLog(
                authController.currentUserObj['orgId'], lead_id, log);
          }
        }
      });
    }

  }

  void fetchCallLogs() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.contacts.request().isGranted) {
      try {

        callLogs = await CallLog.fetchCallLogs();
        callLogs=callLogs.take(30).toList();
        for(var sing in callLogs)
          {
           // print(sing.number);
          }


      } catch (e) {
        print("Error fetching call logs: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    final auth=Get.find<AuthController>();

    fetchCallLogs();
    matchAndStoreCallLogs();
    print("Home came");

    getToken();



    homeController.getleads();
    homeController.getnewleads();
    homeController.getfollowleads();
    homeController.getvisitfixedleads();
    homeController.getvisitdoneleads();
    homeController.getnegotiationleads();
    homeController.getnotintrestedleads();
    homeController.getTotalTasks();





    return Obx(()=>
      RefreshIndicator(
        onRefresh: () async {
      await Future.delayed(
      const Duration(seconds: 1),

      );
      setState(() {

      });

      },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff0D0D0D),
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  'Leads Manager',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 22,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            backgroundColor: const Color(0xff0D0D0D),
          body: DefaultTabController(
            initialIndex: 0,
            length: 8,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap : ()
                                       {
                                         Get.to(()=>TaskReminderScreen());
                                       },
                                        child: Container(
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
                                                  Obx(
                                                  ()=> Text("${homeController.totaltasks}", style: TextStyle(
                                                      color: Color.fromRGBO(255, 255, 255, 1),

                                                      fontSize: 17,
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.bold,
                                                      //height: 0.8461538461538461
                                                    ),),
                                                  ),
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
                                      ),
                                      SizedBox(width: width*0.028,),
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
                                                StreamBuilder<int>(
                                                  stream: homeController.totalLeadsStream,
                                                  builder: (context, snapshot) {
                                                    final total = snapshot.data ?? 0;
                                                    return Text(
                                                      "$total",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(255, 255, 255, 1),
                                                        fontSize: 17,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                                ),
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
                  RefreshIndicator(
                    onRefresh:() async {
                      await Future.delayed(
                        const Duration(seconds: 1),

                      );
                      setState(() {

                      });

                    } ,
                    child: SizedBox(

                      height: MediaQuery.of(context).size.height*0.5,
                      child: TabBarView(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status', isEqualTo: 'new')
                                  .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return LeadsListView(
                                    leadsList: docs, status: "New");
                              }
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status',whereIn: [
                                'followup','Followup',
                              ])
                                  .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return LeadsListView(
                                    leadsList: docs, status: "FollowUp");
                              }
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status', isEqualTo: 'visitfixed')
                                  .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return LeadsListView(
                                    leadsList: docs, status: "Visit Fixed");
                              }
                          ),

                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status', isEqualTo: 'visitdone')
                                  .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return LeadsListView(
                                    leadsList: docs, status: "Visit Done");
                              }
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status', isEqualTo: 'negotiations')
                                  .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return LeadsListView(
                                    leadsList: docs, status: "Negotiations");
                              }
                          ),

                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("${authController.currentUserObj['orgId']}_leads")
                                  .where('Status', isEqualTo: 'notintrested') // filter like your tab
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    //child: Text("No new leads")
                                  );
                                }

                                final docs = snapshot.data!.docs;
                                return  ListView.builder(
                                    itemCount: homeController.notintrestedleads.value,
                                    itemBuilder:(context,index)
                                    {
                                      final single=docs[index];
                                      return InkWell(
                                        onTap: ()
                                        {
                                          Get.to(()=>LeadDetailsScreen(), arguments: {
                                            "leaddetails" : single,

                                          });
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
                  ),
          )
        ),
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


class LeadsListView extends StatefulWidget {
  final List<QueryDocumentSnapshot> leadsList;
  final String status;

  const LeadsListView({super.key, required this.leadsList, required this.status});

  @override
  State<LeadsListView> createState() => _LeadsListViewState();
}

class _LeadsListViewState extends State<LeadsListView> {
  final HomeController homeController=Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
   homeController.getTotalTasks();

    homeController.getleads();
    homeController.getnewleads();
    homeController.getfollowleads();
    homeController.getvisitfixedleads();
    homeController.getvisitdoneleads();
    homeController.getnegotiationleads();
    homeController.getnotintrestedleads();


    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(
          const Duration(seconds: 1),

        );
        setState(() {

        });

      },
      child: ListView.builder(
          itemCount: widget.leadsList.length,
          itemBuilder:(context,index)
          {
            final single=widget.leadsList[index];
            return InkWell(
              onTap: ()
              {
                Get.to(()=>LeadDetailsScreen(), arguments: {
                  "leaddetails" : single,

                });
                setState(() {

                });
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
                            Text(widget.status,style: TextStyle(
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
    );
  }
}

