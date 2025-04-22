import 'package:get/get.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';

class MySearchController extends GetxController
{

  var selectedIndex = 0.obs;

  final homeController=Get.find<HomeController>();
  var leadList;
  @override
  void onInit() {
    super.onInit();

    ever(selectedIndex, (_) {
      filterLeadlist();
    });
  }


 void filterLeadlist() {
    final allLeads = homeController.Totalleadslist;
    switch (selectedIndex.value) {
      case 0:
        leadList = allLeads;
        break;
      case 1:
        leadList= homeController.newleadslist;
        break;
      case 2:
        leadList = homeController.followupleadslist;
        break;
      case 3:
        leadList = homeController.visitfixedleadslist;
        break;
      case 4:
        leadList = homeController.visitdoneleadslist;
        break;
      case 5:
        leadList=homeController.negotiationleadslist;
        break;
      case 6:
        leadList= homeController.notintrestedleadslist;
        break;
      default:
        leadList= allLeads;
    }
  }




}
