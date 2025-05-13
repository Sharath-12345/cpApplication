import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeadDetailsController extends GetxController
{
  final authController=Get.find<AuthController>();

  var totaltasksvalue=1.obs;
  var totalcalllogsvalue=0.obs;
  var totalactivityvalue=0.obs;
  var currenttabvalue=1.obs;
  RxInt activitycount=0.obs;

 RxInt tabIndex = 0.obs;
  chnageTabIndex(int index) {
    tabIndex(index);
    if(index==1)
      {
        currenttabvalue.value=totalcalllogsvalue.value;
      }
    else if(index==2)
      {
        currenttabvalue.value=totalactivityvalue.value;
      }
    else
      {
        currenttabvalue.value=totaltasksvalue.value;
      }
  }


  RxList<Map<String, dynamic>> response = <Map<String, dynamic>>[].obs;
  int timeinmilli=0;
  var totalcalllogs=0.obs;


  final SupabaseClient supabase = GetIt.instance<SupabaseClient>();

  Stream<List<Map<String, dynamic>>> getCallLogsStream(String luid) {
    return supabase
        .from('${authController.currentUserObj['orgId']}_lead_call_logs')
        .stream(primaryKey: ['id']) // Use your real primary key field
        .eq('Luid', luid)
        .order('startTime') // Optional
        .map((event) => event);
  }




  Future<void> printRowsByLuid(String luid) async {
   print(luid);
   print('${authController.currentUserObj['orgId']}_lead_call_logs');
   response.value = await supabase
       .from('${authController.currentUserObj['orgId']}_lead_call_logs') // Replace with actual table name
       .select()
       .eq('Luid', luid); // Filter rows where 'luid' matches
   totalcalllogsvalue.value=response.length;

   if (response.isNotEmpty) {
     print("Rows with luid = $luid: $response");
     totalcalllogs.value=response.length;
     for(var log in response)
     {
       print(log['type']);
     }
   } else {
     print("No rows found for luid: $luid");
   }
 }







}