

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Auth/auth_controller.dart';
Future<String?> showBottomPopupProjects(BuildContext context, String? currentSelectedProject) async {
  final authController=Get.find<AuthController>();
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      String? selectedProject = currentSelectedProject;

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(12),
            height: MediaQuery.of(context).size.height * 0.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("${authController.currentUserObj['orgId']}_projects").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No projects found.'));
                }

                return ListView(
                  children: [
                    // 1. All Projects Option
                    Column(
                      children: [
                        ListTile(
                          tileColor: selectedProject == "All Projects" ? Colors.blue.shade100 : null,
                          title: Text(
                            "All Projects",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: MediaQuery.of(context).size.height * 0.018,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, "All Projects");
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Divider(),
                        ),
                      ],
                    ),

                    // 2. List from Firestore
                    ...snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final projectName = data['projectName'] ?? 'Unnamed Project';
                      final projectType = data['projectType']['name'] ?? '';

                      final isSelected = selectedProject == projectName;

                      return Column(
                        children: [
                          ListTile(
                            tileColor: isSelected ? Colors.blue.shade100 : null,
                            title: Text(
                              projectName,
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: MediaQuery.of(context).size.height * 0.018,
                              ),
                            ),
                            trailing: Text(
                              projectType,
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: MediaQuery.of(context).size.height * 0.014,
                              ),
                            ),
                            onTap: () {
                              if (isSelected) {
                                Navigator.pop(context, null); // unselect
                              } else {
                                Navigator.pop(context, projectName); // select
                              }
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Divider(),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );

              },
            ),
          );
        },
      );
    },
  );
}
