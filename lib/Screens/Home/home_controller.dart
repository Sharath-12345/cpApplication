import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Auth/auth_controller.dart';

class HomeController extends GetxController
{




   final AuthController authController = Get.find<AuthController>();


 var Totalleadslist;
   var newleadslist=
       <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var followupleadslist=
   <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var visitfixedleadslist=
   <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var visitdoneleadslist=
   <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var negotiationleadslist=
   <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var notintrestedleadslist=
   <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
   var totaltasks=0.obs;

 var totalleads=0.obs;
  var newleads=0.obs;
  var showingLeadsCount=0.obs;
  var followupleads=0.obs;
   var visitdoneleads=0.obs;
   var visitfixedleads=0.obs;
   var  negotiationleads=0.obs;
    var notintrestedleads=0.obs;
   RxInt tabIndex = 0.obs;
   chnageTabIndex(int index) {
     tabIndex(index);

     if(index == 0){
      showingLeadsCount.value = newleads.value;
      print(showingLeadsCount);
     }else if (index == 1){
       showingLeadsCount.value = followupleads.value;
     }else if (index == 2){
       showingLeadsCount.value = visitfixedleads.value;
     }else if (index == 3){
       showingLeadsCount.value = visitdoneleads.value;
     }else if (index == 4){
       showingLeadsCount.value = negotiationleads.value;
     }else if (index == 5){
       showingLeadsCount.value = notintrestedleads.value;
     }
   }


   @override
  void onInit() {
    super.onInit();
  /* getleads();
   getnewleads();
   getfollowleads();
   getvisitfixedleads();
   getvisitdoneleads();
   getnegotiationleads();
   getnotintrestedleads();*/
  }

  Future<void> getTotalTasks()
  async {

    Stream<QuerySnapshot<Map<String,dynamic>>> tasks= FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
        .where("due_date", isLessThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status", isEqualTo: "InProgress")
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .snapshots();

    tasks.listen((querySnapshot) {
       totaltasks.value=querySnapshot.size;
      for (var doc in querySnapshot.docs) {
        print("Task ID: ${doc.id}, Data: ${doc.data()}");
        print("_________________________");
      }
    });

  }



  Future<void> getleads()
  async {

      
     var ref=FirebaseFirestore.instance.
    collection("${authController.currentUserObj['orgId']}_leads");




    var totalLeadsList= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'new',
      'followup',
      'visitfixed',
      'visitdone','negotiation',
      'Followup'
    ]);
    QuerySnapshot totalleadsquerySnapshot;
       totalleadsquerySnapshot = await totalLeadsList.get();
      totalleads.value=totalleadsquerySnapshot.size;
      //print(totalleads.value.toString());
       Totalleadslist=totalleadsquerySnapshot.docs;




    var newleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'new',
    ]);

    QuerySnapshot newleadsquerySnapshot;
    newleadsquerySnapshot = await newleadslist.get();
    newleads.value=newleadsquerySnapshot.size;
   // print(newleadslist.toString());





    var followupleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'followup','Followup',
    ]);
    QuerySnapshot followupquerySnapshot;
    followupquerySnapshot = await followupleadslist.get();
    followupleads.value=followupquerySnapshot.size;




    var visitdoneleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'visitdone',
    ]);
    QuerySnapshot visitdonequerySnapshot;
    visitdonequerySnapshot = await visitdoneleadslist.get();
    visitdoneleads.value=visitdonequerySnapshot.size;


    var visitfixedleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'visitfixed',
    ]);
    QuerySnapshot visitfixedquerySnapshot;
    visitfixedquerySnapshot = await visitfixedleadslist.get();
    visitfixedleads.value=visitfixedquerySnapshot.size;


    var negotiationleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'negotiation',
    ]);
    QuerySnapshot negotiationquerySnapshot;
    negotiationquerySnapshot = await negotiationleadslist.get();
    negotiationleads.value=negotiationquerySnapshot.size;


    var notintrestedleadslist= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("Status", whereIn: [
      'notintrested',
    ]);
    QuerySnapshot notintrestedquerySnapshot;
    notintrestedquerySnapshot = await notintrestedleadslist.get();
    notintrestedleads.value=notintrestedquerySnapshot.size;


  }
   Future<void> getnewleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var newleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'new',
     ]).get();
     newleadslist.assignAll(newleadsquery.docs);
  //   newleadslist=newleadsquery.docs;
    // print(newleadslist[0]);

    // print(newleadsquerySnapshot.docs.first.data());

   }

   Future<void> getfollowleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var followupleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'followup','Followup'
     ]).get();
     // followupleadslist=followupleadsquery.docs;
      followupleadslist.assignAll(followupleadsquery.docs);

   }
   Future<void> getvisitfixedleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var visitfixedleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'visitfixed',
     ]).get();
    // visitfixedleadslist=visitfixedleadsquery.docs;
     visitfixedleadslist.assignAll(visitfixedleadsquery.docs);

   }
   Future<void> getvisitdoneleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var visitdoneleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'visitdone',
     ]).get();
    // visitdoneleadslist=visitdoneleadsquery.docs;
      visitdoneleadslist.assignAll(visitdoneleadsquery.docs);

   }
   Future<void> getnegotiationleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var negotiationleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'negotiation',
     ]).get();
    // negotiationleadslist=negotiationleadsquery.docs;
     negotiationleadslist.assignAll(negotiationleadsquery.docs);


   }
   Future<void> getnotintrestedleads()
   async {
     var ref=FirebaseFirestore.instance.
     collection("${authController.currentUserObj['orgId']}_leads");


     var notintrestedleadsquery= await ref
         .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .where("Status", whereIn: [
       'notintrested',
     ]).get();
     //notintrestedleadslist=notintrestedleadsquery.docs;
     notintrestedleadslist.assignAll(notintrestedleadsquery.docs);

   }

   void makedirectcall( var phoneNumber) async
   {
     final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

     if (await canLaunchUrl(callUri)) {
       await launchUrl(callUri, mode: LaunchMode.externalApplication);
     } else {
       print("Could not launch call");
     }
   }

















}

