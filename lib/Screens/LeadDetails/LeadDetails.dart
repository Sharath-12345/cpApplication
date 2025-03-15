import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';

class LeadDetailsScreen extends StatefulWidget
{
  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final HomeController homeController=Get.find<HomeController>();




  @override
  Widget build(BuildContext context) {
    var receivedList = Get.arguments ?? [];
    String fetchedText='${receivedList['Project']}';

    print('${receivedList['assignedToObj']['roles'][0]}');
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
                      homeController.makedirectcall(receivedList['Mobile']);
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Text("New",style: TextStyle(
                      color: Colors.white,fontFamily: 'SpaceGrotesk'
                    ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text("Followup",style: TextStyle(
                          color: Colors.lightGreen,
                          fontFamily: 'SpaceGrotesk'
                      ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text("Visit Done",style: TextStyle(
                          color: Colors.white,fontFamily: 'SpaceGrotesk'
                      ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text("Visit Fixed",style: TextStyle(
                          color: Colors.white,fontFamily: 'SpaceGrotesk'
                      ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text("Not Intrested",style: TextStyle(
                          color: Colors.white,fontFamily: 'SpaceGrotesk'
                      ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text("Bunk",style: TextStyle(
                          color: Colors.white,fontFamily: 'SpaceGrotesk'
                      ),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      )
                  ),


                ],
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.46,
                  height:  MediaQuery.of(context).size.height*0.07,
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
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(28, 28, 30, 1),
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  width: MediaQuery.of(context).size.width*0.46,
                  height:  MediaQuery.of(context).size.height*0.07,
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
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(28, 28, 30, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width * 0.20,
                   child: Center(
                     child: Padding(
                       padding: EdgeInsets.fromLTRB(7, 7, 10, 8),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("0",style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold
                             ),),
                             Text("Tasks",style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                               fontFamily: 'SpaceGrotesk',
                               fontSize: 14
                             ),)
                           ],
                       ),
                     ),
                   ),
                   decoration: BoxDecoration(
                     color: Color(0xff58423B),
                   ),
                ),
                SizedBox(width: 12,),
                Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(7, 7, 10, 8),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("0",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                          Text("Call log",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14
                          ),)
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(28, 28, 30, 1),
                  ),
                ),
                SizedBox(width: 12,),
                Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(7, 7, 10, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("0",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                          Text("Activity",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14
                          ),)
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(28, 28, 30, 1),
                  ),
                )
              ],
            ),
            SizedBox(height: 15,),
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
            SizedBox(height: 15,),
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


          ],
             ),
      ) ,
    );
  }
}