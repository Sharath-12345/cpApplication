import 'package:get/get.dart';
import 'package:saleapp/Screens/SuperHomePage/superhomepage_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController
{
 var isLightMode=false.obs;

 @override
 Future<void> onInit() async {
   super.onInit();
   final prefs = await SharedPreferences.getInstance();
   isLightMode.value=prefs.getBool('isLightMode') ?? false;
 }

 Future<void>  changemode()
 async {
   isLightMode.value=!isLightMode.value;
   final prefs = await SharedPreferences.getInstance();
   await prefs.setBool('isLightMode', isLightMode.value);
 }




}