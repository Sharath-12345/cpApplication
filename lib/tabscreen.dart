import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController {
  var selectedIndex = 0.obs; // Observes which tab is selected
}

class TabScreen extends StatelessWidget {
  final TabControllerX controller = Get.put(TabControllerX());

  final List<String> tabTitles = [
    "New",
    "Follow Up",
    "Visit Fixed",
    "Visit Done",
    "Negotiation"
  ];

  final List<Color> tabColors = [
    Color.fromRGBO(30, 30, 30, 1),
    Color.fromRGBO(89, 66, 60, 1),
    Color.fromRGBO(30, 30, 30, 1),
    Color.fromRGBO(30, 30, 30, 1),
    Color.fromRGBO(30, 30, 30, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      appBar: AppBar(title: Text("Tab Implementation")),
      body: Column(
        children: [
          // Horizontal Scrollable Tabs


          SizedBox(height: 20), // Spacing between tabs and content

          // Content Based on Selected Tab
          Expanded(
            child: Obx(
                  () {
                switch (controller.selectedIndex.value) {
                  case 0:
                    return _buildNotificationList("New Notifications");
                  case 1:
                    return _buildNotificationList("Follow Up Notifications");
                  case 2:
                    return _buildNotificationList("Visit Fixed Notifications");
                  case 3:
                    return _buildNotificationList("Visit Done Notifications");
                  case 4:
                    return _buildNotificationList("Negotiation Notifications");
                  default:
                    return Center(child: Text("Invalid Selection"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(String title) {
    return ListView.builder(
      itemCount: 10, // Dummy data count
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.notifications, color: Colors.white),
          title: Text(
            "$title - Item ${index + 1}",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text("Notification details", style: TextStyle(color: Colors.grey)),
        );
      },
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    theme: ThemeData.dark(), // Dark theme
    home: TabScreen(),
  ));
}
