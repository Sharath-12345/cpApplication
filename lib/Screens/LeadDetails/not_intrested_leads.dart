import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Auth/auth_controller.dart';
import '../../BottomPopups/popup_status_change_lead_controller.dart';
import '../../Utilities/snackbar.dart';

class NotIntrestedLeads extends StatefulWidget
{
  const NotIntrestedLeads({super.key});

  @override
  State<NotIntrestedLeads> createState() => _NotIntrestedLeadsState();
}

class _NotIntrestedLeadsState extends State<NotIntrestedLeads> {
  var  leaddetails = Get.arguments;
  final statuschangeleadcontroller=Get.find<StatusChangeLead>();
  final authController=Get.find<AuthController>();
  final user=FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {

    var orgId=authController.currentUserObj['orgId'];
    var projectId=leaddetails['ProjectId'];
    var leadDocId=leaddetails.id;
    var  oldStatus=leaddetails['Status'];
    var newStatus="notintrested";
    print(newStatus);
    var by=leaddetails['assignedToObj']['name'];
    var leadname=leaddetails['Name'];
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
     return Scaffold(
       body:
       Padding(
         padding: EdgeInsets.fromLTRB(0, 40,0, 0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Center(
               child: Container(
                 height: height*0.14,
                 width: width*0.9,
                 decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(3),
                 ),
                 child: Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Scores",style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontFamily: 'SpaceGrotesk'
                       ),),
                       SizedBox(height: height*0.01,),
                       Container(
                         height: height*0.05,
                         width: width*0.1,
                         color: Color(0xfffe1bee7),
                         child: Center(
                           child: Text("10",style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontFamily: 'SpaceGrotesk'
                           ),),
                         ),
                       )
                     ],
                   ),
                 ),

               ),
             ),
             SizedBox(height: height*0.02,),
             Padding(
               padding: const EdgeInsets.only(left: 30),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Why Lead is not intrested",style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontFamily: 'SpaceGrotesk',
                       fontSize: height*0.02
                   ),),
                   SizedBox(height: height*0.004,),
                   Text("1 question",style: TextStyle(
                       fontFamily: 'SpaceGrotesk',
                       fontSize: height*0.017
                   ),),

                 ],
               ),
             ),
             SizedBox(height: height*0.03,),

             Padding(
               padding: const EdgeInsets.only(left: 25),
               child: Row(
                 //mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.4),
                         borderRadius: BorderRadius.circular(6)

                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(7.0),
                       child: Center(
                         child: Text("Q.1",style: TextStyle(
                             fontWeight: FontWeight.bold,
                           fontSize: height*0.015
                         ),),
                       ),
                     ),

                   ),
                   SizedBox(width: width*0.03,),
                   Text("Why Lead is not intrested",style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: height*0.019,
                       fontFamily: 'SpaceGrotesk'
                   ),)
                 ],
               ),
             ),
             SizedBox(height: height*0.01,),
             Padding(
               padding: const EdgeInsets.only(left: 12),
               child: Center(
                 child: SizedBox(
                   width: width*0.7,
                     child: NotIntrestedReasonsCheckboxWidget()
                 ),
               ),
             ),
             Spacer(),
             Container(
               height: height*0.09,
               width: width,
               color: Colors.grey.withOpacity(0.2),
               child: Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 12),
                     child: Text("set lead status",style: TextStyle(
                         fontFamily: 'SpaceGrotesk'
                     ),),
                   ),
                   Spacer(),
                   InkWell(
                     onTap: ()
                     {
                       var y = "Not Intrested";
                       final data = {
                         "stsType": "Not Intrested" ?? "none",
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






                       statuschangeleadcontroller.addLeadScheduler
                         (orgId: orgId, did: leadDocId,
                           data: data, schStsA: "pending");



                       statuschangeleadcontroller.updateLeadStatus(
                           orgId: orgId, projectId: projectId,
                           leadDocId: leadDocId, oldStatus: oldStatus,
                           newStatus: newStatus, by: by, context: context);

                       if (Navigator.canPop(context)) {
                         Navigator.pop(context);
                       }
                       snackBarMsg("Status Updated");
                     },
                     child: Padding(
                       padding: const EdgeInsets.only(right: 12),
                       child: Container(
                         width: width*0.40,
                         height: height*0.06,
                         decoration: BoxDecoration(
                           color: Color(0xFF651FFF),
                           borderRadius: BorderRadius.circular(50),
                         ),
                         child: Center(
                           child: Row(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 12),
                                 child: Text("NOT INTRESTED",style: TextStyle(color: Colors.white,
                                     fontFamily: 'SpaceGrotesk',
                                 fontSize: height*0.014),),
                               ),
                               Spacer(),
                               Padding(
                                 padding: const EdgeInsets.only(right: 16),
                                 child: Container(

                                   child: Icon(Icons.chevron_right,color: Colors.black,),
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       shape: BoxShape.circle
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                       ),
                     ),
                   )
                 ],
               ),
             )


           ],
         ),
       ),
     );
  }
}
class NotIntrestedReasonsCheckboxWidget extends StatefulWidget {
  const NotIntrestedReasonsCheckboxWidget({super.key});

  @override
  _NotIntrestedReasonsCheckboxWidgetState createState() => _NotIntrestedReasonsCheckboxWidgetState();
}

class _NotIntrestedReasonsCheckboxWidgetState extends State<NotIntrestedReasonsCheckboxWidget> {
  int? selectedIndex; // Stores the selected checkbox index

  final List<String> emotions = ["Budget issue", "Looking for different area & property",
    "Looking for differnt areas", "Looking for differnt property"];

  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(emotions.length, (index) {
        return CheckboxListTile(
          title: Text(emotions[index],style:
          TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: MediaQuery.of(context).size.height*0.016
          ),),
          value: selectedIndex == index, // Check only one at a time
          onChanged: (bool? value) {
            setState(() {
              selectedIndex = value! ? index : null;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          //contentPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(0),
          dense: true,
          activeColor: Colors.green,
          visualDensity: VisualDensity(horizontal: -3, vertical: -4),
        );
      }),
    );
  }
}