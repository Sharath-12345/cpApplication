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
  Future<void> onInit() async {
    super.onInit();
   getleads();
  /* getnewleads();
   getfollowleads();
   getvisitfixedleads();
   getvisitdoneleads();
   getnegotiationleads();
   getnotintrestedleads();*/
  }


   Stream<int> get totaltasksStream =>FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_assignedTasks")
       .where("to_uid", isEqualTo: authController.currentUser?.uid)
       .where('status', whereIn: [
     'InProgress',
     'Completed'
   ]
   ).snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get totalLeadsStream =>FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', whereIn: [
     'new',
     'followup',
     'visitfixed',
     'visitdone','negotiation',
     'Followup'
   ]
   )
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get newLeadsStream => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', isEqualTo: 'new')
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get followupLeads => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status',whereIn: [
     'followup','Followup',
   ])
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get visitfixedLeads => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', isEqualTo: 'visitfixed')
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get visitdoneLeads => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', isEqualTo: 'visitdone')
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get negotiationsLeads => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', isEqualTo: 'negotiations')
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);

   Stream<int> get notIntrestedLeads => FirebaseFirestore.instance
       .collection("${authController.currentUserObj['orgId']}_leads")
       .where('Status', isEqualTo: 'notintrested')
       .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .snapshots()
       .map((snapshot) => snapshot.docs.length);



   Stream<int> getCurrentTabStream(int tabIndex, HomeController controller) {
     switch (tabIndex) {
       case 0:
         return controller.newLeadsStream;
       case 1:
         return controller.followupLeads;
       case 2:
         return controller.visitfixedLeads;
       case 3:
         return controller.visitdoneLeads;
       case 4:
         return controller.negotiationsLeads;
       case 5:
         return controller.notIntrestedLeads;
       default:
         return Stream.value(0);
     }
   }









   Future<void> getTotalTasks()
  async {

    Stream<QuerySnapshot<Map<String,dynamic>>> tasks= FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
     //  .where("due_date", isLessThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status",
        whereIn: [
          'InProgress',
          'Completed'
        ]
    )
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .snapshots();
   // print(authController.currentUser?.uid);

    tasks.listen((querySnapshot) {
       totaltasks.value=querySnapshot.size;
    //   print("Tasks : $totaltasks");
      for (var doc in querySnapshot.docs) {
      //  print("Task ID: ${doc.id}, Data: ${doc.data()}");
       // print("_________________________");
      }
    });


    var ref=FirebaseFirestore.instance.
    collection("${authController.currentUserObj['orgId']}_assignedTasks");




    var totalTaskList= ref
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("status",
        whereIn: [
          'InProgress',
          'Completed'
        ]
    );
    QuerySnapshot totalleadsquerySnapshot;
    totalleadsquerySnapshot = await totalTaskList.get();
    totalleads.value=totalleadsquerySnapshot.size;






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

