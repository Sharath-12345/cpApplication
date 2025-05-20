import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:intl/intl.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/leaddetails_controller.dart';
import 'package:saleapp/Screens/LeadDetails/not_intrested_leads.dart';
import 'package:saleapp/Screens/LeadDetails/visitdone_leads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:omni_datetime_picker/omni_datetime_picker.dart';
//import 'package:call_log_new/call_log_new.dart';
import 'package:call_log/call_log.dart';

import '../../helpers/supaase_help.dart';
import '../Profile/profile_controller.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen>
    with WidgetsBindingObserver {
  final HomeController homeController = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();
  final profileController = Get.find<ProfileController>();
  var controller = Get.put<LeadDetailsController>(LeadDetailsController());
  var leadstatuschangecontroller = Get.put<StatusChangeLead>(
    StatusChangeLead(),
  );
  var argument = Get.arguments;

  final supabase = GetIt.instance<SupabaseClient>();

  var receivedList;
  var calllogs;
  var currentStatus = "new";
  Iterable<CallLogEntry> callLogs = <CallLogEntry>[
    CallLogEntry(name: "Loading...", number: "0000000000"),
  ];
  bool isReturningFromCall = false;

  @override
  void initState() {
    super.initState();
    receivedList = argument["leaddetails"];
    WidgetsBinding.instance.addObserver(this);

    currentStatus = "${receivedList['Status']}";
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
        print("method started");
        callLogs = await CallLog.get();
        callLogs = callLogs.take(1).toList();
        print(callLogs.first.number);
        matchAndStoreCallLogs();

        controller.currenttabvalue.value += 1;
      });
    }
  }







  Future<void> matchAndStoreCallLogs() async {
    if (homeController.Totalleadslist != null) {
      List<Map<String, dynamic>> matchedLogs = [];
      print("Method started for match and store logs");

      print("here");

      if(receivedList['Mobile']==callLogs.first.number)
        {
          matchedLogs.add({
            'call_log': callLogs.first,
            'lead_id': receivedList.id
          });
          print("Added in matched list");
        }


     /* for (var call in callLogs) {
        for (var lead in homeController.Totalleadslist) {
          if (call.number == lead['Mobile']) {
           // print(call.number);
            print("Added in matching call");
            matchedLogs.add({
              'call_log': call,
              'lead_id': lead.id
            });
          }
        }
      }*/


      //matchedLogs.add({'call_log': callLogs.first, 'lead_id': receivedList.id});
      int? durationTime=0;
      durationTime=callLogs.first.duration;

      print("Matching list length :${matchedLogs.length}");

      DbSupa.instance
          .getLeadCallLogs(authController.currentUserObj['orgId'])
          .then((existingCallLogs) {
            if (!existingCallLogs.isEmpty) {
              for (var logandid in matchedLogs) {
                var log = logandid['call_log'];
                var lead_id = logandid['lead_id'];
                var existsInSupabase = existingCallLogs!.any(
                  (supabaseLog) =>
                      supabaseLog['customerNo'] == log.number &&
                      supabaseLog['startTime'] == log.timestamp,
                );



               // saveByDayWeekMonth(log['duration']);
                // If call log doesn't exist in Supabase, insert it


                DbSupa.instance.addCallLog(
                  authController.currentUserObj['orgId'],
                  lead_id,
                  log,
                );
               // saveByDayWeekMonth(durationTime!);
                //print("Duration is : ${durationTime}");




                //  }
              }
            } else {
              for (var logandid in matchedLogs) {
                var log = logandid['call_log'];
                var lead_id = logandid['lead_id'];
                DbSupa.instance.addCallLog(
                  authController.currentUserObj['orgId'],
                  lead_id,
                  log,
                );
                //saveByDayWeekMonth(durationTime!);




              }
            }
          });
    }
    else
      {
        print("Total lead list empty");
      }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String fetchedText = '${receivedList['Project']}';
    controller.printRowsByLuid(receivedList.id);
    print("This ${receivedList.id}");
    final stream = supabase
        .from('${authController.currentUserObj['orgId']}_lead_logs')
        .stream(primaryKey: ['id'])
        .eq('Luid', receivedList.id);

    return Obx(
      () => Scaffold(
        backgroundColor:
            (profileController.isLightMode == true)
                ? Colors.white
                : Color(0xff0D0D0D),
        body: Padding(
          padding: EdgeInsets.fromLTRB(11, 45, 0, 8),
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
                      color:
                          (profileController.isLightMode == true)
                              ? Color(0xff0D0D0D)
                              : Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection(
                                  "${authController.currentUserObj['orgId']}_leads",
                                )
                                .doc(receivedList.id)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final name = data['Name'] ?? '';
                            return Text(
                              "$name",
                              style: GoogleFonts.outfit(
                                color:
                                    (profileController.isLightMode == true)
                                        ? Color(0xff0D0D0D)
                                        : Colors.white,
                                fontWeight: FontWeight.bold,
                                // fontFamily: 'SpaceGrotesk',
                                fontSize: height * 0.02,
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: GoogleFonts.outfit(color: Colors.white),
                            );
                          } else {
                            return Text(
                              "No Name",
                              style: GoogleFonts.outfit(color: Colors.white),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 3),
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
                          SizedBox(width: 3),
                          StreamBuilder<DocumentSnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection(
                                      "${authController.currentUserObj['orgId']}_leads",
                                    )
                                    .doc(receivedList.id)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.exists) {
                                final data =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;
                                final name = data['Mobile'] ?? '';
                                return Text(
                                  "$name",
                                  style: GoogleFonts.outfit(
                                    color:
                                        (profileController.isLightMode ==
                                                true)
                                            ? Color(0xff0D0D0D)
                                            : Colors.white,
                                    //  fontWeight: FontWeight.bold,
                                    // fontFamily: 'SpaceGrotesk',
                                    fontSize: height * 0.016,
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  "Loading...",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text(
                                  "No Name",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                  ),
                                );
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
                      onTap: () async {
                        FlutterDirectCallerPlugin.callNumber(
                          receivedList['Mobile'],
                        );
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
                  ),
                ],
              ),
              SizedBox(height: 20),

              DefaultTabController(
                length: 6,
                initialIndex: 0,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection(
                                "${authController.currentUserObj['orgId']}_leads",
                              )
                              .doc(receivedList.id)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          ); // Show loading while waiting
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Center(child: Text("No lead data found."));
                        }

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final currentStatus =
                            (data['Status'] ?? 'new')
                                .toString()
                                .toLowerCase();

                        return TabBar(
                          labelPadding: EdgeInsets.symmetric(horizontal: 5),
                          dividerColor:
                              (profileController.isLightMode == true)
                                  ? Colors.white
                                  : Colors.black,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor:
                              (profileController.isLightMode == true)
                                  ? Colors.white
                                  : Colors.black,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              child: InkWell(
                                onTap: () {
                                  if (currentStatus != "new") {
                                    showBottomPopup(
                                      context,
                                      "New",
                                      receivedList,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "New",
                                    style: GoogleFonts.outfit(
                                      color:
                                          currentStatus == "new"
                                              ? Colors.green
                                              : (profileController
                                                      .isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: InkWell(
                                onTap: () {
                                  if (currentStatus != "followup") {
                                    showBottomPopup(
                                      context,
                                      "Followup",
                                      receivedList,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "Followup",
                                    style: GoogleFonts.outfit(
                                      color:
                                          currentStatus == "followup"
                                              ? Colors.green
                                              : (profileController
                                                      .isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: InkWell(
                                onTap: () {
                                  if (currentStatus != "visitfixed") {
                                    showBottomPopup(
                                      context,
                                      "Visit Fixed",
                                      receivedList,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "Visit Fixed",
                                    style: GoogleFonts.outfit(
                                      color:
                                          currentStatus == "visitfixed"
                                              ? Colors.green
                                              : (profileController
                                                      .isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: InkWell(
                                onTap: () {
                                  if(currentStatus!="visitdone") {
                                    Get.to(
                                          () => VisitDoneLeads(),
                                      arguments: receivedList,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "Visit Done",
                                    style: GoogleFonts.outfit(
                                      color:
                                          currentStatus == "visitdone"
                                              ? Colors.green
                                              : (profileController
                                                      .isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: InkWell(
                                onTap: () {
                                  if(currentStatus!="notintrested") {
                                    Get.to(

                                          () => NotIntrestedLeads(),
                                      arguments: receivedList,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "Not Intrested",
                                    style: GoogleFonts.outfit(
                                      color:
                                          currentStatus == "notintrested"
                                              ? Colors.green
                                              : (profileController
                                                      .isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        (profileController.isLightMode ==
                                                true)
                                            ? Colors.black
                                            : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Junk",
                                  style: GoogleFonts.outfit(
                                    color:
                                        (profileController.isLightMode ==
                                                true)
                                            ? Colors.black
                                            : Colors.white,
                                    // fontFamily: 'SpaceGrotesk',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      color:
                          (profileController.isLightMode == true)
                              ? Color.fromRGBO(242, 242, 247, 1)
                              : Color.fromRGBO(28, 28, 30, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  child: Text(
                                    "P",
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (profileController.isLightMode == true)
                                          ? Color(0xFFE6E0FA)
                                          : Color.fromRGBO(89, 66, 60, 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fetchedText.length > 15
                                        ? '${fetchedText.substring(0, 12)}...' // Show first 12 characters + "..."
                                        : fetchedText,
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                  Text(
                                    "Project",
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      color:
                          (profileController.isLightMode == true)
                              ? Color.fromRGBO(242, 242, 247, 1)
                              : Color.fromRGBO(28, 28, 30, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  child: Text(
                                    "E",
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (profileController.isLightMode == true)
                                          ? Color(0xFFE6E0FA)
                                          : Color.fromRGBO(89, 66, 60, 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${receivedList['assignedToObj']?['roles'] != null && receivedList['assignedToObj']['roles'].isNotEmpty
                                        ? receivedList['assignedToObj']['roles'][0]
                                        : ''}",
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      // fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                  Text(
                                    "Role",
                                    style: GoogleFonts.outfit(
                                      color:
                                          (profileController.isLightMode ==
                                                  true)
                                              ? Colors.black
                                              : Colors.white,
                                      // fontFamily: 'SpaceGrotesk',
                                      fontSize: 12,
                                    ),
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
              SizedBox(height: 15),
              Obx(
                () => DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        onTap: controller.chnageTabIndex,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: 12),
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Color(0xffE7E7E9),
                        labelColor:
                        (profileController.isLightMode==true)?
                        Color(0xff606062):
                        Colors.white,
                        unselectedLabelColor:
                        (profileController.isLightMode==true)?
                        Color(0xff606062):
                        Color(0xFFF5F5F5),

                        indicatorColor:
                        (profileController.isLightMode==true)?
                        Color(0xff2B2B2B):
                            Colors.white,
                        tabs: [
                          Tab(text: "Task"),
                          // First tab divider line
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 22,
                                width: 2,
                                color: Color(0xffE7E7E9),
                              ),
                              SizedBox(width: 16),
                              Tab(text: "Call log"),
                            ],
                          ),
                          // Second tab divider line
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 22,
                                width: 2,
                                color: Color(0xffE7E7E9),
                              ),
                              SizedBox(width: 16),
                              Tab(text: "Activity"),
                            ],
                          ),
                        ],
                      ),

                      // TabBar(
                      //   onTap: controller.chnageTabIndex,
                      //   tabAlignment: TabAlignment.start,
                      //   isScrollable: true,
                      //   labelPadding: EdgeInsets.symmetric(horizontal: 4),
                      //   dividerColor:
                      //       (profileController.isLightMode == true)
                      //           ? Colors.white
                      //           : Colors.black,
                      //   labelColor: Colors.black,
                      //   unselectedLabelColor: Colors.grey,
                      //   indicatorColor:
                      //       (profileController.isLightMode == true)
                      //           ? Colors.white
                      //           : Colors.black,

                      //   tabs: [
                      //     Tab(
                      //       child: Container(
                      //         height:
                      //             MediaQuery.of(context).size.height * 0.1,
                      //         width: MediaQuery.of(context).size.width * 0.20,
                      //         decoration: BoxDecoration(
                      //           color:
                      //               controller.tabIndex == 0
                      //                   ? ((profileController.isLightMode ==
                      //                           true)
                      //                       ? Color(0xFFE6E0FA)
                      //                       : Color.fromRGBO(89, 66, 60, 1))
                      //                   : ((profileController.isLightMode ==
                      //                           true)
                      //                       ? Color.fromRGBO(242, 242, 247, 1)
                      //                       : Color.fromRGBO(28, 28, 30, 1)),
                      //         ),
                      //         child: Center(
                      //           child: Padding(
                      //             padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 StreamBuilder<DocumentSnapshot>(
                      //                   stream:
                      //                       FirebaseFirestore.instance
                      //                           .collection(
                      //                             "${authController.currentUserObj['orgId']}_leads_sch",
                      //                           )
                      //                           .doc(receivedList.id)
                      //                           .snapshots(),
                      //                   builder: (context, snapshot) {
                      //                     if (!snapshot.hasData ||
                      //                         !snapshot.data!.exists) {
                      //                       return Text(
                      //                         '0',
                      //                         style: GoogleFonts.outfit(
                      //                           color:
                      //                               profileController
                      //                                           .isLightMode ==
                      //                                       true
                      //                                   ? Colors.black
                      //                                   : Colors.white,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       );
                      //                     }

                      //                     final data =
                      //                         snapshot.data!.data()
                      //                             as Map<String, dynamic>;
                      //                     int pendingCount = 0;

                      //                     data.forEach((key, value) {
                      //                       if (value
                      //                               is Map<String, dynamic> &&
                      //                           value['sts'] == 'pending') {
                      //                         pendingCount++;
                      //                       }
                      //                     });

                      //                     // ✅ Safe update after build completes
                      //                     WidgetsBinding.instance
                      //                         .addPostFrameCallback((_) {
                      //                           controller
                      //                               .totaltasksvalue
                      //                               .value = pendingCount;
                      //                         });

                      //                     return Text(
                      //                       '$pendingCount',
                      //                       style: GoogleFonts.outfit(
                      //                         color:
                      //                             profileController
                      //                                         .isLightMode ==
                      //                                     true
                      //                                 ? Colors.black
                      //                                 : Colors.white,
                      //                         fontWeight: FontWeight.bold,
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),

                      //                 Text(
                      //                   "Tasks",
                      //                   style: GoogleFonts.outfit(
                      //                     color:
                      //                         (profileController
                      //                                     .isLightMode ==
                      //                                 true)
                      //                             ? Colors.black
                      //                             : Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontFamily: 'SpaceGrotesk',
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Tab(
                      //       child: Container(
                      //         height:
                      //             MediaQuery.of(context).size.height * 0.1,
                      //         width: MediaQuery.of(context).size.width * 0.23,
                      //         decoration: BoxDecoration(
                      //           color:
                      //               controller.tabIndex == 1
                      //                   ? (profileController.isLightMode ==
                      //                           true
                      //                       ? Color(0xFFE6E0FA)
                      //                       : Color.fromRGBO(89, 66, 60, 1))
                      //                   : (profileController.isLightMode ==
                      //                           true
                      //                       ? Color.fromRGBO(242, 242, 247, 1)
                      //                       : Color.fromRGBO(28, 28, 30, 1)),
                      //         ),
                      //         child: Center(
                      //           child: Padding(
                      //             padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 /// 👉 Replace Obx with StreamBuilder to show dynamic length
                      //                 StreamBuilder<
                      //                   List<Map<String, dynamic>>
                      //                 >(
                      //                   stream: controller.getCallLogsStream(
                      //                     receivedList.id,
                      //                   ),
                      //                   builder: (context, snapshot) {
                      //                     int count =
                      //                         snapshot.data?.length ?? 0;
                      //                     WidgetsBinding.instance
                      //                         .addPostFrameCallback((_) {
                      //                           // controller.totalcalllogsvalue.value = count;
                      //                         });

                      //                     return Text(
                      //                       "$count",
                      //                       style: GoogleFonts.outfit(
                      //                         color:
                      //                             profileController
                      //                                         .isLightMode ==
                      //                                     true
                      //                                 ? Colors.black
                      //                                 : Colors.white,
                      //                         fontWeight: FontWeight.bold,
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),

                      //                 Text(
                      //                   "Call log",
                      //                   style: GoogleFonts.outfit(
                      //                     color:
                      //                         profileController.isLightMode ==
                      //                                 true
                      //                             ? Colors.black
                      //                             : Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontFamily: 'SpaceGrotesk',
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),

                      //     Tab(
                      //       child: Container(
                      //         //height: MediaQuery.of(context).size.height * 0.07,
                      //         width: MediaQuery.of(context).size.width * 0.23,
                      //         decoration: BoxDecoration(
                      //           color:
                      //               controller.tabIndex == 2
                      //                   ? ((profileController.isLightMode ==
                      //                           true)
                      //                       ? Color(0xFFE6E0FA)
                      //                       : Color.fromRGBO(89, 66, 60, 1))
                      //                   : ((profileController.isLightMode ==
                      //                           true)
                      //                       ? Color.fromRGBO(242, 242, 247, 1)
                      //                       : Color.fromRGBO(28, 28, 30, 1)),
                      //         ),
                      //         child: Center(
                      //           child: Padding(
                      //             padding: EdgeInsets.fromLTRB(7, 4, 10, 0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 StreamBuilder<
                      //                   List<Map<String, dynamic>>
                      //                 >(
                      //                   stream: stream,
                      //                   builder: (context, snapshot) {
                      //                     if (snapshot.connectionState ==
                      //                         ConnectionState.waiting) {
                      //                       return Text(
                      //                         '0',
                      //                         style: GoogleFonts.outfit(
                      //                           color:
                      //                               profileController
                      //                                           .isLightMode ==
                      //                                       true
                      //                                   ? Colors.black
                      //                                   : Colors.white,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       );
                      //                     }

                      //                     if (!snapshot.hasData) {
                      //                       return Text(
                      //                         '0',
                      //                         style: GoogleFonts.outfit(
                      //                           color:
                      //                               profileController
                      //                                           .isLightMode ==
                      //                                       true
                      //                                   ? Colors.black
                      //                                   : Colors.white,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       );
                      //                     }
                      //                     var filteredData = snapshot.data!;
                      //                     filteredData =
                      //                         snapshot.data!
                      //                             .where(
                      //                               (item) =>
                      //                                   item['type'] ==
                      //                                   'sts_change',
                      //                             )
                      //                             .toList();
                      //                     var count = filteredData.length;
                      //                     controller
                      //                         .totalactivityvalue
                      //                         .value = filteredData.length;

                      //                     return Obx(
                      //                       () => Text(
                      //                         "${count}",
                      //                         style: GoogleFonts.outfit(
                      //                           color:
                      //                               profileController
                      //                                           .isLightMode ==
                      //                                       true
                      //                                   ? Colors.black
                      //                                   : Colors.white,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),

                      //                 Text(
                      //                   "Activity",
                      //                   style: GoogleFonts.outfit(
                      //                     color:
                      //                         (profileController
                      //                                     .isLightMode ==
                      //                                 true)
                      //                             ? Colors.black
                      //                             : Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontFamily: 'SpaceGrotesk',
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // SizedBox(height:height*0.02 ),
                      SizedBox(
                        height: height*0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.01),

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'you have ',
                            //         style: GoogleFonts.outfit(
                            //           color:
                            //               (profileController.isLightMode ==
                            //                       true)
                            //                   ? Colors.black
                            //                   : Color.fromRGBO(
                            //                     255,
                            //                     255,
                            //                     255,
                            //                     1,
                            //                   ),
                            //           fontFamily: 'SpaceGrotesk',
                            //           fontSize: 20,
                            //           letterSpacing: 0,
                            //           fontWeight: FontWeight.bold,
                            //           //height: 0.8461538461538461
                            //         ),
                            //       ),
                            //       Obx(
                            //         () => Text(
                            //           " ${controller.currenttabvalue.value}",
                            //           style: GoogleFonts.outfit(
                            //             color: Colors.orange,
                            //             fontFamily: 'SpaceGrotesk',
                            //             fontSize: 20,
                            //             letterSpacing: 0,
                            //             fontWeight: FontWeight.bold,
                            //             //height: 0.8461538461538461
                            //           ),
                            //         ),
                            //       ),
                            //       Text(
                            //         ' due events',
                            //         style: GoogleFonts.outfit(
                            //           color: Colors.orange,
                            //           fontFamily: 'SpaceGrotesk',
                            //           fontSize: 20,
                            //           letterSpacing: 0,
                            //           fontWeight: FontWeight.bold,
                            //           //height: 0.8461538461538461
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream:
                                    FirebaseFirestore.instance
                                        .collection(
                                      '${authController.currentUserObj['orgId']}_leads_sch',
                                    )
                                        .doc(receivedList.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }

                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return const SizedBox.shrink();
                                      }

                                      final data =
                                      snapshot.data!.data()
                                      as Map<String, dynamic>;

                                      List<Map<String, dynamic>>pendingTasks = [];

                                      data.forEach((key, value) {
                                        if (value is Map<String, dynamic>
                                            //&&
                                           // value['sts'] == 'pending'
                                        ) {
                                          pendingTasks.add({
                                            'notes': value['notes'] ?? '',
                                            'sts':value['sts'],
                                            'schTime':value['schTime'],
                                            'dueDate':
                                            value['schTime'] ??
                                                DateTime.now()
                                                     .millisecondsSinceEpoch,
                                            'assignee':
                                            value['by'] ??
                                                'Chaithanya',
                                            'comments':
                                            value['comments'] ?? [],
                                          });
                                        }
                                      });


                                      if (pendingTasks.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return SingleChildScrollView(
                                         child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Header with task count and dropdown
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                                top: 16,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Task (${pendingTasks.length})",
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 18,
                                                      color: (profileController.isLightMode==true)?
                                                      Colors.black:
                                                          Colors.white
                                                      ,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      right: 10.0,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                          Colors.grey[300]!,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Pending",
                                                            style: GoogleFonts.outfit(

                                                              color: (profileController.isLightMode==true)?
                                                            Colors.black:
                                                            Colors.white
                                                        ,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color:
                                                            (profileController.isLightMode==true)?
                                                            Colors.grey[800] :
                                                          Colors.white
                                                      ,

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 6),

                                            // For each task
                                            ...pendingTasks.map((task) {
                                              print(task['comments']);
                                              // Format date
                                              final DateTime dueDate =
                                              DateTime.fromMillisecondsSinceEpoch(
                                                 task['dueDate'] is int
                                                    ? task['dueDate']
                                                    : DateTime.now()
                                                    .millisecondsSinceEpoch,
                                              );

                                              var scheduletime=task['schTime'];
                                              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(scheduletime);
                                              String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);

                                              final List comments =
                                                  task['comments'] ?? [];
                                              List<String> words = task['notes'].split(" ");
                                              String thirdWord = words.length >= 3 ? words[2] : "";

                                              return Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  // Due time in red
                                                  Container(
                                                    height: 22,
                                                    width: 90,
                                                    color: Color(0xffF5E6E6),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,top: 2),
                                                      child: Text(
                                                        "Due in 12 min",
                                                        style: GoogleFonts.outfit(
                                                          color: Color(
                                                            0xff960000,
                                                          ),
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),

                                                  // Task title with strikethrough
                                                  RichText(
                                                    text: TextSpan(
                                                      text:
                                                      "${task['notes']}",
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: (profileController.isLightMode==true)?
                                                        Colors.black:
                                                        Colors.white
                                                        ,
                                                        decoration:
                                                        (task['sts']=='completed')?
                                                        TextDecoration
                                                            .lineThrough:
                                                        TextDecoration.none,
                                                        decorationColor:
                                                        (profileController.isLightMode==true)?
                                                        Colors.black:
                                                            Colors.white,

                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ),

                                                  // Follow up tag
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      top: 4,
                                                      bottom: 16,
                                                    ),
                                                    child: Text(
                                                       "#${thirdWord}",
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.green,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),

                                                  // Date and assignee
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      bottom: 8,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Date
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              size: 16,
                                                              color:
                                                              (profileController.isLightMode==true)?
                                                              Colors
                                                                  .grey[600]:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              formattedDate,
                                                              style: GoogleFonts.outfit(
                                                                color:
                                                                (profileController.isLightMode==true)?
                                                                Colors
                                                                    .grey[600]:
                                                                Colors.white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          width: 1,
                                                          height: 13,
                                                          color: Color(
                                                            0xffE7E7E9,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        // Assignee
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.person,
                                                              size: 16,
                                                              color:
                                                              (profileController.isLightMode==true)?
                                                              Colors
                                                                  .grey[600]:
                                                              Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              task['assignee'] ??
                                                                  "Chaithanya",
                                                              style: GoogleFonts.outfit(
                                                                color:
                                                                (profileController.isLightMode==true)?
                                                                Colors
                                                                    .grey[600]:
                                                                Colors.white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Comments section
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${comments.length} comments",
                                                        style:
                                                        GoogleFonts.outfit(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                            color: (profileController.isLightMode==true)?
                                                                Colors.black:
                                                                Colors.white

                                                        ),
                                                      ),

                                                      TextButton.icon(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Color(
                                                            0xff7456F5,
                                                          ),
                                                        ),
                                                        label: Text(
                                                          "Add Comment",
                                                          style:
                                                          GoogleFonts.outfit(
                                                            color: Color(
                                                              0xff7456F5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  ListView.builder(
                                                    padding: EdgeInsets.only(top: 1),
                                                    shrinkWrap: true, // ✅ Makes ListView take only the space it needs
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: comments.length,
                                                    itemBuilder: (context, index) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                comments[index]['c'].length > 35
                                                                    ? "${comments[index]['c'].substring(0, 35)}..."
                                                                    : comments[index]['c'],
                                                                style: GoogleFonts.outfit(
                                                                  fontSize: 14,
                                                                  color:
                                                                  (profileController.isLightMode==true)?
                                                                  Colors
                                                                      .grey[600]:
                                                                  Colors.white,
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10.0),
                                                                child: Text(
                                                                  timeago.format(
                                                                    DateTime.fromMillisecondsSinceEpoch(comments[index]['t']),
                                                                  ),
                                                                  style: GoogleFonts.outfit(
                                                                    color:
                                                                    (profileController.isLightMode==true)?
                                                                    Colors
                                                                        .grey[600]:
                                                                    Colors.white,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      const SizedBox(
                                                      height: 12,
                                                      )
                                                        ],

                                                      );

                                                    },
                                                  ),

                                                  Divider()




                                                  // Comments
                                                /*  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      bottom: 16,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // Comment 1
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Call again as customer is busy",
                                                              style:
                                                              GoogleFonts.outfit(
                                                                fontSize:
                                                                14,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Text(
                                                                "2 days ago",
                                                                style: GoogleFonts.outfit(
                                                                  color:
                                                                  Colors
                                                                      .grey[600],
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        // Comment 2
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Rescheduling",
                                                              style:
                                                              GoogleFonts.outfit(
                                                                fontSize:
                                                                14,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right : 10),
                                                              child: Text(
                                                                "2 days ago",
                                                                style: GoogleFonts.outfit(
                                                                  color:
                                                                  Colors
                                                                      .grey[600],
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),*/
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  // StreamBuilder<DocumentSnapshot>(
                                  //   stream:
                                  //       FirebaseFirestore.instance
                                  //           .collection(
                                  //             '${authController.currentUserObj['orgId']}_leads_sch',
                                  //           )
                                  //           .doc(receivedList.id)
                                  //           .snapshots(),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return SizedBox.shrink();
                                  //     }

                                  //     if (!snapshot.hasData ||
                                  //         !snapshot.data!.exists) {
                                  //       return SizedBox.shrink();
                                  //     }

                                  //     final data =
                                  //         snapshot.data!.data()
                                  //             as Map<String, dynamic>;
                                  //     List<String> pendingNotes = [];

                                  //     data.forEach((key, value) {
                                  //       if (value is Map<String, dynamic> &&
                                  //           value['sts'] == 'pending') {
                                  //         pendingNotes.add(
                                  //           value['notes'] ?? '',
                                  //         );
                                  //       }
                                  //     });

                                  //     if (pendingNotes.isEmpty) {
                                  //       return SizedBox.shrink();
                                  //     }

                                  //     return ListView.builder(
                                  //       padding: const EdgeInsets.only(
                                  //         top: 12,
                                  //       ),

                                  //       itemCount: pendingNotes.length,

                                  //       itemBuilder: (context, index) {
                                  //         return Align(
                                  //           alignment: Alignment.centerLeft,
                                  //           child: Container(
                                  //             width: width * 0.9,
                                  //             // height: height*0.08,
                                  //             padding: EdgeInsets.all(16),
                                  //             decoration: BoxDecoration(
                                  //               color:
                                  //                   (profileController
                                  //                               .isLightMode ==
                                  //                           true)
                                  //                       ? Color.fromRGBO(
                                  //                         242,
                                  //                         242,
                                  //                         247,
                                  //                         1,
                                  //                       )
                                  //                       : Colors.white,
                                  //               borderRadius:
                                  //                   BorderRadius.only(
                                  //                     topRight:
                                  //                         Radius.circular(16),
                                  //                     bottomLeft:
                                  //                         Radius.circular(16),
                                  //                     bottomRight:
                                  //                         Radius.circular(16),
                                  //                   ),
                                  //             ),
                                  //             child: Center(
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     pendingNotes[index],
                                  //                     style: GoogleFonts.outfit(
                                  //                       fontSize:
                                  //                           height * 0.016,
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                  StreamBuilder<List<Map<String, dynamic>>>(
                                    stream: controller.getCallLogsStream(
                                      receivedList.id,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            ""
                                            //"Error: ${snapshot.error}",
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                          child: Text("No call logs found"),
                                        );
                                      }

                                      final logs = snapshot.data!;

                                      return ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        itemCount: logs.length,
                                        separatorBuilder:
                                            (context, index) => const Divider(
                                              height: 1,
                                              color: Color(0xffE7E7E9),
                                            ),
                                        itemBuilder: (context, index) {
                                          final log = logs[index];
                                          final DateTime dateTime =
                                              DateTime.fromMillisecondsSinceEpoch(
                                                log['startTime'].toInt(),
                                              );


                                          final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                                            log['startTime'].toInt(),
                                          );

                                          final DateTime now = DateTime.now();
                                          final Duration difference = now.difference(startTime);

                                          String getTimeAgo(Duration diff) {
                                            if (diff.inSeconds < 60) {
                                              return '${diff.inSeconds} seconds ago';
                                            } else if (diff.inMinutes < 60) {
                                              return '${diff.inMinutes} minutes ago';
                                            } else if (diff.inHours < 24) {
                                              return '${diff.inHours} hours ago';
                                            } else if (diff.inDays < 30) {
                                              return '${diff.inDays} days ago';
                                            } else if (diff.inDays < 365) {
                                              int months = (diff.inDays / 30).floor();
                                              return '$months month${months > 1 ? 's' : ''} ago';
                                            } else {
                                              int years = (diff.inDays / 365).floor();
                                              return '$years year${years > 1 ? 's' : ''} ago';
                                            }
                                          }

          // Usage:
                                          String timeAgo = getTimeAgo(difference);


                                        //  final String timeAgo = "12 min ago";
                                          final isOutgoing =
                                              log['type'] == 'outgoing';

                                          return Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 16,
                                                ),
                                            child: Row(
                                              children: [
                                                // Custom call icon
                                                Icon(
                                                  isOutgoing
                                                      ? Icons
                                                          .call_made_rounded
                                                      : Icons
                                                          .phone_callback_outlined,
                                                  color:
                                                  (profileController.isLightMode==true)?
                                                  Color(0xff000000):
                                                  Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 16),

                                                // Call type and duration
                                                Text(
                                                  isOutgoing
                                                      ? "Outgoing"
                                                      : "Incoming",
                                                  style: GoogleFonts.outfit(
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: 16,
                                                    color:
                                                    (profileController.isLightMode==true)?
                                                    Color(0xff000000):
                                                        Colors.white
                                                  ),
                                                ),

                                                // Duration right after type
                                                Text(
                                                  "  ${log['duration'] ?? 0}s",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 14,
                                                    color:
                                                    (profileController.isLightMode==true)?
                                                    Color(0xff000000):
                                                    Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                  ),
                                                ),

                                                const Spacer(),

                                                // Time ago
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8.0,
                                                      ),
                                                  child: Text(
                                                    timeAgo,
                                                    style: GoogleFonts.outfit(
                                                      color:
                                                      (profileController.isLightMode==true)?
                                                      Color(0xff000000):
                                                      Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  // StreamBuilder<List<Map<String, dynamic>>>(
                                  //   stream: controller.getCallLogsStream(
                                  //     receivedList.id,
                                  //   ), // pass LUID here
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return Center(
                                  //         child: CircularProgressIndicator(),
                                  //       );
                                  //     }

                                  //     if (snapshot.hasError) {
                                  //       return Center(
                                  //         child: Text(
                                  //           "Error: ${snapshot.error}",
                                  //         ),
                                  //       );
                                  //     }

                                  //     if (!snapshot.hasData ||
                                  //         snapshot.data!.isEmpty) {
                                  //       return Center(
                                  //         child: Text("No call logs found"),
                                  //       );
                                  //     }

                                  //     final logs = snapshot.data!;

                                  //     return ListView.builder(
                                  //       padding: const EdgeInsets.only(
                                  //         top: 12,
                                  //       ),
                                  //       itemCount: logs.length,
                                  //       itemBuilder: (context, index) {
                                  //         final singlelog = logs[index];
                                  //         DateTime dateTime =
                                  //             DateTime.fromMillisecondsSinceEpoch(
                                  //               singlelog['startTime']
                                  //                   .toInt(),
                                  //             );

                                  //         String formattedDate = DateFormat(
                                  //           'yyyy-MM-dd HH:mm',
                                  //         ).format(dateTime);

                                  //         return Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Container(
                                  //               decoration: BoxDecoration(
                                  //                 color:
                                  //                     profileController
                                  //                                 .isLightMode ==
                                  //                             true
                                  //                         ? Color.fromRGBO(
                                  //                           242,
                                  //                           242,
                                  //                           247,
                                  //                           1,
                                  //                         )
                                  //                         : Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                       10,
                                  //                     ),
                                  //               ),
                                  //               height: height * 0.08,
                                  //               width: width * 0.9,
                                  //               child: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.fromLTRB(
                                  //                       10,
                                  //                       0,
                                  //                       10,
                                  //                       0,
                                  //                     ),
                                  //                 child: Row(
                                  //                   children: [
                                  //                     Text(
                                  //                       "${singlelog['type']}",
                                  //                     ),
                                  //                     SizedBox(
                                  //                       width: width * 0.02,
                                  //                     ),
                                  //                     Text(
                                  //                       "${singlelog['duration']}s",
                                  //                     ),
                                  //                     Spacer(),
                                  //                     Text(formattedDate),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Divider(
                                  //               color:
                                  //                   profileController
                                  //                               .isLightMode ==
                                  //                           false
                                  //                       ? Colors.black
                                  //                       : Colors.white,
                                  //               height: 6,
                                  //             ),
                                  //           ],
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                  StreamBuilder<List<Map<String, dynamic>>>(
                                    stream: stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Text('No data found');
                                      }

                                      var filteredData =
                                          snapshot.data!
                                              .where(
                                                (item) =>
                                                    item['type'] ==
                                                    'sts_change',
                                              )
                                              .toList();
                                      controller.activitycount.value =
                                          filteredData.length;

                                      return ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        itemCount: filteredData.length,
                                        separatorBuilder:
                                            (context, index) =>
                                                const SizedBox(height: 24),
                                        itemBuilder: (context, index) {
                                          final item = filteredData[index];
                                          String fromstatus=item['from'];
                                          fromstatus=fromstatus.toUpperCase();
                                          String tostatus=item['to'];
                                          tostatus=tostatus.toUpperCase();

                                          var time=item['T'];

                                          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time.toInt());

          // Format: 20 Mar 2025, 12:22
                                          String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);


                                          // Format date
                                         // String formattedDate =
                                           //   "20 Mar 2025, 12:22";
                                           String assignee =
                                              item['by'] ??
                                              "Chaithanya";

                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Timeline indicator with dot and line
                                              Container(
                                                width: 24,
                                                child: Column(
                                                  children: [
                                                    // Colored dot
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0xffA693F8,
                                                        ),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    // Vertical line
                                                    if (index <
                                                        filteredData.length -
                                                            1)
                                                      Container(
                                                        width: 2,
                                                        height: 60,
                                                        color: Color(
                                                          0xffA693F8,
                                                        ),

                                                        margin:
                                                            const EdgeInsets.only(
                                                              left: 1,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Activity content
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    // Status change text
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 6),
                                                      child: Text(
                                                        "$fromstatus completed & moved to $tostatus",
                                                        style:
                                                            GoogleFonts.outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: (profileController.isLightMode==true)?
                                                                  Colors.black:
                                                                  Colors.white
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    // Date and assignee row
                                                    Row(
                                                      children: [
                                                        // Date with calendar icon
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              size: 16,
                                                              color:
                                                              (profileController.isLightMode==true)?

                                                                  Colors
                                                                      .grey[600]:
                                                                  Colors.white
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              formattedDate,
                                                              style: GoogleFonts.outfit(
                                                                color:
                                                                (profileController.isLightMode==true)?

                                                                Colors
                                                                    .grey[600]:
                                                                Colors.white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        // Assignee with user icon
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.person,
                                                              size: 16,
                                                                color:
                                                                (profileController.isLightMode==true)?

                                                                Colors
                                                                    .grey[600]:
                                                                Colors.white
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              assignee.length > 13 ? '${assignee.substring(0, 13)}...' : assignee,
                                                              style: GoogleFonts.outfit(
                                                                color:
                                                                (profileController.isLightMode==true)?

                                                                Colors
                                                                    .grey[600]:
                                                                Colors.white,
                                                                fontSize: 14,
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    // Divider at the bottom
                                                    Container(
                                                      height: 1,
                                                      color: Colors.grey[200],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  // StreamBuilder<List<Map<String, dynamic>>>(
                                  //   stream: stream,
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return Container();
                                  //     }

                                  //     if (!snapshot.hasData ||
                                  //         snapshot.data!.isEmpty) {
                                  //       return Text('No data found');
                                  //     }

                                  //     var filteredData = snapshot.data!;
                                  //     filteredData =
                                  //         snapshot.data!
                                  //             .where(
                                  //               (item) =>
                                  //                   item['type'] ==
                                  //                   'sts_change',
                                  //             )
                                  //             .toList();
                                  //     controller.activitycount.value =
                                  //         filteredData.length;

                                  //     return ListView.builder(
                                  //       padding: const EdgeInsets.only(
                                  //         top: 12,
                                  //       ),
                                  //       itemCount: filteredData.length,
                                  //       itemBuilder: (context, index) {
                                  //         final item = filteredData[index];

                                  //         return Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Container(
                                  //               width: width * 0.9,
                                  //               //height: height*0.08,
                                  //               padding: EdgeInsets.all(16),
                                  //               decoration: BoxDecoration(
                                  //                 color:
                                  //                     (profileController
                                  //                                 .isLightMode ==
                                  //                             true)
                                  //                         ? Color.fromRGBO(
                                  //                           242,
                                  //                           242,
                                  //                           247,
                                  //                           1,
                                  //                         )
                                  //                         : Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.only(
                                  //                       topRight:
                                  //                           Radius.circular(
                                  //                             16,
                                  //                           ),
                                  //                       bottomLeft:
                                  //                           Radius.circular(
                                  //                             16,
                                  //                           ),
                                  //                       bottomRight:
                                  //                           Radius.circular(
                                  //                             16,
                                  //                           ),
                                  //                     ),
                                  //               ),
                                  //               child: Center(
                                  //                 child: Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Text(
                                  //                       "Changed Status from ${item['from']} to ${item['to']}",
                                  //                       style: GoogleFonts.outfit(
                                  //                         fontSize:
                                  //                             height * 0.016,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Divider(
                                  //               color:
                                  //                   (profileController
                                  //                               .isLightMode ==
                                  //                           false)
                                  //                       ? Colors.black
                                  //                       : Colors.white,
                                  //               height: 6,
                                  //             ),
                                  //           ],
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
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

              SizedBox(height: 5),

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
                              style: GoogleFonts.outfit(
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
                              style: GoogleFonts.outfit(
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
                              style: GoogleFonts.outfit(
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
                              style: GoogleFonts.outfit(
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
                          style: GoogleFonts.outfit(
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
                          style: GoogleFonts.outfit(
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
      ),
    );
  }
}
