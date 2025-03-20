import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Search/search_controller.dart';

class SearchScreen extends StatelessWidget
{
  const SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    MySearchController controller = Get.put<MySearchController>(MySearchController());
    return Scaffold(

      backgroundColor:const Color(0xff0D0D0D),
      body: Obx(
        ()=>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,40, 0,0),
              child: SizedBox(
                height: height*0.06,
                width: width*0.8,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search" ,
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(0,
                        title: 'All',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 0,
                        }),
                    _filterChip(1,
                        title: 'Done',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 1,
                        }),
                    _filterChip(2,
                        title: 'Pending',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 2,
                        }),
                    _filterChip(3,
                        title: 'Created',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 3,
                        }),
                    _filterChip(4,
                        title: 'Today',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 4,
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
  Widget _filterChip(int index,
      {required String title,
        required MySearchController controller,
        required VoidCallback onTap}) {

    final MySearchController controller=Get.find<MySearchController>();
    return Padding(
      padding: index == 0
          ? const EdgeInsets.only(left: 20, right: 5, top: 8, bottom: 8)
          : const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ActionChip(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            shape: index != controller.selectedIndex.value
                ? const StadiumBorder(side: BorderSide(color: Colors.black26))
                : null,
            backgroundColor: index == controller.selectedIndex.value
                ? Color(0xffBDA1EF)
                : Colors.white,
            label: Text(
              title,
             // style: Get.theme.kSubTitle.copyWith(
               // color: controller.selectedIndex.value == index
                 //   ? Colors.white
                   // : Get.theme.kBadgeColor,
              //),
            ),
            onPressed: onTap),

    );
  }

}