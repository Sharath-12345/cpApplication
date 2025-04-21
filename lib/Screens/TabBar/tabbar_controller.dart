import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController
{
  RxInt tabIndex = 0.obs;
  chnageTabIndex(int index) {
    tabIndex(index);
    print(tabIndex);
  }


}