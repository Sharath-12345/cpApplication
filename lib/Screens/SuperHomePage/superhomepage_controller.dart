import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SuperHomePageController extends GetxController
{
  RxInt tabIndex = 0.obs;
  chnageTabIndex(int index) {
    tabIndex(index);
  }


   Future<dynamic> getUserDetails() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    var userData;

    if (querySnapshot.docs.isNotEmpty) {
       userData = querySnapshot.docs.first.data();
    } else {
      print("No user found!");
    }
    return userData;
  }
}




