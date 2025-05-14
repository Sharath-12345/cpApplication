import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Auth/auth_controller.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Black Header (40% of screen)
                      Container(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        color: Colors.black,
                        padding: EdgeInsets.only(left: 20, bottom: 30),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Sales Team Only\nTell us your login\ndetails.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // White Section
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.03),

                              // Email Field
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                 // labelText: "Email",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.check_circle, color: Colors.green),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Password Field
                              TextField(
                                controller: passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Checkbox for Call & Activity Logs
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text("Allow to capture call and other activity logs"),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Agree & Continue Button
                              Obx(
                                ()=> SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Handle login
                                      String email = emailController.text.trim();
                                      String password = passwordController.text.trim();
                                      authController.login(email, password);
                                    },
                                    child:
                                    (authController.isLoading.value==false)?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Agree & Continue",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ):
                                    CircularProgressIndicator(color: Colors.white,)
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}