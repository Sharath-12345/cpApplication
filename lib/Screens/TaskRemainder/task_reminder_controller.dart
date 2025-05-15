// controllers/task_reminder_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saleapp/Auth/auth_controller.dart';

class TaskReminderController extends GetxController {

  final authController=Get.find<AuthController>();



  var selectedYear = DateTime.now().year.obs;
  var selectedDate = DateTime.now().day.obs;
  var selectedFilterIndex = 0.obs;
  var totaltasks=0.obs;
  var completedtasks=0.obs;
  var inprogresstasks=0.obs;
  var pendingtasks=0.obs;
  var totaltasklist= <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  var completedtasklist= <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  var inprogresstasklist= <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  var pendingtasklist= <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;




  // Data lists
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  final currentMonthIndex = DateTime.now().month - 1;
  var selectedMonth;



   List<String> filters = ['All 5', 'To Do 2', 'Completed 4', 'Pending 1'].obs;
  
  /* var tasks = [
    /*Task(
      time: '07:00 PM',
      project: 'Shuba Ecostone-131',
      description: 'Collect Payment for "Completion of Second Slab"',
      status: 'Pending',
      statusColor: Color(0xFFFFD7D7),
    ),
    Task(
      time: '05:00 PM',
      project: 'Green Valley-245',
      description: 'Site Inspection with Client',
      status: 'In-Progress',
      statusColor: Color(0xFFFFF3D7),
    ),
    Task(
      time: '03:00 PM',
      project: 'Sky Towers-178',
      description: 'Finalize Interior Design Plans',
      status: 'Completed',
      statusColor: Color(0xFFD7FFDF),
    ),*/
  ].obs;*/
  var tasks= <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  // Getters
  int get selectedMonthIndex => months.indexOf(selectedMonth.value) + 1;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedMonth = months[currentMonthIndex].obs;
    getTotalTasks();
    getCompletedTasks();
    getPendingtasks();
    getInProgressTasks();
   updatefilters();
   tasks=totaltasklist;
  }


  // Actions

  Future<void> getTotalTasks()
  async {

     var tasks2= await FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
       // .where("due_date", isLessThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status",
        whereIn: [
        'InProgress',
          'Completed',
          'Pending'
        ]
      //  isEqualTo: "InProgress"
        )
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .get();
        //.snapshots();
    // totaltasklist.assignAll();
     totaltasklist.assignAll(tasks2.docs);
      totaltasks.value=tasks2.docs.length;
     // print(totaltasklist[0]);



  }

  Future<void> getCompletedTasks()
  async {

    var tasks= await FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
        //.where("due_date", isLessThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status",
        whereIn: [
          'Completed',
        ]
      //  isEqualTo: "InProgress"
    )
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .get();
    //.snapshots();

    completedtasklist.assignAll(tasks.docs);
    completedtasks.value=tasks.docs.length;





  }


  Future<void> getInProgressTasks()
  async {

    var tasks= await FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
        .where("due_date", isGreaterThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status",
        whereIn: [
          'InProgress',
        ]
      //  isEqualTo: "InProgress"
    )
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .get();
    //.snapshots();

    inprogresstasklist.assignAll(tasks.docs);
     inprogresstasks.value=tasks.docs.length;




  }


  Future<void> getPendingtasks()
  async {

    var tasks= await FirebaseFirestore.instance
        .collection('${authController.currentUserObj['orgId']}_assignedTasks')
        .where("due_date", isLessThanOrEqualTo: DateTime.now().microsecondsSinceEpoch)
        .where("status",
        whereIn: [

          'InProgress'
        ]
      //  isEqualTo: "InProgress"
    )
        .where("to_uid", isEqualTo: authController.currentUser?.uid)
        .get();
    //.snapshots();

   pendingtasklist.assignAll(tasks.docs);
    pendingtasks.value=tasks.docs.length;


  }


  void updatefilters()
  {
    filters = ['All ${totaltasks.value}', 'To Do ${inprogresstasks}',
      'Completed ${completedtasks}', 'Pending ${pendingtasks}'];
  }

  void updateSelectedDate(int day, int monthIndex, int year) {
    selectedDate.value = day;
    selectedMonth.value = months[monthIndex - 1];
    selectedYear.value = year;
    update();
  }

  void changeFilter(int index) {


    if (index == 0) {
      getTotalTasks();
      tasks.assignAll(totaltasklist);
    } else if (index == 1) {
      tasks.assignAll(inprogresstasklist);
    } else if (index == 2) {
      tasks.assignAll(completedtasklist);
    } else if (index == 3) {
      tasks.assignAll(pendingtasklist);
    }
    print(tasks.length);
   selectedFilterIndex.value = index;

    update();

  }

  void completeTask(Task task) {
    final index = tasks.indexOf(task);
   // tasks[index] = task.copyWith(status: 'Completed');
    update();
  }
}

class Task {
  final String time;
  final String project;
  final String description;
  final String status;
  final Color statusColor;

  Task({
    required this.time,
    required this.project,
    required this.description,
    required this.status,
    required this.statusColor,
  });

  Task copyWith({
    String? time,
    String? project,
    String? description,
    String? status,
    Color? statusColor,
  }) {
    return Task(
      time: time ?? this.time,
      project: project ?? this.project,
      description: description ?? this.description,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}