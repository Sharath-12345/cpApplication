import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/leaddetails_controller.dart';
import 'package:saleapp/Screens/LeadDetails/not_intrested_leads.dart';
import 'package:saleapp/Screens/LeadDetails/visitdone_leads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:call_log_new/call_log_new.dart';

import '../../helpers/supaase_help.dart';
import '../Profile/profile_controller.dart';

class LeadDetailsScreen extends StatefulWidget
{
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> with WidgetsBindingObserver {
  final HomeController homeController=Get.find<HomeController>();
  final AuthController authController=Get.find<AuthController>();
  final  profileController = Get.find<ProfileController>();
  var controller=Get.put<LeadDetailsController>(LeadDetailsController());
  var leadstatuschangecontroller=Get.put<StatusChangeLead>(StatusChangeLead());
  var argument = Get.arguments;



  final supabase = GetIt.instance<SupabaseClient>();




  var receivedList ;
  var calllogs;
  var currentStatus="new";
  Iterable<CallLogResponse> callLogs = <CallLogResponse>[
    CallLogResponse(name: "Loading...", number: "0000000000")
  ];
  bool isReturningFromCall = false;





  @override
  void initState() {
    super.initState();
    receivedList=argument["leaddetails"];
    WidgetsBinding.instance.addObserver(this);



    currentStatus="${receivedList['Status']}";
   controller.printRowsByLuid(receivedList.id);

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
        print("working");
        callLogs = await CallLog.fetchCallLogs();
        callLogs=callLogs.take(1).toList();
        print(callLogs.first.number);
        matchAndStoreCallLogs();
        controller.currenttabvalue.value+=1;
      });



    }
  }
  Future<void> matchAndStoreCallLogs() async {


    if(homeController.Totalleadslist!=null) {
      List<Map<String, dynamic>> matchedLogs = [];

      matchedLogs.add({
        'call_log': callLogs.first,
        'lead_id': receivedList.id
      });






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



  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    String fetchedText='${receivedList['Project']}';
    controller.printRowsByLuid(receivedList.id);
    print("This ${receivedList.id}");
    final stream = supabase
        .from('spark_lead_logs')
        .stream(primaryKey: ['id'])
        .eq('Luid', receivedList.id);







    return Obx(
        ()=> Scaffold(
            backgroundColor: (profileController.isLightMode==true)? Colors.white :
            Color(0xff0D0D0D),
        body: Padding(
          padding: EdgeInsets.fromLTRB(11, 45, 0, 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color:  (profileController.isLightMode==true)?
                        Color(0xff0D0D0D):
                            Colors.white
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 15,),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       StreamBuilder<DocumentSnapshot>(
                         stream: FirebaseFirestore.instance
                             .collection("${authController.currentUserObj['orgId']}_leads")
                             .doc(receivedList.id)
                             .snapshots(),
                         builder: (context, snapshot) {
                           if (snapshot.hasData && snapshot.data!.exists) {
                             final data = snapshot.data!.data() as Map<String, dynamic>;
                             final name = data['Name'] ?? '';
                             return Text(
                               "$name",
                               style: TextStyle(
                                 color:  (profileController.isLightMode==true)?
                                 Color(0xff0D0D0D):
                                 Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'SpaceGrotesk',
                                 fontSize: height*0.02,
                               ),
                             );
                           } else if (snapshot.connectionState == ConnectionState.waiting) {
                             return Text("Loading...", style: TextStyle(color: Colors.white));
                           } else {
                             return Text("No Name", style: TextStyle(color: Colors.white));
                           }
                         },
                       ),

                       SizedBox(height: 3,),
                       Row(
                         children: [
                           Container(
                             width: 7,
                             height: 7,
                             decoration: BoxDecoration(
                               color: Colors.green, // Green dot color
                               shape: BoxShape.circle, // Circular shape
                             ),
                           ),
                           SizedBox(width: 3,),
                           StreamBuilder<DocumentSnapshot>(
                             stream: FirebaseFirestore.instance
                                 .collection("${authController.currentUserObj['orgId']}_leads")
                                 .doc(receivedList.id)
                                 .snapshots(),
                             builder: (context, snapshot) {
                               if (snapshot.hasData && snapshot.data!.exists) {
                                 final data = snapshot.data!.data() as Map<String, dynamic>;
                                 final name = data['Mobile'] ?? '';
                                 return Text(
                                   "$name",
                                   style: TextStyle(
                                     color:  (profileController.isLightMode==true)?
                                     Color(0xff0D0D0D):
                                     Colors.white,
                                   //  fontWeight: FontWeight.bold,
                                     fontFamily: 'SpaceGrotesk',
                                     fontSize: height*0.016,
                                   ),
                                 );
                               } else if (snapshot.connectionState == ConnectionState.waiting) {
                                 return Text("Loading...", style: TextStyle(color: Colors.white));
                               } else {
                                 return Text("No Name", style: TextStyle(color: Colors.white));
                               }
                             },
                           ),
                         ],
                       ),

                     ],
                   ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: InkWell(
                        onTap: ()
                        async {
                          FlutterDirectCallerPlugin.callNumber(receivedList['Mobile']);

                        },
                        child: Container(
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
                      ),
                    )

                  ],
                ),
                SizedBox(height: 20,),

                DefaultTabController(
                    length: 6,
                    initialIndex: 0,

                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("${authController.currentUserObj['orgId']}_leads")
                                .doc(receivedList.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator()); // Show loading while waiting
                              }

                              if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(child: Text("No lead data found."));
                              }

                              final data = snapshot.data!.data() as Map<String, dynamic>;
                              final currentStatus = (data['Status'] ?? 'new').toString().toLowerCase();

                              return TabBar(
                                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                dividerColor:(profileController.isLightMode==true)?
                                Colors.white:
                                Colors.black,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor:(profileController.isLightMode==true)?
                                Colors.white:
                                Colors.black,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                tabs: [
                                  Tab(child: InkWell(
                                    onTap: () {
                                      if (currentStatus != "new") {
                                        showBottomPopup(context, "New", receivedList);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white, width: 2),
                                      ),
                                      child: Text("New", style: TextStyle(
                                        color: currentStatus == "new" ? Colors.green :
                                        (profileController.isLightMode==true)?
                                            Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                      )),
                                    ),
                                  )),
                                  Tab(child: InkWell(
                                    onTap: () {
                                      if (currentStatus != "followup") {
                                        showBottomPopup(context, "Followup", receivedList);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white, width: 2),
                                      ),
                                      child: Text("Followup", style: TextStyle(
                                        color: currentStatus == "followup" ? Colors.green :  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                      )),
                                    ),
                                  )),
                                  Tab(child: InkWell(
                                    onTap: () {
                                      if (currentStatus != "visitfixed") {
                                        showBottomPopup(context, "Visit Fixed", receivedList);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white, width: 2),
                                      ),
                                      child: Text("Visit Fixed", style: TextStyle(
                                        color: currentStatus == "visitfixed" ? Colors.green :  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                      )),
                                    ),
                                  )),
                                  Tab(child: InkWell(
                                    onTap: () {
                                      Get.to(() => VisitDoneLeads(), arguments: receivedList);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white, width: 2),
                                      ),
                                      child: Text("Visit Done", style: TextStyle(
                                        color: currentStatus == "visitdone" ? Colors.green :  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                      )),
                                    ),
                                  )),
                                  Tab(child: InkWell(
                                    onTap: () {
                                      Get.to(() => NotIntrestedLeads(), arguments: receivedList);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white, width: 2),
                                      ),
                                      child: Text("Not Intrested", style: TextStyle(
                                        color: currentStatus == "notintrested" ? Colors.green :  (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                      )),
                                    ),
                                  )),
                                  Tab(child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color:  (profileController.isLightMode==true)?
                                      Colors.black:
                                      Colors.white, width: 2),
                                    ),
                                    child: Text("Junk", style: TextStyle(
                                      color:  (profileController.isLightMode==true)?
                                      Colors.black:
                                      Colors.white,
                                      fontFamily: 'SpaceGrotesk',
                                    )),
                                  )),
                                ],
                              );
                            },
                          )

                        ]
                    )
                ),





                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.46,
                      height:  MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                        color :
                        (profileController.isLightMode==true)?
                        Color.fromRGBO(242, 242, 247, 1):
                        Color.fromRGBO(28, 28, 30, 1),
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(

                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: Container(
                                  child:Padding(
                                    padding:  EdgeInsets.fromLTRB(12, 8, 12, 8),
                                    child: Text("P",style: TextStyle(
                                        color:
                                        (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                    fontWeight: FontWeight.bold,fontSize: 12),
                                    ),
                                  ),
                                  decoration: BoxDecoration(

                                    color :(profileController.isLightMode==true)?
                                    Color(0xFFE6E0FA):
                                    Color.fromRGBO(89, 66, 60, 1),
                                  ),
                                ),
                              )
                              ,SizedBox(width: 8,),
                              Padding(
                                padding:EdgeInsets.fromLTRB(0, 10, 5, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text( fetchedText.length > 15
                                ? '${fetchedText.substring(0, 12)}...'  // Show first 12 characters + "..."
                                : fetchedText,
                                      style: TextStyle(
                                      color:
                                      (profileController.isLightMode==true)?
                                          Colors.black:
                                      Colors.white,fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily: 'SpaceGrotesk',

                                    ),),
                                    Text("Project",style: TextStyle(
                                        color:
                                        (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                      fontFamily: 'SpaceGrotesk',
                                       fontSize: 10
                                    ),),



                                  ],
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.46,
                      height:  MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                        color :
                        (profileController.isLightMode==true)?
                        Color.fromRGBO(242, 242, 247, 1):
                        Color.fromRGBO(28, 28, 30, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(

                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: Container(
                                  child:Padding(
                                    padding:  EdgeInsets.fromLTRB(12, 8, 12, 8),
                                    child: Text("E",style: TextStyle(
                                        color:
                                        (profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontWeight: FontWeight.bold,fontSize: 12),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color :(profileController.isLightMode==true)?
                                    Color(0xFFE6E0FA):
                                    Color.fromRGBO(89, 66, 60, 1),
                                  ),
                                ),
                              )
                              ,SizedBox(width: 8,),
                              Padding(
                                padding:EdgeInsets.fromLTRB(0, 10, 5, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("${receivedList['assignedToObj']['roles'][0]}",style: TextStyle(
                                      color :(profileController.isLightMode==true)?
                                      Colors.black:
                                      Colors.white,fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily: 'SpaceGrotesk',

                                    ),),
                                    Text("Executive",style: TextStyle(
                                        color :(profileController.isLightMode==true)?
                                        Colors.black:
                                        Colors.white,
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 10
                                    ),),



                                  ],
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Obx(
                  ()=> DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: controller.chnageTabIndex,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          dividerColor:(profileController.isLightMode==true)?
                          Colors.white:
                          Colors.black,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor:(profileController.isLightMode==true)?
                          Colors.white:
                          Colors.black,

                          tabs: [
                            Tab(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.20,
                                decoration: BoxDecoration(
                                    color:
                                    controller.tabIndex==0
                                        ?( (profileController.isLightMode==true) ?
                                    Color(0xFFE6E0FA):
                                    Color.fromRGBO(89, 66, 60, 1)):
                                    ( (profileController.isLightMode==true) ?
                                    Color.fromRGBO(242, 242, 247, 1):
                                    Color.fromRGBO(28, 28, 30, 1)
                                    ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("${authController.currentUserObj['orgId']}_leads_sch")
                                              .doc(receivedList.id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData || !snapshot.data!.exists) {
                                              return Text(
                                                '0',
                                                style: TextStyle(
                                                  color: profileController.isLightMode == true ? Colors.black : Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }

                                            final data = snapshot.data!.data() as Map<String, dynamic>;
                                            int pendingCount = 0;

                                            data.forEach((key, value) {
                                              if (value is Map<String, dynamic> && value['sts'] == 'pending') {
                                                pendingCount++;
                                              }
                                            });

                                            // ✅ Safe update after build completes
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              controller.totaltasksvalue.value = pendingCount;
                                            });

                                            return Text(
                                              '$pendingCount',
                                              style: TextStyle(
                                                color: profileController.isLightMode == true ? Colors.black : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),


                                        Text("Tasks",
                                            style: TextStyle(
                                                color:
                                                (profileController.isLightMode==true)?
                                                Colors.black:
                                                Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk',
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.23,
                                decoration: BoxDecoration(
                                  color: controller.tabIndex == 1
                                      ? (profileController.isLightMode == true
                                      ? Color(0xFFE6E0FA)
                                      : Color.fromRGBO(89, 66, 60, 1))
                                      : (profileController.isLightMode == true
                                      ? Color.fromRGBO(242, 242, 247, 1)
                                      : Color.fromRGBO(28, 28, 30, 1)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// 👉 Replace Obx with StreamBuilder to show dynamic length
                                        StreamBuilder<List<Map<String, dynamic>>>(
                                          stream: controller.getCallLogsStream(receivedList.id),
                                          builder: (context, snapshot) {

                                            int count = snapshot.data?.length ?? 0;
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                             // controller.totalcalllogsvalue.value = count;
                                            });

                                            return Text(
                                              "$count",
                                              style: TextStyle(
                                                color: profileController.isLightMode == true
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),

                                        Text(
                                          "Call log",
                                          style: TextStyle(
                                            color: profileController.isLightMode == true
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Tab(
                              child: Container(
                                //height: MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.23,
                                decoration: BoxDecoration(
                                  color:
                                  controller.tabIndex==2
                                      ?( (profileController.isLightMode==true) ?
                                  Color(0xFFE6E0FA):
                                  Color.fromRGBO(89, 66, 60, 1)):
                                  ( (profileController.isLightMode==true) ?
                                  Color.fromRGBO(242, 242, 247, 1):
                                  Color.fromRGBO(28, 28, 30, 1)
                                  ),),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(7, 4, 10, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder<List<Map<String, dynamic>>>(
                                    stream: stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text(
                                          '0',
                                          style: TextStyle(
                                            color: profileController.isLightMode ==true? Colors.black : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return Text(
                                          '0',
                                          style: TextStyle(
                                            color: profileController.isLightMode ==true? Colors.black : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                      var filteredData = snapshot.data!;
                                      filteredData = snapshot.data!
                                          .where((item) => item['type'] == 'sts_change')
                                          .toList();
                                      var count=filteredData.length;
                                      controller.totalactivityvalue.value=filteredData.length;

                                      return Obx(
                                        ()=> Text(
                                          "${count}",
                                          style: TextStyle(
                                            color: profileController.isLightMode==true ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                    ),

                                        Text("Activity",
                                            style: TextStyle(
                                                color:
                                                (profileController.isLightMode==true)?
                                                Colors.black:
                                                Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceGrotesk',
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                       // SizedBox(height:height*0.02 ),


                        SizedBox(
                          height: height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:height*0.01 ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('you have ', style: TextStyle(
                                      color:
                                      (profileController.isLightMode==true)?
                                      Colors.black:
                                      Color.fromRGBO(255, 255, 255, 1),
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      //height: 0.8461538461538461
                                    ),),
                                    Obx(
                                          ()=> Text(
                                        " ${controller.currenttabvalue.value}"
                                        , style: TextStyle(
                                        color: Colors.orange,
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        //height: 0.8461538461538461
                                      ),),
                                    ),
                                    Text( ' due events', style: TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      //height: 0.8461538461538461
                                    ),)
                                  ],
                                ),
                              ),

                              Expanded(
                                child: TabBarView(
                                  children: [

                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('${authController.currentUserObj['orgId']}_leads_sch')
                                          .doc(receivedList.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return SizedBox.shrink();
                                        }

                                        if (!snapshot.hasData || !snapshot.data!.exists) {
                                          return SizedBox.shrink();
                                        }

                                        final data = snapshot.data!.data() as Map<String, dynamic>;
                                        List<String> pendingNotes = [];

                                        data.forEach((key, value) {
                                          if (value is Map<String, dynamic> && value['sts'] == 'pending') {
                                            pendingNotes.add(value['notes'] ?? '');
                                          }
                                        });


                                        if (pendingNotes.isEmpty) {
                                          return SizedBox.shrink();
                                        }

                                        return ListView.builder(
                                          padding: const EdgeInsets.only(top: 12),

                                          itemCount: pendingNotes.length,

                                          itemBuilder: (context, index) {
                                            return   Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                width: width*0.9,
                                               // height: height*0.08,
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color:(profileController.isLightMode==true)?
                                                  Color.fromRGBO(242, 242, 247, 1):
                                                  Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(16),
                                                    bottomLeft: Radius.circular(16),
                                                    bottomRight: Radius.circular(16),

                                                  ),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        pendingNotes[index],
                                                        style: TextStyle(fontSize: height*0.016, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    StreamBuilder<List<Map<String, dynamic>>>(
                                      stream: controller.getCallLogsStream(receivedList.id), // pass LUID here
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        }

                                        if (snapshot.hasError) {
                                          return Center(child: Text("Error: ${snapshot.error}"));
                                        }

                                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return Center(child: Text("No call logs found"));
                                        }

                                        final logs = snapshot.data!;

                                        return ListView.builder(
                                          padding: const EdgeInsets.only(top: 12),
                                          itemCount: logs.length,
                                          itemBuilder: (context, index) {
                                            final singlelog = logs[index];
                                            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(singlelog['startTime'].toInt());


                                            String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: profileController.isLightMode == true
                                                        ? Color.fromRGBO(242, 242, 247, 1)
                                                        : Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  height: height * 0.08,
                                                  width: width * 0.9,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: Row(
                                                      children: [
                                                        Text("${singlelog['type']}"),
                                                        SizedBox(width: width * 0.02),
                                                        Text("${singlelog['duration']}s"),
                                                        Spacer(),
                                                        Text(formattedDate),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: profileController.isLightMode == false
                                                      ? Colors.black
                                                      : Colors.white,
                                                  height: 6,
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    StreamBuilder<List<Map<String, dynamic>>>(
                                                stream: stream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Container();
                                                  }

                                                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                    return Text('No data found');
                                                  }

                                                  var filteredData = snapshot.data!;
                                                filteredData = snapshot.data!
                                                      .where((item) => item['type'] == 'sts_change')
                                                      .toList();
                                                controller.activitycount.value=filteredData.length;

                                                  return ListView.builder(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    itemCount: filteredData.length,
                                                    itemBuilder: (context, index) {
                                                      final item = filteredData[index];

                                                    return  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                width: width*0.9,
                                //height: height*0.08,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:(profileController.isLightMode==true)?
                                  Color.fromRGBO(242, 242, 247, 1):
                                  Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),

                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                       "Changed Status from ${item['from']} to ${item['to']}",
                                        style: TextStyle(fontSize: height*0.016, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                                        ),
                                                        Divider(color: (profileController.isLightMode==false)?
                                  Colors.black:
                                                        Colors.white,
                                                        height: 6,)
                                                      ],
                                                    );
                                                    },
                                                  );
                                                },
                                                ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),






               SizedBox(height: 5,),

               /* SizedBox(height: 15,),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0), // No rounding on the top-left corner
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.fromLTRB(18, 10, 8, 5),
                              child: Text(
                                "Make a followup call to MytApi3",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SpaceGrotesk'
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.fromLTRB(38, 0, 8, 8),
                              child: Text(
                                "28-10-22 16:30 2 years ago",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),

                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),

                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0), // No rounding on the top-left corner
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.fromLTRB(18, 10, 8, 5),
                              child: Text(
                                "Get into Introduction Call with customer",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SpaceGrotesk'
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.fromLTRB(38, 0, 8, 8),
                              child: Text(
                                "28-10-22 04:03 3 years ago",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),

                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0), // No rounding on the top-left corner
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:EdgeInsets.fromLTRB(18, 10, 8, 5),
                          child: Text(
                            "Make a followup call to MytApi3",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SpaceGrotesk'
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.fromLTRB(38, 0, 8, 8),
                          child: Text(
                            "28-10-22 16:30 2 years ago",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4),

                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            */
              ],
                 ),
          ),
        ) ,
      ),
    );
  }
}