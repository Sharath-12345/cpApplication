import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/BottomPopups/popup_followup_lead.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/leaddetails_controller.dart';
import 'package:saleapp/Screens/LeadDetails/visitdone_leads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeadDetailsScreen extends StatefulWidget
{
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final HomeController homeController=Get.find<HomeController>();
  final AuthController authController=Get.find<AuthController>();
  var controller=Get.put<LeadDetailsController>(LeadDetailsController());
  var argument = Get.arguments;

  var receivedList ;
  var calllogs;
  var currentStatus="new";
  List<Map<String,dynamic>> response=[];
  int timeinmilli=0;


  final SupabaseClient supabase = GetIt.instance<SupabaseClient>();



  Future<void> printRowsByLuid(String luid) async {
    print(luid);
    print('${authController.currentUserObj['orgId']}_lead_call_logs');
    response = await supabase
        .from('${authController.currentUserObj['orgId']}_lead_call_logs') // Replace with actual table name
        .select()
        .eq('Luid', luid); // Filter rows where 'luid' matches

    if (response.isNotEmpty) {
      print("Rows with luid = $luid: $response");
      for(var log in response)
        {
          print(log['type']);
        }
    } else {
      print("No rows found for luid: $luid");
    }
  }

  @override
  void initState() {
    super.initState();
    receivedList=argument["leaddetails"];
    calllogs=argument["calllog"];

    currentStatus="${receivedList['Status']}";
    printRowsByLuid(receivedList.id);


  }



  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    String fetchedText='${receivedList['Project']}';
    printRowsByLuid(receivedList.id);






    return Scaffold(
      backgroundColor:  const Color(0xff0D0D0D),
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
                    color: Colors.white,
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
                   Text("${receivedList['Name']}",style: TextStyle(
                       color: Colors.white,fontWeight: FontWeight.bold,
                       fontFamily: 'SpaceGrotesk',
                     fontSize: 18
                   ),),
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
                       Text("${receivedList['Mobile']}",style: TextStyle(color: Colors.white
                       ,fontWeight: FontWeight.w100,),
                       )
                     ],
                   ),

                 ],
               ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: InkWell(
                    onTap: ()
                    {
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
                      TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        indicatorColor: Colors.black,
                          dividerColor: Colors.black,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          tabs: [
                            Tab(child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2),
                                ),
                                child: Text("New",style: TextStyle(
                                    color:  currentStatus=="new"?Colors.green: Colors.white,
                                   fontFamily: 'SpaceGrotesk'
                                ),)
                            ),),
                            Tab(child: InkWell(
                              onTap: ()
                              {
                                if(!(currentStatus=="followup"))
                                  {
                                    showBottomPopup(context,"Followup");
                                  }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(

                                        color: Colors.white,
                                        width: 2),
                                  ),
                                  child: Text("Followup",style: TextStyle(
                                      color:  currentStatus=="followup"?Colors.green: Colors.white,
                                      fontFamily: 'SpaceGrotesk'
                                  ),)
                              ),
                            ),),
                            Tab(
                              child: InkWell(
                                onTap: ()
                                {
                                  if(!(currentStatus=="visitfixed"))
                                  {
                                    showBottomPopup(context,"Visit Fixed");
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Text("Visit Fixed",style: TextStyle(
                                      color:  currentStatus=="visitfixed"?Colors.green: Colors.white,
                                      fontFamily: 'SpaceGrotesk'
                                  ),)
                                                            ),
                              ),),
                            Tab(
                              child: InkWell(
                                onTap: ()
                                {
                                   Get.to(()=>VisitDoneLeads());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Text("Visit Done",style: TextStyle(
                                      color:  currentStatus=="visitdone"?Colors.green: Colors.white,
                                      fontFamily: 'SpaceGrotesk'
                                  ),)
                                                            ),
                              ),),
                            Tab(child: InkWell(
                              onTap: ()
                              {
                                Get.to(()=>VisitDoneLeads());
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Text("Not Intrested",style: TextStyle(
                                      color:  currentStatus=="notintrested"?Colors.green: Colors.white,
                                      fontFamily: 'SpaceGrotesk'
                                  ),)
                              ),
                            ),),
                            Tab(child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text("Junk", style: TextStyle(
                                    color:  currentStatus=="new"?Colors.green: Colors.white,
                                    fontFamily: 'SpaceGrotesk'
                                ),)
                            ),),

                          ]
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
                    color : Color.fromRGBO(28, 28, 30, 1),
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
                                child: Text("P",style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: 12),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color : Color.fromRGBO(89, 66, 60, 1),
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
                                  color: Colors.white,fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'SpaceGrotesk',

                                ),),
                                Text("Project",style: TextStyle(
                                  color: Colors.white,
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
                    color : Color.fromRGBO(28, 28, 30, 1),
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
                                child: Text("E",style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold,fontSize: 12),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color : Color.fromRGBO(89, 66, 60, 1),
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
                                  color: Colors.white,fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'SpaceGrotesk',

                                ),),
                                Text("Executive",style: TextStyle(
                                    color: Colors.white,
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
                      dividerColor: Colors.black,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.20,
                            decoration: BoxDecoration(
                                color: controller.tabIndex==0?
                            Color(0xff58423B) :Color.fromRGBO(28, 28, 30, 1)
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("0",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text("Tasks",
                                        style: TextStyle(
                                            color: Colors.white,
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
                            decoration: BoxDecoration(color: controller.tabIndex==1?
                            Color(0xff58423B) :Color.fromRGBO(28, 28, 30, 1)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(7, 2, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("0",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text("Call log",
                                        style: TextStyle(
                                            color: Colors.white,
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
                                color: controller.tabIndex==2?
                                Color(0xff58423B) :Color.fromRGBO(28, 28, 30, 1)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(7, 4, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("0",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text("Activity",
                                        style: TextStyle(
                                            color: Colors.white,
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
                    SizedBox(height:height*0.02 ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('you have ', style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),),
                        Text( '0 due events', style: TextStyle(
                          color: Colors.orange,
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          //height: 0.8461538461538461
                        ),)
                      ],
                    ),
                    //SizedBox(height:height*0.01),

                    SizedBox(
                      height: height*0.4,
                      child: TabBarView(
                        children: [
                          Center(child: Text("Tasks Content", style: TextStyle(fontSize: 18,color: Colors.white))),
                          ListView.builder(
                              itemCount: response.length,
                              itemBuilder:(context,index)
                              {
                                final singlelog=response[index];
                                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(singlelog['startTime']);

                                String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                      ),

                                      height: height*0.08,
                                      width: width*0.9,

                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10,0),
                                        child: Row(
                                          children: [
                                            Text("${singlelog['type']}"),
                                            SizedBox(width: width*0.02,),
                                            Text("${singlelog['duration']}s"),
                                            Spacer(),
                                            Text("${formattedDate}"),

                                          ],
                                        ),
                                      ),

                                    ),
                                    Divider(color: Colors.black,height: 3,)
                                  ],
                                );

                              }

                          ),
                          Center(child: Text("Activity Content", style: TextStyle(fontSize: 18,color: Colors.white))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),






           SizedBox(height: 15,),

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
      ) ,
    );
  }
}