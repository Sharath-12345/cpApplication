import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Dashboard/dashboard_screen.dart';
import 'package:saleapp/Screens/Home/home_screen.dart';
import 'package:saleapp/Screens/Profile/profile_screen.dart';
import 'package:saleapp/Screens/Search/search_screen.dart';
import 'package:saleapp/Screens/SuperHomePage/superhomepage_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Auth/auth_controller.dart';

class SuperHomePage extends StatefulWidget
{
  @override
  State<SuperHomePage> createState() => _SuperHomePageState();
}

class _SuperHomePageState extends State<SuperHomePage> {
  final AuthController authController = Get.find<AuthController>();
  SuperHomePageController superhomepagecontroller=Get.put(SuperHomePageController());

  Future<void> printuserdetails()
  async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve individual string values
    String name = prefs.getString('name') ?? 'No Name';
    String email = prefs.getString('email') ?? 'No Email';
    String orgId = prefs.getString('orgId') ?? 'No Org ID';
    String orgName = prefs.getString('orgName') ?? 'No Org Name';
    String empId = prefs.getString('empId') ?? 'No Emp ID';
    String uid = prefs.getString('uid') ?? 'No UID';
    String offPh = prefs.getString('offPh') ?? 'No Office Phone';
    String perPh = prefs.getString('perPh') ?? 'No Personal Phone';
    String userStatus = prefs.getString('userStatus') ?? 'No Status';
    String userFcmtoken = prefs.getString('user_fcmtoken') ?? 'No FCM Token';
    String avatarUrl = prefs.getString('avatorUrl') ?? 'No Avatar URL';

    List<String> department = prefs.getStringList('department') ?? [];
    List<String> roles = prefs.getStringList('roles') ?? [];
    List<String> projAccessA = prefs.getStringList('projAccessA') ?? [];

    print("Department: $department");
    print("Roles: $roles");
    print("Project Access A: $projAccessA");

    // Print all retrieved values
    print("User Name: $name");
    print("User Email: $email");
    print("Org ID: $orgId");
    print("Org Name: $orgName");
    print("Emp ID: $empId");
    print("UID: $uid");
    print("Office Phone: $offPh");
    print("Personal Phone: $perPh");
    print("User Status: $userStatus");
    print("User FCM Token: $userFcmtoken");
    print("Avatar URL: $avatarUrl");
    print("Department: $department");
    print("Roles: $roles");
    print("Project Access A: $projAccessA");
  }

  void initState()
  {
    //getUserDetails();
    printuserdetails();

 }


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
       // backgroundColor:  const Color(0xff0D0D0D),
      
      
        body: IndexedStack(
          index: superhomepagecontroller.tabIndex.value,
          children: [HomePage(),DashboardScreen(),SearchScreen(),ProfileScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor:const Color(0xff0D0D0D),
            currentIndex: superhomepagecontroller.tabIndex.value,
            onTap: superhomepagecontroller.chnageTabIndex,
            //unselectedItemColor: Colors.grey,
          // selectedItemColor: Colors.green,
            items: [

              BottomNavigationBarItem(label: '', icon: Icon(Icons.home
              ,color: Color(0xffD9886A),)),
              BottomNavigationBarItem(label: '', icon: Icon(Icons.dashboard,
                 color:  Color(0xffD9886A))),
              BottomNavigationBarItem(label: '', icon: Icon(Icons.search,
                  color:  Color(0xffD9886A))),
              BottomNavigationBarItem(label: '', icon: Icon(Icons.person,
                  color:  Color(0xffD9886A))),

            ]),
      
      
      ),
    );

  }

}