
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

import 'Auth/auth_controller.dart';
import 'Screens/Login/login_screen.dart';
import 'Screens/SuperHomePage/superhomepage_screen.dart';
import 'firebase_options.dart';
void getLeadCallLogs(orgId) async {
  final client = GetIt.instance<SupabaseClient>();
  final response = await client
      .from('${orgId}_lead_call_logs')
      .select();
  print(response);




}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<SupabaseClient>(SupabaseClient(
      'https://cezgydfbprzqgxkfcepq.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlemd5ZGZicHJ6cWd4a2ZjZXBxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDU0NTA4NTQsImV4cCI6MTk2'
          'MTAyNjg1NH0.UDAQvbY_GqEdLLrZG6MFnhDWXonAbcYnrHGHDD6-hYU'));

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  // Only allow portrait mode
  ]).then((_) {
    runApp(MyApp());

  });
  getLeadCallLogs("spark");
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


