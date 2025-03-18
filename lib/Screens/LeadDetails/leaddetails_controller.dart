import 'package:get/get.dart';

class LeadDetailsController extends GetxController
{
  RxInt tabIndex = 0.obs;
  chnageTabIndex(int index) {
    tabIndex(index);
  }

}