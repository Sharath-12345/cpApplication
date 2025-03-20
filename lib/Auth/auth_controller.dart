import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saleapp/Auth/login_screen.dart';
import 'package:saleapp/Screens/SuperHomePage/superhomepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/snackbar.dart';
import '../helpers/firebase_help.dart';

class AuthController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var currentUserObj = {}.obs;

  final  currentUser = FirebaseAuth.instance.currentUser;
  Rx<User?> firebaseUser = Rx<User?>(null);
  void setOrgId(var newOrgId) {
    print('my value sis c  $newOrgId');
    currentUserObj.assignAll(newOrgId[0].data());
  }
  void getLoggedInUserDetails() async {
    var x = await DbQuery.instanace.getLoggedInUserDetails(currentUser?.uid);
    setOrgId(x);
  }

  @override
  void onInit() {
    getLoggedInUserDetails();
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
          snackBarMsg("Sucess");
          requestCallPermission();
         await storeDetailsInLocal();
        Get.offAll(() => SuperHomePage());


      } catch (e) {
         snackBarMsg("Error! No User Found");
         print(e.toString());
        // snackBarMsg("Error! Please try again");
      }

    }
    else
      {
        snackBarMsg('Error: Invalid credentials');
        debugPrint("Login Failed");
      }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      snackBarMsg('Logged Out');
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> storeDetailsInLocal () async
   {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data(); // Get the first document
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', userData['name'] ?? '');
      await prefs.setString('email', userData['email'] ?? '');
      await prefs.setString('orgId', userData['orgId'] ?? '');
      await prefs.setString('orgName', userData['orgName'] ?? '');
      await prefs.setString('empId', userData['empId'] ?? '');
      await prefs.setString('uid', userData['uid'] ?? '');
      await prefs.setString('offPh', userData['offPh'] ?? '');
      await prefs.setString('perPh', userData['perPh'] ?? '');
      await prefs.setString('userStatus', userData['userStatus'] ?? '');
      await prefs.setString('user_fcmtoken', userData['user_fcmtoken'] ?? '');
      await prefs.setString('avatorUrl', userData['avatorUrl'] ?? '');
      List<String> department = (userData['department'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      List<String> roles = (userData['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      List<String> projAccessA = (userData['projAccessA'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

      await prefs.setStringList('department', department);
      await prefs.setStringList('roles', roles);
      await prefs.setStringList('projAccessA', projAccessA);

    } else {
      print("No user found!");
    }

  }
  Future<void> requestCallPermission() async {
    var status = await Permission.phone.status;
    var status2=await Permission.contacts.status;

    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    if(!status2.isGranted)
      {
        status2=await Permission.contacts.request();
      }

    if (status.isGranted) {

    } else {
      print("Call permission denied");
    }
  }

}