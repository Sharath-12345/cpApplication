

//import 'package:call_log_new/call_log_new.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_contacts/flutter_contacts.dart';





import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_projects.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/LeadDetails.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:saleapp/Screens/TaskRemainder/task_reminder_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../helpers/supaase_help.dart';
import '../Profile/profile_controller.dart';
import '../TabBar/tab_bar.dart';




class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{

  final HomeController homeController= Get.find<HomeController>();
  final AuthController authController=Get.find<AuthController>();
  final  profileController = Get.find<ProfileController>();



  Iterable<CallLogEntry> callLogs = <CallLogEntry>[
    CallLogEntry(name: "Loading...", number: "0000000000")
  ];
  var currentSelectedProject="";
  bool isReturningFromCall = false;



  var leadsphonenumberlist=[];

  @override
   initState()  {
    WidgetsBinding.instance.addObserver(this);
    //initAsync();
   fetchCallLogs();
   //matchAndStoreCallLogs();
  }
  Future<void> _initAsync() async {
    await fetchCallLogs();           // wait for this to complete
    //await matchAndStoreCallLogs();  // then call this
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App is going to background (call started)
      isReturningFromCall = true;
    } else if (state == AppLifecycleState.resumed && isReturningFromCall) {
      // App came back to foreground after call
      isReturningFromCall = false;

      Future.delayed(Duration(seconds: 2), () async {
        print("method started");
        callLogs = await CallLog.get();
        callLogs = callLogs.take(1).toList();
        print(callLogs.first.number);
        matchAndStoreCallLogs();

       // controller.currenttabvalue.value += 1;
      });
    }
  }





  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }


  Future<void> matchAndStoreCallLogs() async {

   print("Match And Store Started");
   await homeController.getleads();
    if(homeController.Totalleadslist!=null) {
      List<Map<String, dynamic>> matchedLogs = [];

      print("Control Came here");


      for (var call in callLogs) {
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

  Future<void> fetchCallLogs() async {
    print("Fetching Call Log Started");
    if (await Permission.phone.request().isGranted &&
        await Permission.contacts.request().isGranted) {
      try {




        callLogs = await CallLog.get();
        callLogs=callLogs.take(100).toList();

        print(callLogs.first);
       /*for (CallLogEntry entry in callLogs) {
          print(CallLogEntry);
          print('Number: ${entry.number}');
          print('Name: ${entry.name}');
          print('Type: ${entry.callType}');
          print('Date: ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)}');
          print('Duration: ${entry.duration} seconds');

          print('----------------------------------');
        }*/

       
        print("Call Logs fetched");
        await matchAndStoreCallLogs();














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
   // matchAndStoreCallLogs();


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
              backgroundColor:  (profileController.isLightMode==true)?
              Colors.white:Color(0xff0D0D0D),
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: InkWell(
                  onTap: ()
                  {
                  // sendCallNotification("Sharath", "8186039554", "foirbem1SsumzDCwvIJUDR:APA91bEFagYIXF1PJXYaOFX_hXqqyUM669LgPSsOGqk3GK5SoJ8pbS_QX2wpi1rlYKz3NM4a4_O0f6g2aKcV4jmRM-T17r1C8hlpVHKCwV5pd6MKDwImS3A");
                  },
                  child: Text(
                    'Leads Manager',
                    style: TextStyle(
                      color: (profileController.isLightMode==true)?
                     Colors.black:Colors.white,
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            backgroundColor: (profileController.isLightMode==true)? Colors.white :
            Color(0xff0D0D0D),
          body: DefaultTabController(
            initialIndex: 0,
            length: 8,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [

                        SliverAppBar(
                          backgroundColor:  (profileController.isLightMode==true)?
                          Colors.white:Color(0xff0D0D0D),
                          expandedHeight: height*0.14,
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
                                              color: (profileController.isLightMode==true)?

                                                Color.fromRGBO(242, 242, 247, 1):
                                              Color.fromRGBO(28, 28, 30, 1)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [

                                                  StreamBuilder<int>(
                                                    stream:homeController.totaltasksStream,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Text(
                                                          "0",
                                                          style: TextStyle(
                                                            color:(profileController.isLightMode==true) ?
                                                                Colors.black:
                                                            Colors.white,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        );
                                                      }

                                                      if (snapshot.hasError) {
                                                        return Text(
                                                          "0",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        );
                                                      }

                                                      return Text(
                                                        "${snapshot.data ?? 0}",
                                                        style: TextStyle(
                                                          color:(profileController.isLightMode==true) ?
                                                          Colors.black:
                                                          Colors.white,
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      );
                                                    },
                                                  ),





                                                  SizedBox(height: 4,),
                                                  Text("Tasks", style: TextStyle(
                                                    color:(profileController.isLightMode==true) ?
                                                    Colors.black:
                                                    Colors.white,
                                                    fontFamily: 'SpaceGrotesk',
                                                    fontSize: 17,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w600,
                                                    //height: 0.8461538461538461
                                                  ),)
                                                ],
                                              ),
                                            )

                                        ),
                                      ),
                                     Spacer(),
                                     // SizedBox(width: width*0.028,),
                                      Obx(
                                          ()=> Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.45,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.120,
                                            decoration: BoxDecoration(
                                              color:(profileController.isLightMode==true)?
                                              Color(0xFFE6E0FA):
                                              Color.fromRGBO(89, 66, 60, 1),

                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  StreamBuilder<int>(
                                                    stream: (homeController.filterApplied.value==false)?
                                                    homeController.totalLeadsStream:
                                                    homeController.totalLeadsFilteredStream,
                                                    builder: (context, snapshot) {
                                                      final total = snapshot.data ?? 0;
                                                      return Text(
                                                        "$total",
                                                        style: TextStyle(
                                                          color:(profileController.isLightMode==true) ?
                                                          Colors.black:
                                                          Colors.white,
                                                          fontSize: 17,
                                                          letterSpacing: 0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: 4,),
                                                  Text("Leads", style: TextStyle(
                                                    color:(profileController.isLightMode==true) ?
                                                    Colors.black:
                                                    Colors.white,
                                                    fontFamily: 'SpaceGrotesk',
                                                    fontSize: 17,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w600,
                                                    //height: 0.8461538461538461
                                                  ),),

                                                ],
                                              ),
                                            )
                                        ),
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(homeController.tabIndex.value<=5)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 4,bottom: 10),
                              child: StreamBuilder<int>(
                                stream: (homeController.filterApplied==false)?
                                homeController.getCurrentTabStream(homeController.tabIndex.value, homeController):
                                homeController.getCurrentTabStreamFiltered(homeController.tabIndex.value, homeController),
                                builder: (context, snapshot) {
                                  final count = snapshot.data ?? 0;
                                  return Text(
                                    'you have $count due events',
                                    style: TextStyle(
                                      color: (profileController.isLightMode==true)?
                                      Colors.black:
                                      Colors.white,
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: height*0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              )
                          ),
                          Spacer(),
                          Obx(() => InkWell(
                            onTap: () async {
                              String? selectedProject = await showBottomPopupProjects(context, currentSelectedProject);

                              if (selectedProject != null && selectedProject!="All Projects") {
                                // Apply filter logic
                                currentSelectedProject = selectedProject;
                                homeController.currentSelectedProject.value = selectedProject;
                                homeController.filterApplied.value = true;
                              } else {
                                currentSelectedProject = "";
                                homeController.currentSelectedProject.value = "";
                                homeController.filterApplied.value = false;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                                color: profileController.isLightMode ==true? Colors.white : Colors.grey[850],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    (homeController.currentSelectedProject.value.isNotEmpty)
                                        ? (homeController.currentSelectedProject.value.length >= 14
                                        ? "${homeController.currentSelectedProject.value.substring(0, 12)}.."
                                        : homeController.currentSelectedProject.value)
                                        : "Select Project",
                                    style: TextStyle(
                                      color: profileController.isLightMode == true ? Colors.black : Colors.white,
                                      fontSize: height * 0.016,
                                    ),
                                  ),

                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: profileController.isLightMode ==true? Colors.black : Colors.white,
                                  ),

                                ],
                              ),
                            ),
                          ))

                        ],
                      ),
                      SizedBox(height: height*0.02,),
                      Expanded(
                        child: TabBarView(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream:(homeController.filterApplied==false)? FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'new')
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                             FirebaseFirestore.instance
                            .collection("${authController.currentUserObj['orgId']}_leads")
                                 .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                stream: (homeController.filterApplied==false)?
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status',whereIn: [
                                  'followup','Followup',
                                ])
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                stream:(homeController.filterApplied==false)?
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'visitfixed')
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'visitfixed')
                                    .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                stream:(homeController.filterApplied==false)?
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'visitdone')
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'visitdone')
                                    .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                stream:(homeController.filterApplied==false)?
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'negotiations')
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'negotiations')
                                    .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                stream: (homeController.filterApplied==false)?
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'notintrested')
                                    .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots():
                                FirebaseFirestore.instance
                                    .collection("${authController.currentUserObj['orgId']}_leads")
                                    .where('Status', isEqualTo: 'notintrested')
                                    .where('Project', isEqualTo: homeController.currentSelectedProject.value)
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
                                      leadsList: docs, status: "Not Intrested");
                                }
                            ),
                            StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("${authController.currentUserObj['orgId']}_projects")
                            // .where("status", isEqualTo: "ongoing")
                                .snapshots(),
                            // stream: DbQuery.instanace.getStreamCombineTasks(),
                            builder: (context, snapshot) {
                              //     if (!snapshot.hasData) {
                              //   return CircularProgressIndicator();
                              // }
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Something went wrong! 😣..."),
                                );
                              } else if (snapshot.hasData) {
                                // lets seperate between business vs personal

                                var TotalTasks = snapshot.data!.docs.toList();

                             //   print('pub dev is ${TotalTasks}');
                               // print('pub dev isx ${controller2.currentUserObj['orgId']}');

                                // particpantsIdA

                                // return Text('Full Data');
                                return Column(
                                  children: [
                                    Expanded(
                                      child: MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: const BouncingScrollPhysics(),
                                              itemCount: snapshot.data?.docs.length,
                                              itemBuilder: (context, i) {
                                                var projData = snapshot.data?.docs[i];
                                                var unitCounts;
                                                try {
                                                  unitCounts = projData?['totalUnitCount'] ?? 0;
                                                } catch (e) {
                                                  unitCounts = 'NA';
                                                }

                                                return _buildSingleHouse(context, projData);
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('');
                              }
                            }),

                            Text("   "),
                          ],
                        ),
                      ),
                    ],
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
   final profileController=Get.find<ProfileController>();


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var height=MediaQuery.of(context).size.width;
    height=height;
    var width=MediaQuery.of(context).size.width;
  return Obx(
      ()=> Container(
    color:(profileController.isLightMode==true)? Colors.white: Colors.black, // Background color
    child: tabBar, // Use MyTabBar here
    ),
  );
  }

  @override
  double get maxExtent =>  MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height * 0.075;
  @override
  double get minExtent =>  MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height * 0.075;
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
  final profileController=Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {



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
                child: Obx(
                    ()=> Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*90,
                         // height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(
                            //  borderRadius: BorderRadius.circular(12),
                            color : (profileController.isLightMode==true)?
                            Color.fromRGBO(242, 242, 247, 1):
                            Color.fromRGBO(28, 28, 30, 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 23, 12),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (single['Name'] as String).length > 30
                                          ? "${(single['Name'] as String).substring(0, 30)}..."
                                          : single['Name'],
                                      style: TextStyle(
                                        color: profileController.isLightMode == true
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: 'SpaceGrotesk',
                                      ),
                                    ),

                                    Text("NA",style: TextStyle(
                                        color: (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white//,fontFamily: 'SpaceGrotesk'
                                        ,fontSize: 11
                                    )),
                                    Text(widget.status,style: TextStyle(
                                        color: (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,//fontFamily: 'SpaceGrotesk',
                                      fontSize: 12
                                    ))
                                  ],
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: ()
                                  {
                                    FlutterDirectCallerPlugin.callNumber(single['Mobile']);
                                  },
                                  child:Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Color(0xff58423B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )

                                          ),
                        Divider(color:
                        (profileController.isLightMode==false)?
                            Colors.black:
                        Colors.white,height: 5,)
                      ],
                    ),
                ),
              );
            }

        ),

    );
  }
}
Widget _buildSingleHouse(BuildContext context, projData) {
  final profile=Get.find<ProfileController>();
  String totalUnitCount =
  projData?.data()?.containsKey('totalUnitCount') == true
      ? projData['totalUnitCount'].toString()
      : '0';
  String soldUnitCount =
  projData?.data()?.containsKey('soldUnitCount') == true
      ? projData['soldUnitCount'].toString()
      : '0';

  return Card(

     color:(profile.isLightMode==true)? null:  Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: EdgeInsets.only(bottom: 20),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: InkWell(
      onTap: () {
        //Get.to(() => ProjectUnitScreen(projectDetails: projData));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projData?['projectName'] ?? '',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      projData?['projectType']?['name'] ?? '',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w600,
                        color: Colors.green, // Customize to your theme
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.withAlpha(180),
                    ),
                    SizedBox(width: 4),
                    Text(
                      projData?['location'] ?? '',

                      style: TextStyle(color: Colors.grey,
                        fontFamily: 'SpaceGrotesk',),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.king_bed,
                            size: 16,
                            color: Colors.grey.withAlpha(180),
                          ),
                          SizedBox(width: 4),
                          Text(
                            totalUnitCount,
                            style: TextStyle(color: Colors.grey,
                              fontFamily: 'SpaceGrotesk',),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bathtub,
                            size: 16,
                            color: Colors.grey.withAlpha(180),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${projData?['area'] ?? ''}',
                            style: TextStyle(color: Colors.grey,
                              fontFamily: 'SpaceGrotesk',),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: 16,
                            color: Colors.grey.withAlpha(180),
                          ),
                          SizedBox(width: 4),
                          Text(
                            soldUnitCount,
                            style: TextStyle(color: Colors.grey,
                              fontFamily: 'SpaceGrotesk',),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.aspect_ratio,
                            size: 16,
                            color: Colors.grey.withAlpha(180),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${projData?['area'] ?? ''}',
                            style: TextStyle(color: Colors.grey,
                              fontFamily: 'SpaceGrotesk',),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void sendCallNotification(String name, String number, String fcmToken) async {
  final url = 'https://us-central1-redefine-erp.cloudfunctions.net/sendPushNotification';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'number': number,
      'fcmToken': fcmToken,
    }),
  );

  print(response.body);
}

