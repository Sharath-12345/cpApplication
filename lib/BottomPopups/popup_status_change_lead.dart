import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead_controller.dart';

void ShowDatePickerCard(BuildContext context) async {
  print('inside here');
  DateTime? dateTime = await showOmniDateTimePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
    lastDate: DateTime.now().add(
      const Duration(days: 3652),
    ),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: 5,
    secondsInterval: 1,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    constraints: const BoxConstraints(
      maxWidth: 350,
      maxHeight: 650,
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(
          Tween(
            begin: 0,
            end: 1,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    selectableDayPredicate: (dateTime) {
      // Disable 25th Feb 2023
      if (dateTime == DateTime(2023, 2, 25)) {
        return false;
      } else {
        return true;
      }
    },
  );
// controller.selectedDateTime.value = DateFormat('dd-MM-yy HH:mm').format(dateTime!).toString();
  //controller.selectedDateTime.value = dateTime!.millisecondsSinceEpoch;
  // print('selected data is ${controller.selectedDateTime}  ${dateTime}');
}


Future<void> showBottomPopup(BuildContext context,var tasktype,var leaddetails) async {
  final TextEditingController controller = TextEditingController
    (text: "Make a $tasktype task ");
  TextEditingController nameController = TextEditingController();
  var statuschangeleadcontroller=Get.find<StatusChangeLead>();
  var authController=Get.find<AuthController>();
  var height=MediaQuery.of(context).size.height;
  var width=MediaQuery.of(context).size.width;
  var currentdatetime=DateTime.now();
  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(currentdatetime);

  var orgId=authController.currentUserObj['orgId'];
  var projectId=leaddetails['ProjectId'];
  var leadDocId=leaddetails.id;
  var  oldStatus=leaddetails['Status'];
  var newStatus=tasktype.toString().toLowerCase().replaceAll(" ", "");;
  print(newStatus);
  var by=leaddetails['assignedToObj']['name'];
  var leadname=leaddetails['Name'];

  var user=FirebaseAuth.instance.currentUser;





  var y = "Make a $tasktype call to $leadname";
  final data = {
    "stsType": tasktype ?? "none",
    "assTo": user?.displayName ?? user?.email,
    "assToId": user?.uid,
    "by": user?.displayName ?? user?.email,
    "cby": user?.uid,
    "type": "schedule",
    "pri": " ",
    "notes": (y == "") ? "Negotiate with customer" : y,
    "sts": "pending",
    "schTime":
    //(tempLeadStatus == "booked")
    //?
    Timestamp.now().millisecondsSinceEpoch + 10800000
    // : startDate.millisecondsSinceEpoch
    ,
    "ct": Timestamp.now().millisecondsSinceEpoch,
  };
  List<Map<String, dynamic>> data1=[];

  DateTime tomorrowDate = DateTime.now().toUtc().add(Duration(days: 1));
  int timestamp = tomorrowDate.millisecondsSinceEpoch;

  DateTime todayDate = DateTime.now();
  String ddMy = 'D${todayDate.day}M${todayDate.month}Y${todayDate.year}';





    var documentSnapshot = await FirebaseFirestore.instance
        .collection('${orgId}_leads_sch')
        .doc(leadDocId)
        .get();

    Map<String, dynamic>? data2 = documentSnapshot.data();
  List<Map<String, dynamic>> mapsList=[];// Get the document data as a map

    if (data2 != null) {
      // Extract only values that are maps
       mapsList = data2.entries
          .where((entry) => entry.value is Map<String, dynamic>) // Filter only maps
          .map((entry) => entry.value as Map<String, dynamic>) // Convert to list of maps
          .toList();

      //print("List of maps: $mapsList");
    } else {
      print("No data found.");
    }
















  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: SizedBox(
          height: height*0.32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height*0.06,
                decoration: BoxDecoration(
                  color: Color(0XFFB2DFDB),
                  borderRadius: BorderRadius.circular(7),
                ),

                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "Hey, plan your ",
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk'
                          ),
                        ),
                      ),
                      Text(
                        "$tasktype",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceGrotesk'),
                      ),
                      Text(
                        " with a task",
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk'
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
             Padding(
               padding: const EdgeInsets.only(left: 12),
               child: Opacity(
                   opacity: 0.5,
                   child: Text("Task Title",style: TextStyle(
                     fontFamily: 'SpaceGrotesk'
                   ),)

               ),
             ),

              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Removes the default underline
                  ),
                  style: TextStyle(fontSize: 16,
                  fontFamily: 'SpaceGrotesk'),
                  cursorColor: Colors.blue,
                ),
              ),

          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: [6, 3], // Adjust dot spacing
                  color: Colors.black12, // Dotted border color
                  strokeWidth: 2,
                  child: InkWell(
                    onTap: ()
                    {
                      ShowDatePickerCard(context);
                    },
                    child: Container(
                      width: width*0.13,
                      height: height*0.04,
                      decoration: BoxDecoration(
                         shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child:
                      Center(
                        child: Icon(Icons.calendar_month_outlined,color: Colors.black26,),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Due Date",style: TextStyle(color: Colors.black38),),
                     Text(formattedDateTime.toString(),style:
                     TextStyle(color: CupertinoColors.systemBlue,fontWeight: FontWeight.bold),)
                  ],
                )
              ],
              
            ),
          ),
             SizedBox(height: height*0.03,),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.calendar_month_outlined,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.flag_outlined,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.people,color: Colors.black38,),
                    Spacer(),
                    InkWell(
                      onTap: ()
                      async {



                         await statuschangeleadcontroller.closePreviousTasks(
                            orgId: orgId, leadId: leadDocId);

                        statuschangeleadcontroller.addNewMap(
                            orgId: orgId, leadId: leadDocId,
                            by: by,
                            notes: "Make a ${newStatus} call to ${leadname}",
                            pri: "priority 1", sts: "pending",
                            schedule: "schedule");

                       /*statuschangeleadcontroller.closeAllPreviousTasks
                          (orgId: orgId, closingComments: "completed",
                            leadSchFetchedData: mapsList, newStatus:
                            newStatus, data: data, userId:user!.uid , ddMy: ddMy,
                            leadStatus: oldStatus,
                            tomorrowDate: timestamp,
                            context: context, leadid: leadDocId);









                      statuschangeleadcontroller.addLeadScheduler
                          (orgId: orgId, did: leadDocId,
                            data: data, schStsA: "pending");*/



                        statuschangeleadcontroller.updateLeadStatus(
                            orgId: orgId, projectId: projectId,
                            leadDocId: leadDocId, oldStatus: oldStatus,
                            newStatus: newStatus, by: by, context: context);

                       if (Navigator.canPop(context)) {
                         Navigator.pop(context);
                       }
                      },

                      child: Container(
                        height: height*0.05,
                        width: width*0.12,
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          color: Color(0XFFE1BEE7)
                        ),
                        child: Center(

                          child: Icon(Icons.send,color: Colors.blueAccent,),
                        ),
                      ),
                    )

                  ],
                ),
              )
             ]
          ),
        ),
      );
    },
  );
}