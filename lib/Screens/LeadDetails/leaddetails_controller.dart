import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:saleapp/Auth/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeadDetailsController extends GetxController
{
  final authController=Get.find<AuthController>();

 RxInt tabIndex = 0.obs;
  chnageTabIndex(int index) {
    tabIndex(index);
  }


  RxList<Map<String, dynamic>> response = <Map<String, dynamic>>[].obs;
  int timeinmilli=0;
  var totalcalllogs=0.obs;


  final SupabaseClient supabase = GetIt.instance<SupabaseClient>();





  Future<void> printRowsByLuid(String luid) async {
   print(luid);
   print('${authController.currentUserObj['orgId']}_lead_call_logs');
   response.value = await supabase
       .from('${authController.currentUserObj['orgId']}_lead_call_logs') // Replace with actual table name
       .select()
       .eq('Luid', luid); // Filter rows where 'luid' matches

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