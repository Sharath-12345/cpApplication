
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbSupa {
  static DbSupa get instance => DbSupa._();

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
    print('Task inserted successfully ==> ${existingCallLogs}');
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
    ]);
   //print('Call log  inserted successfully ${response}');
  // var callLog = (response as List).cast<Map<String, dynamic>>();
    //print('call inserted successfully ${callLog}');
    //return callLog;
  }


}
