import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Profile/profile_controller.dart';

class DashboardScreen extends StatefulWidget
{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final  profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
     return Obx(
         ()=> Scaffold(
           backgroundColor: (profileController.isLightMode==true)? Colors.white :
           Color(0xff0D0D0D),
       ),
     );
  }
}