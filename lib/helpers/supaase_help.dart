
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

    if (response.isNotEmpty) {
      print("✅ Call log added successfully: ${response.first}");
    } else {
      print(response);
      print("❌ Failed to add call log or no row was returned.");
    }

    if(response!=null)
      {

        saveByDayWeekMonth(data.duration);
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


  Future<void> saveByDayWeekMonth(int durationinseconds)
  async {
    final now = DateTime.now();

    String dayOfYear = DateFormat("D").format(now);
    int weekOfYear = getWeekNumber(now);
    int month = now.month;
    int year = now.year;

    print("Day number: $dayOfYear");
    print("Week number: $weekOfYear");
    print("Month number: $month");

    print("Year: $year");

    final client = GetIt.instance<SupabaseClient>();
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
      }






    }










  }


}
