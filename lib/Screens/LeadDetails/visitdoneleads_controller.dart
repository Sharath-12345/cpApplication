import 'package:get/get.dart';

class VisitDoneLeadsController extends GetxController
{
  int  tabIndex = 0;
  chnageTabIndex() {
    tabIndex+=1;
    if(tabIndex==4)
      {
        tabIndex=0;
      }
  }
}