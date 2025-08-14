
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbSupa {
  static DbSupa get instance => DbSupa._();
  final controller=Get.find<AuthController>();

  late final SupabaseClient _supabaseClient;
  var supabaseClient = GetIt.instance<SupabaseClient>();

  DbSupa._();

  void initialize(SupabaseClient supabaseClient) {
    _supabaseClient = supabaseClient;
  }
  getLeadCallLogs(orgId) async {
    final client = GetIt.instance<SupabaseClient>();
    final response = await client
        .from('${orgId}_lead_call_logs')
        .select();


    // Get existing call logs from Supabase
    final existingCallLogs = response  as List<dynamic>;
    //print('Task inserted successfully ==> ${existingCallLogs}');
    return existingCallLogs;
  }
  Future<String> getProjectValue(var documentid) async {
    String collectionName = '${controller.currentUserObj['orgId']}_leads';
    String documentId = documentid;

    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        print('Project: ${data['Project']}');
        return data['Project'];
      } else {
        print('Document does not exist');
        return "";
      }
    } catch (e) {
      print('Error getting document: $e');
      return "";
    }
  }

  addCallLog(orgId, leadDocId,callLog)async {


    String project=await getProjectValue(leadDocId);
    var uid=FirebaseAuth.instance.currentUser?.uid;
    print(project);




    try
    {

      final existing = await GetIt.instance<SupabaseClient>()
          .from('${orgId}_lead_call_logs')
          .select()
          .eq('startTime',callLog.timestamp!.toInt())
          .eq('Luid', leadDocId);

      if (existing.isEmpty) {
        print("Came into real adding list method");
        print("Lead Uid : ${leadDocId}");
        final client = GetIt.instance<SupabaseClient>();
        final response = await client
            .from('${orgId}_lead_call_logs')
            .insert([
          {
            'type': callLog.callType.toString().replaceAll('CallType.', ''),
            'subtype': callLog.callType.toString().replaceAll('CallType.', ''),
            'T': DateTime.now().millisecondsSinceEpoch,
            'Luid': leadDocId,
            'dailedBy': FirebaseAuth.instance.currentUser!.email,
            'payload': {},
            'customerNo' : callLog.number,
            'fromPhNo': '',
            'duration': callLog.duration,
            'startTime': callLog.timestamp!.toInt(),
          },
        ]);


        if (response.toString() == "null") {
          print("Cotrol came into Saveby method");
          saveByDayWeekMonth(
            callLog.callType.toString(),
            callLog.duration,
            uid!
          );
         saveByDayWeekMonth(callLog.callType.toString(),
            callLog.duration,project);

        } else {
          print('Insert failed: ${response}');
        }
      }



    }
    catch (e, stackTrace)
    {

      print('Error while fetching call logs: $e');
      print('StackTrace: $stackTrace');
    }


    //print('Call log  inserted successfully ${response}');
    // var callLog = (response as List).cast<Map<String, dynamic>>();
    //print('call inserted successfully ${callLog}');
    //return callLog;
  }
  int getWeekNumber(DateTime date) {
    final mondayFirstDate = date.subtract(Duration(days: date.weekday - 1));
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDifference = mondayFirstDate.difference(firstDayOfYear).inDays;
    return ((daysDifference + firstDayOfYear.weekday) / 7).ceil();
  }



  Future<void> saveBy(int durationinseconds,var period,String calltype,String uidOrProjectName)
  async {


    final now = DateTime.now();
   // print(calltype);
    bool isOutgoing=true;
    isOutgoing = calltype=="CallType.outgoing" ? true : false;


    String dayOfYear = DateFormat("D").format(now);
    int dayOfYearInt = int.parse(dayOfYear);
    int weekOfYear = getWeekNumber(now);
    int month = now.month;
    int year = now.year;

    int periodValue=0;
    if(period=="D")
    {
      periodValue=dayOfYearInt;
    }
    else if(period=="W")
    {
      periodValue=weekOfYear;
    }
    else if(period=="M")
    {
      periodValue=month;
    }



    final client = GetIt.instance<SupabaseClient>();
    var uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid!=null)
    {
      final tableName = '${controller.currentUserObj['orgId']}_sales_emp_kpi';


     /* await client.from(tableName).upsert({
        'uid': uid,
        'period': period,
        'year': year,
        'value': periodValue,
        'talktime': durationinseconds,
        'totalCallsCount':'totalCallsCount + 1',
        'totalIncomingCallsCount':'totalIncomingCallsCount + ${((isOutgoing)?0: 1)}',
        'totalOutGoingCallsCount':'totalOutGoingCallsCount + ${((isOutgoing)?1: 0)}',
        'totalIncomingAnswered':'totalIncomingAnswered + ${((isOutgoing && durationinseconds>0)?0: 1)}',
        'totalOutgoingAnswered':'totalOutgoingAnswered + ${(isOutgoing && durationinseconds>0)?1: 0}',
        'totalIncomingSeconds':'totalIncomingSeconds + ${(isOutgoing && durationinseconds>0)?durationinseconds: 0}',
        'totalOutgoingSeconds':'totalOutgoingSeconds + ${(isOutgoing && durationinseconds>0)?durationinseconds: 0}'
      });

      return;*/

      final existing = await client
          .from(tableName)
          .select('talktime,totalCallsCount,totalIncomingCallsCount,totalOutGoingCallsCount,'
          'totalIncomingAnswered,totalOutgoingAnswered,totalIncomingSeconds,totalOutgoingSeconds')
          .eq('uid', uidOrProjectName)
          .eq('period', period)
          .eq('year', year)
          .eq('value',periodValue)
          .maybeSingle();

      if (existing == null) {
        print("adding");
        // Row does not exist → Insert new
        await client.from(tableName).upsert({
          'uid': uidOrProjectName,
          'period': period,
          'year': year,
          'value': periodValue,
          'talktime': durationinseconds,
          'totalCallsCount':1,
          'totalIncomingCallsCount': ((isOutgoing)?0: 1),
          'totalOutGoingCallsCount':((isOutgoing)?1: 0),
          'totalIncomingAnswered':((isOutgoing && durationinseconds>0)?1: 0),
          'totalOutgoingAnswered':((isOutgoing && durationinseconds>0)?1: 0),
          'totalIncomingSeconds':((isOutgoing && durationinseconds>0)?durationinseconds: 0),
          'totalOutgoingSeconds':((isOutgoing && durationinseconds>0)?durationinseconds: 0)

        });
        print("existing: ${existing}");

      } else {
        //print("adding");
        // Row exists → Update talktime
        final previousTalktime = existing['talktime'] ;
        // print('TalkTime : ${previousTalktime}');
        final newTalktime = previousTalktime + durationinseconds;


        final previoustotalCallsCount=existing['totalCallsCount'];
        print("Previous Total Calls : ${previoustotalCallsCount}");
        final newCallsCount=previoustotalCallsCount+1;
        final previousIncomingCallsCount=existing['totalIncomingCallsCount'];
        final newIncomingCallsCount=previousIncomingCallsCount+((isOutgoing==true)? 0:1);
        final previousOutGoingCallsCount=existing['totalOutGoingCallsCount'];
        final newOutGoingCallsCount=previousOutGoingCallsCount+((isOutgoing==true)? 1:0);
        final previousIncomingAnswered=existing['totalIncomingAnswered'];
        final newIncomingAnswered=previousIncomingAnswered+
            ( ((isOutgoing==false) && durationinseconds>0)?1 :0);
        final previousOutgoingAnswered=existing['totalOutgoingAnswered'];
        final newOutgoingAnswered=previousOutgoingAnswered+
            ( ((isOutgoing==true) && durationinseconds>0)?1 :0);

        final previousIncomingSeconds=existing['totalIncomingSeconds'];
        final newIncomingSeconds=previousIncomingSeconds+
            ((isOutgoing==false) ? durationinseconds : 0);

        final previousOutgoingSeconds=existing['totalOutgoingSeconds'];
        final newOutgoingSeconds=previousOutgoingSeconds +
            ( (isOutgoing==true) ? durationinseconds : 0);



        await client
            .from(tableName)
            .update({
          'talktime': newTalktime,
          'totalCallsCount':newCallsCount,
          'totalIncomingCallsCount':newIncomingCallsCount,
          'totalOutGoingCallsCount':newOutGoingCallsCount,
          'totalIncomingAnswered':newIncomingAnswered,
          'totalOutgoingAnswered':newOutgoingAnswered,
          'totalIncomingSeconds':newIncomingSeconds,
          'totalOutgoingSeconds':newOutgoingSeconds

        })
            .match({
          'uid': uidOrProjectName,
          'period': period,
          'year': year,
          'value':periodValue,

        });
      }

    }



  }

  Future<void> saveByDayWeekMonth(String callType,int durationinseconds,String uidOrProjectName)
  async {
    print("Control came into saveByDayWeekMonth Function");
    print(callType);

    saveBy(durationinseconds, "D",callType,uidOrProjectName);
    saveBy(durationinseconds, "W",callType,uidOrProjectName);
    saveBy(durationinseconds, "M",callType,uidOrProjectName);

    /* final client = GetIt.instance<SupabaseClient>();
    var uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid!=null)
    {
      final tableName = '${controller.currentUserObj['orgId']}_sales_emp_kpi';

      final existing = await client
          .from(tableName)
          .select('talktime')
          .eq('uid', uid)
          .eq('period', "D")
          .eq('year', year)
          .eq('value', dayOfYear)
          .maybeSingle();

      if (existing == null) {
        print("adding");
        // Row does not exist → Insert new
        await client.from(tableName).insert({
          'uid': uid,
          'period': "D",
          'year': year,
          'value': dayOfYear,
          'talktime': durationinseconds,
        });
      } else {
        print("adding");
        // Row exists → Update talktime
        final previousTalktime = existing['talktime'] ?? 0;
        final newTalktime = previousTalktime + durationinseconds;

        await client
            .from(tableName)
            .update({'talktime': newTalktime})
            .match({
          'uid': uid,
          'period': "D",
          'year': year,
          'value': dayOfYear,
        });
      }




      final existing2 = await client
          .from(tableName)
          .select('talktime')
          .eq('uid', uid)
          .eq('period', "W")
          .eq('year', year)
          .eq('value', weekOfYear)
          .maybeSingle();

      if (existing2 == null) {
        // Row does not exist → Insert new
        await client.from(tableName).insert({
          'uid': uid,
          'period': "W",
          'year': year,
          'value': weekOfYear,
          'talktime': durationinseconds,
        });
      } else {
        // Row exists → Update talktime
        final previousTalktime = existing2['talktime'] ?? 0;
        final newTalktime = previousTalktime + durationinseconds;

        await client
            .from(tableName)
            .update({'talktime': newTalktime})
            .match({
          'uid': uid,
          'period': "W",
          'year': year,
          'value': weekOfYear,
        });
      }





      final existing3 = await client
          .from(tableName)
          .select('talktime')
          .eq('uid', uid)
          .eq('period', "M")
          .eq('year', year)
          .eq('value', month)
          .maybeSingle();

      if (existing3 == null) {
        // Row does not exist → Insert new
        await client.from(tableName).insert({
          'uid': uid,
          'period': "M",
          'year': year,
          'value':month,
          'talktime': durationinseconds,
        });
      } else {
        // Row exists → Update talktime
        final previousTalktime = existing3['talktime'] ?? 0;
        final newTalktime = previousTalktime + durationinseconds;

        await client
            .from(tableName)
            .update({'talktime': newTalktime})
            .match({
          'uid': uid,
          'period': "M",
          'year': year,
          'value': month,
        });
      }*/






  }


}
