import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saleapp/Screens/Home/home_controller.dart';
import 'package:saleapp/Screens/LeadDetails/LeadDetails.dart';
import 'package:saleapp/Screens/Search/search_controller.dart';

class SearchScreen extends StatefulWidget
{
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();
  MySearchController controller = Get.put<MySearchController>(MySearchController());
  HomeController homeController=Get.find<HomeController>();

 // var leadList;


  var  filteredLeads = [];
  void filterSearchResults(String query) {
    var tempLeads = [];

    if (query.isEmpty) {
      tempLeads = controller.leadList
          .map((doc) => doc.data() as Map<String, dynamic>?)
          .where((lead) => lead != null) // Ensure it's not null
          .cast<Map<String, dynamic>>() // Cast to proper type
          .toList();
    } else {
      if (RegExp(r'^[0-9]+$').hasMatch(query)) {

        tempLeads = controller.leadList
            .map((doc) => doc.data() as Map<String, dynamic>?)
            .where((lead) => lead != null && lead['Mobile'] != null)
            .where((lead) =>
            lead!['Mobile'].toString().contains(query))
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        // Search by name (starts with query)
        tempLeads =controller.leadList
            .map((doc) => doc.data() as Map<String, dynamic>?)
            .where((lead) => lead != null && lead['Name'] != null)
            .where((lead) =>
            lead!['Name'].toString().toLowerCase().startsWith(query.toLowerCase()))
            .cast<Map<String, dynamic>>()
            .toList();
      }
    }

    setState(() {
      filteredLeads = tempLeads;
    });
  }

  int getIndexInTotalLeads(Map<String, dynamic> lead) {
    return controller.leadList.indexWhere((element) => element['Mobile'] == lead['Mobile']);
  }
  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    //controller.leadList.value=homeController.Totalleadslist;
    controller.leadList=homeController.Totalleadslist;

    return Scaffold(
      backgroundColor:const Color(0xff0D0D0D),
      body: Obx(
        ()=>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,40, 20,0),
              child: SizedBox(
                height: height*0.06,
                width: width*0.92,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search" ,
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                  onChanged: filterSearchResults,
                ),
              ),
            ),
           Padding(
              padding: const EdgeInsets.only(left: 0),
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
                        title: 'New',
                        controller: controller,
                        onTap: ()  {

                          controller.selectedIndex.value = 1;

                        }),
                    _filterChip(2,
                        title: 'FollowUp',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 2,
                        }),
                    _filterChip(3,
                        title: 'Visit Fixed',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 3,
                        }),
                    _filterChip(4,
                        title: 'Visit Done',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 4,
                        }),
                    _filterChip(5,
                        title: 'Negotiations',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 5,
                        }),
                    _filterChip(6,
                        title: 'Not Intrested',
                        controller: controller,
                        onTap: () => {
                          controller.selectedIndex.value = 6,
                        }),
                  ],
                ),
              ),
            ),
            Expanded(
              child: filteredLeads.isEmpty
                  ? Center(child: Text("",style: TextStyle(
                color: Colors.white
              ),))
                  : ListView.builder(
                itemCount: filteredLeads.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10,0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                     // padding: EdgeInsets.all(10),
                      height: height*0.09,
                      width: width*0.1 ,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: InkWell(
                          onTap: ()
                          {
                            int indexinTotallist = getIndexInTotalLeads(filteredLeads[index] ?? 0);

                            Get.to(()=>LeadDetailsScreen(), arguments: {
                              "leaddetails" : controller.leadList[indexinTotallist],
                            });
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredLeads[index]['Name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: height*0.01),
                                  Text(
                                    filteredLeads[index]['Mobile']!,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),

                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: InkWell(
                                  onTap: ()
                                  {
                                    FlutterDirectCallerPlugin.callNumber(filteredLeads[index]['Mobile']);
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Color(0xff58423B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),


                    ),
                  );
                },
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