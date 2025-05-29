
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

  addCallLog(orgId, leadDocId,data)async {



    try
    {
      print("Came into real adding list method");
      print("Lead Uid : ${leadDocId}");

      final client = GetIt.instance<SupabaseClient>();
      final response = await client
          .from('${orgId}_lead_call_logs')
          .upsert([
        {
          'type': data.callType.toString().replaceAll('CallType.', ''),
          'subtype': data.callType.toString().replaceAll('CallType.', ''),
          'T': DateTime.now().millisecondsSinceEpoch,
          'Luid': leadDocId,
          'dailedBy': FirebaseAuth.instance.currentUser!.email,
          'payload': {},
          'customerNo' : data.number,
          'fromPhNo': '',
          'duration': data.duration,
          'startTime': data.timestamp!.toInt(),
        },
      ]).select();
      saveByDayWeekMonth(data.callType.toString(),data.duration);

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



  Future<void> saveBy(int durationinseconds,var type,String calltype)
  async {


    final now = DateTime.now();
    bool Outgoing=true;
    if(calltype=="outgoing")
      {
        Outgoing=true;
      }
    else
      {
        Outgoing=false;
      }

    String dayOfYear = DateFormat("D").format(now);
    int dayOfYearInt = int.parse(dayOfYear);
    int weekOfYear = getWeekNumber(now);
    int month = now.month;
    int year = now.year;

    int value=0;
    if(type=="D")
      {
        value=dayOfYearInt;
      }
    else if(type=="W")
      {
        value=weekOfYear;
      }
    else if(type=="M")
      {
        value=month;
      }



    final client = GetIt.instance<SupabaseClient>();
    var uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid!=null)
    {
      final tableName = '${controller.currentUserObj['orgId']}_sales_emp_kpi';

      final existing = await client
          .from(tableName)
          .select('talktime,totalCallsCount,totalIncomingCallsCount,totalOutGoingCallsCount,'
          'totalIncomingAnswered,totalOutgoingAnswered,totalIncomingSeconds,totalOutgoingSeconds')
          .eq('uid', uid)
          .eq('period', type)
          .eq('year', year)
          .eq('value',value)
          .maybeSingle();

      if (existing == null) {
        print("adding");
        // Row does not exist → Insert new
        await client.from(tableName).insert({
          'uid': uid,
          'period': type,
          'year': year,
          'value': value,
          'talktime': durationinseconds,
          'totalCallsCount':1,
          'totalIncomingCallsCount':((Outgoing==true)?0: 1),
          'totalOutGoingCallsCount':((Outgoing==true)?1: 0),
          'totalIncomingAnswered':((Outgoing==false) && durationinseconds>0) ,
          'totalOutgoingAnswered':(Outgoing==true) && durationinseconds>0,
          'totalIncomingSeconds':durationinseconds,
          'totalOutgoingSeconds':durationinseconds

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
        final newIncomingCallsCount=previousIncomingCallsCount+((Outgoing==true)? 0:1);
        final previousOutGoingCallsCount=existing['totalOutGoingCallsCount'];
        final newOutGoingCallsCount=previousOutGoingCallsCount+((Outgoing==true)? 1:0);
        final previousIncomingAnswered=existing['totalIncomingAnswered'];
        final newIncomingAnswered=previousIncomingAnswered+
            ( ((Outgoing==false) && durationinseconds>0)?1 :0);
        final previousOutgoingAnswered=existing['totalOutgoingAnswered'];
        final newOutgoingAnswered=previousOutgoingAnswered+
            ( ((Outgoing==true) && durationinseconds>0)?1 :0);

        final previousIncomingSeconds=existing['totalIncomingSeconds'];
        final newIncomingSeconds=previousIncomingSeconds+
            ((Outgoing==false) ? durationinseconds : 0);

        final previousOutgoingSeconds=existing['totalOutgoingSeconds'];
        final newOutgoingSeconds=previousOutgoingSeconds +
            ( (Outgoing==true) ? durationinseconds : 0);



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
          'uid': uid,
          'period': type,
          'year': year,
          'value':value,

        });
      }

  }



  }

  Future<void> saveByDayWeekMonth(String callType,int durationinseconds)
  async {


    saveBy(durationinseconds, "D",callType);
    saveBy(durationinseconds, "W",callType);
    saveBy(durationinseconds, "M",callType);

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
