import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_status_change_lead_controller.dart';
import 'package:saleapp/Screens/LeadDetails/visitdoneleads_controller.dart';
import 'package:saleapp/Utilities/snackbar.dart';

class VisitDoneLeads extends StatefulWidget
{
  const VisitDoneLeads({super.key});

  @override
  State<VisitDoneLeads> createState() => _VisitDoneLeadsState();
}

class _VisitDoneLeadsState extends State<VisitDoneLeads> with SingleTickerProviderStateMixin {
  final VisitDoneLeadsController visitDoneLeadsController=Get.put<
      VisitDoneLeadsController>(VisitDoneLeadsController());
  var  leaddetails = Get.arguments;
  final statuschangeleadcontroller=Get.find<StatusChangeLead>();
  final authController=Get.find<AuthController>();
  final user=FirebaseAuth.instance.currentUser;

  late  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
  var orgId=authController.currentUserObj['orgId'];
  var projectId=leaddetails['ProjectId'];
  var leadDocId=leaddetails.id;
  var  oldStatus=leaddetails['Status'];
  var newStatus="visitdone";
  print(newStatus);
  var by=leaddetails['assignedToObj']['name'];
  var leadname=leaddetails['Name'];
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(


      body:   SingleChildScrollView(
        child: Center(
            child: SizedBox(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                ),
              ),
                    Text("How was Site Visit Journey",style:
                    TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height*0.022,
                      fontFamily: 'SpaceGrotesk'
                    ),),
                    SizedBox(height: height*0.04,),
                    SizedBox(
                        width: width*0.83,
                        child: DefaultTabController(
                            length: 4,
                            initialIndex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              TabBar(
                                controller: _tabController,
                              indicatorColor: Colors.white,
                              dividerColor: Colors.white,
                              tabs: [
                            Tab(child:
                            Icon (Icons.sentiment_very_dissatisfied,
                              color:_tabController.index==0?
                                  Colors.blue:
                              Colors.black,
                              size: height*0.05,)),
                        Tab(child: Icon(Icons.sentiment_dissatisfied,
                          color:_tabController.index==1?
                          Colors.blue:
                          Colors.black,size: height*0.05,)),
                        Tab(child: Icon(Icons.sentiment_satisfied,
                          color:_tabController.index==2?
                          Colors.blue:
                          Colors.black,size: height*0.05,)),
                        Tab(child: Icon(Icons.sentiment_very_satisfied,
                          color:_tabController.index==3?
                          Colors.blue:
                          Colors.black,size: height*0.05,),)
                        ]
                    )
                  ]
              )
                      ),
              ),
        
                    SizedBox(height: 20,),
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
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
        
                          ),
                          SizedBox(width: width*0.05,),
                          Text("Site Visit Feedback",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height*0.020,
                              fontFamily: 'SpaceGrotesk'
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width*0.65,
                      child: Center(
                          child: EmotionCheckboxWidget()
                      ),
                    ),
        
                    SizedBox(height: height*0.03,),
        
                    Container(
                      height: height*0.15,
                      width: width*0.9,
                      padding: EdgeInsets.only(left: 4),
                     // margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
        
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: height*0.017),
                        decoration: InputDecoration(
                          hintText: "Type and make additional notes",
                          border: InputBorder.none,
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


                              /*
                              var y = "Make a Visit Done call to $leadname";
                              final data = {
                                "stsType": "Visit Done" ?? "none",
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
                              snackBarMsg("Status Updated");*/

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
                                        padding: const EdgeInsets.only(left: 19),
                                        child: Text("VISIT DONE",style: TextStyle(color: Colors.white,
                                        fontFamily: 'SpaceGrotesk'),),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
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
        
            ),
      )
    );
  }
}


class EmotionCheckboxWidget extends StatefulWidget {
  const EmotionCheckboxWidget({super.key});

  @override
  _EmotionCheckboxWidgetState createState() => _EmotionCheckboxWidgetState();
}

class _EmotionCheckboxWidgetState extends State<EmotionCheckboxWidget> {
  int? selectedIndex=0; // Stores the selected checkbox index

  final List<String> emotions = ["Happy", "Sad", "Neutral", "Want More Options", "Others"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(emotions.length, (index) {
        return CheckboxListTile(
          title: Text(emotions[index],style:
            TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: MediaQuery.of(context).size.height*0.017
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
