
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saleapp/Auth/login_screen.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:workmanager/workmanager.dart';

import 'Auth/auth_controller.dart';
import 'Screens/SuperHomePage/superhomepage_screen.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  // Only allow portrait mode
  ]).then((_) {
    runApp(MyApp());

  });
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   final AuthController authController = Get.put(AuthController());
   final HomeController homeController=Get.put(HomeController());
    final currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser?.uid.toString());
    return  GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
        home: currentUser == null ? LoginScreen() : SuperHomePage()

    );
  }
}


