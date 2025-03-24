import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

void ShowDatePickerCard(BuildContext context) async {
  print('inside here');
  DateTime? dateTime = await showOmniDateTimePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
    lastDate: DateTime.now().add(
      const Duration(days: 3652),
    ),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: 5,
    secondsInterval: 1,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    constraints: const BoxConstraints(
      maxWidth: 350,
      maxHeight: 650,
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(
          Tween(
            begin: 0,
            end: 1,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    selectableDayPredicate: (dateTime) {
      // Disable 25th Feb 2023
      if (dateTime == DateTime(2023, 2, 25)) {
        return false;
      } else {
        return true;
      }
    },
  );
// controller.selectedDateTime.value = DateFormat('dd-MM-yy HH:mm').format(dateTime!).toString();
  //controller.selectedDateTime.value = dateTime!.millisecondsSinceEpoch;
  // print('selected data is ${controller.selectedDateTime}  ${dateTime}');
}


void showBottomPopup(BuildContext context,var tasktype) {
  final TextEditingController controller = TextEditingController
    (text: "Make a $tasktype task ");
  TextEditingController nameController = TextEditingController();
  var height=MediaQuery.of(context).size.height;
  var width=MediaQuery.of(context).size.width;
  var currentdatetime=DateTime.now();
  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(currentdatetime);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: SizedBox(
          height: height*0.32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height*0.06,
                decoration: BoxDecoration(
                  color: Color(0XFFB2DFDB),
                  borderRadius: BorderRadius.circular(7),
                ),

                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "Hey, plan your ",
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk'
                          ),
                        ),
                      ),
                      Text(
                        "$tasktype",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceGrotesk'),
                      ),
                      Text(
                        " with a task",
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk'
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
             Padding(
               padding: const EdgeInsets.only(left: 12),
               child: Opacity(
                   opacity: 0.5,
                   child: Text("Task Title",style: TextStyle(
                     fontFamily: 'SpaceGrotesk'
                   ),)

               ),
             ),

              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Removes the default underline
                  ),
                  style: TextStyle(fontSize: 16,
                  fontFamily: 'SpaceGrotesk'),
                  cursorColor: Colors.blue,
                ),
              ),

          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: [6, 3], // Adjust dot spacing
                  color: Colors.black12, // Dotted border color
                  strokeWidth: 2,
                  child: InkWell(
                    onTap: ()
                    {
                      ShowDatePickerCard(context);
                    },
                    child: Container(
                      width: width*0.13,
                      height: height*0.04,
                      decoration: BoxDecoration(
                         shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child:
                      Center(
                        child: Icon(Icons.calendar_month_outlined,color: Colors.black26,),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Due Date",style: TextStyle(color: Colors.black38),),
                     Text(formattedDateTime.toString(),style:
                     TextStyle(color: CupertinoColors.systemBlue,fontWeight: FontWeight.bold),)
                  ],
                )
              ],
              
            ),
          ),
             SizedBox(height: height*0.03,),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.calendar_month_outlined,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.flag_outlined,color: Colors.black38,),
                    SizedBox(width: width*0.07,),
                    Icon(Icons.people,color: Colors.black38,),
                    Spacer(),
                    Container(
                      height: height*0.05,
                      width: width*0.12,
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        color: Color(0XFFE1BEE7)
                      ),
                      child: Center(
                        child: Icon(Icons.send,color: Colors.blueAccent,),
                      ),
                    )

                  ],
                ),
              )
             ]
          ),
        ),
      );
    },
  );
}