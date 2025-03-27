import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusChangeLead extends GetxController
{

  Future<void> closePreviousTasks({
    required String orgId,
    required String leadId,
  })
  async {


    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('${orgId}_leads_sch').doc(leadId);

    // Fetch document data
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> updatedData = {}; // Store updates

      // Loop through each field in the document
      data.forEach((key, value) {
        // Check if the field is a map
        if (value is Map<String, dynamic>) {
          // If 'status' exists and is 'pending', update it to 'completed'
          if (value.containsKey("sts") && value["sts"] == "pending") {
            updatedData[key] = {...value, "sts": "completed"}; // Update map
          }
        }
      });

      // Update Firestore document if there are changes
      if (updatedData.isNotEmpty) {
        await docRef.update(updatedData);
        print("Statuses updated successfully!");
      } else {
        print("No pending statuses found.");
      }
    }

    updateArrayStatuses(orgId: orgId, leadId: leadId);




  }


  Future<void> updateArrayStatuses({
    required String orgId,
    required String leadId,
}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('${orgId}_leads_sch').doc(leadId);

    // Your specific array name
    String targetArrayName = "staA"; // Change this to your  actual array name

    // Fetch document data
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Check if the specific array exists and is a List
      if (data.containsKey(targetArrayName) && data[targetArrayName] is List) {
        List<dynamic> arrayData = data[targetArrayName];

        // Replace "pending" with "completed"
        List<dynamic> updatedArray = arrayData.map((item) {
          return (item is String && item == "pending") ? "completed" : item;
        }).toList();

        // Update Firestore with the modified array
        await docRef.update({targetArrayName: updatedArray});
        print("Array updated successfully!");
      } else {
        print("Array not found or not a List.");
      }
    }
  }





  Future<void> closeAllPreviousTasks({
    required String orgId,
  //  required String id,
    required String closingComments,
    required List<Map<String, dynamic>> leadSchFetchedData,
   required String newStatus,
   required Map<String, dynamic> data,
   // required Function(Map<String, dynamic>) doneFun,
   // required Function(String, String, String, String, int, String) incrementTaskCompletedCount,
    required String userId,
     required String ddMy,
    required String leadStatus,
    required int tomorrowDate,
    required BuildContext context,
   required String leadid
  }) async {
    try {

      List<Map<String, dynamic>> pendingTaskAObj = leadSchFetchedData
          .where((d) => d['schTime'] != null && d['sts'] == 'pending')
          .toList();



      for (var pendObj in pendingTaskAObj) {
        // Add closing comment
        pendObj['comments'] = [
          {
            'c': closingComments,
            't': Timestamp.now().millisecondsSinceEpoch + 21600000, // 6 hours added
          },
          ...(pendObj['comments'] ?? []),
        ];

        var uid=FirebaseAuth.instance.currentUser!.uid;
       await editAddTaskCommentDB(orgId: orgId, uid: uid,
           kId: pendObj['ct'], oldSch: pendObj);


        List<String> SchStsMA=[];
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot docSnapshot =
        await firestore.collection('${orgId}_leads_sch').doc(leadid).get();

        if (docSnapshot.exists) {
         SchStsMA= List<String>.from(docSnapshot['SchStsMA']);
          print("Retrieved Strings: $SchStsMA");
        } else {
          print("Document does not exist");
        }


        List<String> SchStsA=[];

        DocumentSnapshot docSnapshot2 =
        await firestore.collection('${orgId}_leads_sch').doc(leadid).get();

        if (docSnapshot.exists) {
          SchStsA= List<String>.from(docSnapshot2['SchStsA']);
          print("Retrieved Strings: $SchStsA");
        } else {
          print("Document does not exist");
        }




        await doneFun(orgId: orgId,
            uid:uid , data: data,
            schStsMA: SchStsMA, schStsA:
            SchStsA
            );


        // Increment completed task count if schTime < tomorrowDate
        if (pendObj['schTime'] < tomorrowDate) {

          await incrementTaskCompletedCount(orgId: orgId,
              userId: userId, ddMy: ddMy, newSt: '${leadStatus}_comp',
              todayTasksIncre: 1, txt:  'A Task Closed by change status');

        }
      }



    } catch (e) {

    }
  }
  Future<void> doneFun({
    required String orgId,
    required String uid,
    required Map<String, dynamic> data,
    required List<String> schStsMA,
    required List<String> schStsA,
   // required Function(String, String, String, String, List<String>) updateSchLog,
   // required Function(List<String>) setSchStsA,
  }) async {
    try {

     int index = schStsMA.indexOf(data['ct']);


      if (index != -1) {
        List<String> updatedSchStsA = List.from(schStsA);
        updatedSchStsA[index] = 'completed';
       // setSchStsA(updatedSchStsA); // Update state


        await updateSchLog(
            orgId: orgId, uid: uid, kId: data['ct'],
            newStat:  'completed',
           schStsA:schStsA
            );
     }
    } catch (e) {
      print("Error in doneFun: ${e.toString()}");
    }
  }
  Future<void> updateSchLog({
    required String orgId,
    required String uid,
    required String kId,
    required String newStat,
    required List<String> schStsA,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Constructing dynamic field names
      String statusField = "$kId.sts";
      String commentTimeField = "$kId.comT";

      // Updating Firestore document in _leads_sch collection
      await firestore.collection("${orgId}_leads_sch").doc(uid).update({
       "staA": schStsA,
        statusField: newStat,
        commentTimeField: Timestamp.now().millisecondsSinceEpoch + 21600000, // 6 hours added
      });

    } catch (e) {
      print("Error in updateSchLog: ${e.toString()}");
    }
  }

 

  Future<void> editAddTaskCommentDB({
    required String orgId,
    required String uid,
    required String kId,
    //required String newStat,
    //required List<String> schStsA,
    required Map<String, dynamic> oldSch,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;


      List<dynamic> comments = oldSch['comments'] ?? [];
      dynamic schTime = oldSch['schTime'];

      print('Comments are: $comments');

      await firestore.collection('${orgId}_leads_sch').doc(uid).update({
        '${kId}.comments': comments,
        '${kId}.schTime': schTime,
      });

      // If comments exist, update the latest remark in _leads collection
      if (comments.isNotEmpty) {
        String latestComment = comments[0]['c'];
        await firestore.collection('${orgId}_leads').doc(uid).update({
          'Remarks': latestComment,
        });
      }

    } catch (e) {
      print('Error in editAddTaskCommentDB: ${e.toString()}');
    }
  }



 Future<void> incrementTaskCompletedCount({
   required String orgId,
   required String userId,
   required String ddMy,
   required String newSt,
   required int todayTasksIncre,
   required String txt,
 }) async {
   try {
     FirebaseFirestore firestore = FirebaseFirestore.instance;

     // Reference to the Firestore document
     DocumentReference docRef = firestore
         .collection("${orgId}_emp_performance")
         .doc("${userId}DD${ddMy}");

     print("IncrementTaskCompletedCount");

     // Update the document with incremented values
     await docRef.update({
       newSt: FieldValue.increment(todayTasksIncre), // Increment specific status
       "all_comp": FieldValue.increment(todayTasksIncre), // Increment total count
       "recA": FieldValue.arrayUnion([
         {"tx": txt, "T": DateTime.now().millisecondsSinceEpoch} // Log entry
       ]),
     });
   } catch (error) {
     print("Error updating employee performance: $error");
   }
 }



  Future<void> addNewMap({
    required String orgId,
    required String leadId,
    required String by,
    required String notes,
    required String pri,
    required String sts,
    required String schedule,
}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('${orgId}_leads_sch').doc(leadId);

    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> newMap = {
      "by" : by,
      "ct" : currentTimeMillis,
      "notes" : notes,
      "pri" : pri,
      "schTime" : currentTimeMillis,
      "sts" : sts,
      "type" : schedule
    };

    // Choose a unique key name for the new map (change 'new_map_key' to your desired name)
    String newMapKey = currentTimeMillis.toString();

    // Update Firestore by adding the new map
    await docRef.update({
      newMapKey: newMap
    });
    addPendingToStaA(orgId: orgId, leadId: leadId,ct: currentTimeMillis);
  }




  Future<void> addPendingToStaA({
    required String orgId,
    required String leadId,
    required int ct,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('${orgId}_leads_sch').doc(leadId);

    // Fetch the current document data
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Check if 'staA' exists and is a List
      if (data.containsKey("staA") && data["staA"] is List) {
        List<dynamic> staAList = List.from(data["staA"]); // Convert to mutable list

        // Add "pending" to the list
        staAList.add("pending");

        // Update Firestore with the modified list
        await docRef.update({"staA": staAList});

        print("Added 'pending' to staA array!");
      } else {
        print("staA array not found.");
      }



      if (data.containsKey("staDA") && data["staDA"] is List) {
        List<dynamic> staDAList = List.from(data["staDA"]); // Convert to mutable list

        // Add "pending" to the list
        staDAList.add(ct);

        // Update Firestore with the modified list
        await docRef.update({"staDA": staDAList});

        print("Added 'ct' to staDA array!");
      } else {
        print("staA array not found.");
      }






    }
  }






 Future<void> addLeadScheduler({
    required String orgId,
    required String did,
    required Map<String, dynamic> data,
    required String schStsA,
    String? assignedTo,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;


      String fieldName = data['ct'];

      Map<String, dynamic> updateData = {
        "staA": schStsA,
        "staDA": FieldValue.arrayUnion([fieldName]),
        fieldName: data,
      };

      DocumentReference docRef = firestore.collection("${orgId}_leads_sch").doc(did);

      print("Check addLeadLog: $docRef");

      // Try updating document
      await docRef.update(updateData);
    } catch (error) {
      print("Error in update, trying set: ${error.toString()}");

      FirebaseFirestore firestore = FirebaseFirestore.instance;


      Map<String, dynamic> newData = {
        "staA": schStsA,
        "staDA": [data['ct']],
        data['ct'].toString(): data,
        "assignedTo": assignedTo ?? "",
      };

      // Setting the document if update fails
      await firestore.collection("${orgId}_leads_sch").doc(did).set(newData);
    }

    print("Completed addLeadLog");
  }



















  Future<void> updateLeadStatus({
    required String orgId,
    required String projectId,
    required String leadDocId,
    required String oldStatus,
    required String newStatus,
    required String by,
    required BuildContext context,
  }) async {
    try {
      print('Updating lead: $leadDocId to status: $newStatus');


      FirebaseFirestore firestore = FirebaseFirestore.instance;


      await firestore.collection('${orgId}_leads').doc(leadDocId).update({
        'Status': newStatus,
        'coveredA': FieldValue.arrayUnion([oldStatus]),
        'stsUpT': Timestamp.now().millisecondsSinceEpoch,
        'leadUpT': Timestamp.now().millisecondsSinceEpoch,
      });

      final SupabaseClient supabase = GetIt.instance<SupabaseClient>();
      final response = await supabase.from('${orgId}_lead_logs').insert([
        {
          'type': 'sts_change',
          'subtype': oldStatus,
          'T': Timestamp.now().millisecondsSinceEpoch,
          'Luid': leadDocId,
          'by': by,
          'payload': {},
          'from': oldStatus,
          'to': newStatus,
          'projectId': projectId,
        }
      ]);

      if (response.error != null) {
        throw Exception('Supabase Error: ${response.error!.message}');
      }



    } catch (e) {


    }
  }

}