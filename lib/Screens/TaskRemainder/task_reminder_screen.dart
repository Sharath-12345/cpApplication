import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saleapp/Screens/TaskRemainder/task_reminder_controller.dart';

import '../../Utilities/responsive.dart';



class TaskReminderScreen extends StatelessWidget {
  final TaskReminderController _controller = Get.put(TaskReminderController());



  @override
Widget build(BuildContext context) {
   //  _controller.getTotalTasks();
    // print(_controller.totaltasklist);
  return Scaffold(
    appBar: _buildAppBar(context),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getWidth(8, context),
        ),
        child: Column(
          children: [
           _buildTaskCount(context),
            _buildCalendarSection(context),
            _buildCategoryFilters(context),
            _buildTaskList(context),
          ],
        ),
      ),
    ),
  );
}




  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
        iconSize: Responsive.getWidth(24, context),
      ),
      title: Text(
        'Task Reminder',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: Responsive.getFontSizeContext(16, context),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildTaskCount(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Responsive.getHeight(16, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.black,
            size: Responsive.getWidth(20, context),
          ),
          SizedBox(width: Responsive.getWidth(8, context)),
          Text(
            '${_controller.inprogresstasks} Tasks today',
            style: TextStyle(
              fontSize: Responsive.getFontSizeContext(16, context),
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
      ),
      padding: EdgeInsets.all(Responsive.getWidth(16, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthYearDropdown(context),
          _buildWeekRow(context),
        ],
      ),
    );
  }

  Widget _buildMonthYearDropdown(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: Responsive.getWidth(12, context),
      vertical: Responsive.getHeight(4, context),
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400), // Light grey border
      borderRadius: BorderRadius.circular(Responsive.getWidth(4, context)),
    ),
    child: DropdownButton<String>(
      value: _controller.selectedMonth.value,
      items: _controller.months.map((String month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text(
            month,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Responsive.getFontSizeContext(14, context),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          _controller.selectedMonth.value = value;
        }
      },
      isDense: true,
      isExpanded: false,
      underline: SizedBox(), // Removes default underline
      icon: Icon(Icons.keyboard_arrow_down, size: Responsive.getWidth(20, context)),
    ),
  );
}


  Widget _buildWeekRow(BuildContext context) {
  return Obx(() {
    final selectedDateTime = DateTime(
      _controller.selectedYear.value,
      _controller.selectedMonthIndex,
      _controller.selectedDate.value,
    );
    final currentWeekday = selectedDateTime.weekday;
    final startOfWeek = selectedDateTime.subtract(Duration(days: currentWeekday - 1));

    return Row(
      children: List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        final isSelected = day.day == _controller.selectedDate.value &&
            day.month == selectedDateTime.month &&
            day.year == selectedDateTime.year;

        return Expanded(
          child: GestureDetector(
            onTap: () => _controller.updateSelectedDate(
              day.day,
              day.month,
              day.year,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: Responsive.getHeight(4, context)),
              padding: EdgeInsets.symmetric(
                vertical: Responsive.getHeight(8, context),
                horizontal: Responsive.getWidth(4, context),
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: isSelected
                    ? Border.all(color: Colors.black, width: 2)
                    : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(Responsive.getWidth(8, context)),
              ),
              child: Column(
                children: [
                  Text(
                    _getWeekdayName(day.weekday),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.getFontSizeContext(12, context),
                      color: isSelected ? Colors.black : Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: Responsive.getHeight(4, context)),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: Responsive.getFontSizeContext(14, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  });
}



  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }



  Widget _buildCategoryFilters(BuildContext context) {
    return Container(
      height: Responsive.getHeight(48, context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.filters.length,
        itemBuilder: (context, index) {
          return Obx(() => _buildFilterButton(index, context));
        },
       // itemBuilder: (context, index) => _buildFilterButton(index, context),
      ),
    );
  }

  Widget _buildFilterButton(int index, BuildContext context) {
    final isSelected = index == _controller.selectedFilterIndex.value;
     _controller.updatefilters();
    return
        GestureDetector(

          onTap: () => _controller.changeFilter(index),

          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Responsive.getWidth(8, context),
              vertical: Responsive.getHeight(8, context),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getWidth(16, context),
              vertical: Responsive.getHeight(6, context),
            ),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFEDE9FE) : Colors.white,
            ),
            child:
              Text(
                _controller.filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFontSizeContext(14, context),
                ),
              ),
            ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Obx(()=>
      //child:
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _controller.tasks.length,
        itemBuilder: (context, index) => _buildTaskItem(_controller.tasks[index].data(), context),
      ),
    );
  }

  Widget _buildTaskItem(var task, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Responsive.getWidth(8, context)),
      padding: EdgeInsets.all(Responsive.getWidth(16, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: Responsive.getWidth(16, context),
                    color: Colors.grey,
                  ),
                  SizedBox(width: Responsive.getWidth(8, context)),
                  Text(
                    "7:00 PM",
                   // task.time,
                    style: TextStyle(
                      fontSize: Responsive.getFontSizeContext(14, context),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.getWidth(12, context),
                  vertical: Responsive.getHeight(4, context),
                ),
                decoration: BoxDecoration(
                  color:
                 //task.statusColor,
                 // Colors.white,
                  Color(0xFFD7FFDF)
                ),
                child: Text(
                  task['status'],
                  style: TextStyle(
                    fontSize: Responsive.getFontSizeContext(12, context),
                    color:
                    _getStatusTextColor(task['status']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.getHeight(5, context)),
          Text(
             task['task_title'],
            //"Project",
            //task.project,
            style: TextStyle(
              fontSize: Responsive.getFontSizeContext(16, context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          Text(
            "Description",
           // task.description,
            style: TextStyle(
              fontSize: Responsive.getFontSizeContext(14, context),
              color: Colors.grey[600],
              decoration:
              //task.status == 'Completed'
                //  ? TextDecoration.lineThrough
              //    :
              TextDecoration.none,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
                  //_controller.completeTask(task),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                task['status'],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFontSizeContext(14, context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Pending':
        return Color(0xFFFF5252);
      case 'InProgress':
        return Color(0xFFFFB300);
      case 'Completed':
        return Color(0xFF00C853);
      default:
        return Colors.black;
    }
  }
}
