import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/Profile/profile_controller.dart';

class ProfileScreen extends StatefulWidget
{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController=Get.find<AuthController>();
  final HomeController homeController=Get.find<HomeController>();

 // final ProfileController profileController=Get.put<ProfileController>(ProfileController());
  @override
  Widget build(BuildContext context) {
    var totalleads=homeController.totalleads.value.toString();


   var  name=authController.currentUserObj['name']?? " ";
   var email=authController.currentUserObj['email']?? " ";
   var role="";
    if (authController.currentUserObj != null &&
        authController.currentUserObj['roles'] != null &&
        authController.currentUserObj['roles'].isNotEmpty) {
      role = authController.currentUserObj['roles'][0] ?? " ";
    }

    return Scaffold(
      backgroundColor:  const Color(0xff0D0D0D),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 45, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width*0.03,
                  decoration: BoxDecoration(
                      borderRadius : BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3),
                        bottomLeft: Radius.circular(3),
                        bottomRight: Radius.circular(3),
                      ),
                      color : Color.fromRGBO(189, 161, 238, 1)),
                ),
                SizedBox(width: 12,),
                Text("My Profile",style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                    // fontWeight: FontWeight.bold,
                    fontSize: 18
                ),)
              ],
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.height*0.15,
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color : Color.fromRGBO(240, 240, 240, 1),
              ),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 15,0, 0),
                    child: Text( name, style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      //fontFamily: 'SpaceGrotesk',
                      fontSize: 20,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 5,0, 0),
                    child: Text(email, style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      //fontFamily: 'SpaceGrotesk',
                      fontSize: 12,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w100,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0,0, 0),
                    child: Text(role, style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      // fontFamily: 'SpaceGrotesk',
                      fontSize: 12,
                      letterSpacing: 0,
                      //fontWeight: FontWeight.normal,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0,0, 0),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "See more",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              // fontFamily: 'SpaceGrotesk',
                              fontSize: 12,
                              letterSpacing: 0,
                              //fontWeight: FontWeight.normal,
                            ),
                          ),
                          const Divider(
                            height: 0,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  )


                ],
              ),

            ),
            SizedBox(height: 25,),
            Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.height*0.1,
              color : Color.fromRGBO(28, 28, 30, 1),
              child:  Row(

                children: [
                  Expanded(
                    child: Container(

                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "0",
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Calls",
                              style: TextStyle(fontSize: 15, color: Colors.white,fontFamily: "SpaceGrotesk"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1, // Divider width
                    height: MediaQuery.of(context).size.height*0.06,  // Divider height
                    color: Colors.white, // Divider color
                  ),



                  Expanded(
                    child: Container(

                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                          totalleads
                          ,
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(fontSize: 15, color: Colors.white,fontFamily: "SpaceGrotesk"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 1, // Divider width
                    height: MediaQuery.of(context).size.height*0.06,  // Divider height
                    color: Colors.white, // Divider color
                  ),




                  Expanded(
                    child: Container(

                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "0",
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Bookings",
                              style: TextStyle(fontSize: 15, color: Colors.white,fontFamily: "SpaceGrotesk"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ),
            SizedBox(height: 40,),
            Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.height*0.27,
              color : Color.fromRGBO(28, 28, 30, 1) ,
              child: Column(
                children: [

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.notifications,color: Colors.brown,
                            size: 27,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Notofications",
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text("Tasks,Calls,Remainder",
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 12
                                ),)
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "0",
                            style: TextStyle(
                              // fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                        SizedBox(width: 4,),
                        Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.chevron_right,color: Colors.brown,),
                        )
                      ],
                    ),
                  ),


                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.delete,color: Colors.brown,
                            size: 27,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Delete Account",
                                style: TextStyle(color: Colors.white,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text("Remove accounts from Redefine",
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 12
                                ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.privacy_tip_outlined,color: Colors.brown,
                            size: 27,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Privacy Policy",
                                style: TextStyle(color: Colors.white,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text("Data Privacy",
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 12
                                ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.power_settings_new,color: Colors.brown,
                  size: 27,),
                SizedBox(width: 9,),
                InkWell(
                  onTap: ()=> authController.logout(),
                  child: Text("Logout",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      fontSize: 18,
                      fontFamily: 'SpaceGrotesk'
                  ),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}