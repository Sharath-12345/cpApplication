import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotIntrestedLeads extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
     return Scaffold(
       body:
       Padding(
         padding: EdgeInsets.fromLTRB(0, 40,10, 0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Center(
               child: Container(
                 height: height*0.14,
                 width: width*0.9,
                 decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(3),
                 ),
                 child: Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Scores",style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontFamily: 'SpaceGrotesk'
                       ),),
                       SizedBox(height: height*0.01,),
                       Container(
                         height: height*0.05,
                         width: width*0.1,
                         color: Color(0xFFFE1BEE7),
                         child: Center(
                           child: Text("10",style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontFamily: 'SpaceGrotesk'
                           ),),
                         ),
                       )
                     ],
                   ),
                 ),
         
               ),
             ),
             SizedBox(height: height*0.02,),
             Padding(
               padding: const EdgeInsets.only(left: 30),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Why Lead is not intrested",style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontFamily: 'SpaceGrotesk',
                       fontSize: height*0.02
                   ),),
                   SizedBox(height: height*0.004,),
                   Text("1 question",style: TextStyle(
                       fontFamily: 'SpaceGrotesk',
                       fontSize: height*0.017
                   ),),

                 ],
               ),
             ),
             SizedBox(height: height*0.03,),

             Padding(
               padding: const EdgeInsets.only(left: 25),
               child: Row(
                 //mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.4),
                         borderRadius: BorderRadius.circular(6)

                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(7.0),
                       child: Center(
                         child: Text("Q.1",style: TextStyle(
                             fontWeight: FontWeight.bold,
                           fontSize: height*0.015
                         ),),
                       ),
                     ),

                   ),
                   SizedBox(width: width*0.03,),
                   Text("Why Lead is not intrested",style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: height*0.019,
                       fontFamily: 'SpaceGrotesk'
                   ),)
                 ],
               ),
             ),
             SizedBox(height: height*0.01,),
             Padding(
               padding: const EdgeInsets.only(left: 12),
               child: Center(
                 child: Container(
                   width: width*0.7,
                     child: NotIntrestedReasonsCheckboxWidget()
                 ),
               ),
             ),
             Spacer(),
             Container(
               height: height*0.09,
               width: width,
               color: Colors.grey.withOpacity(0.2),
               child: Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 12),
                     child: Text("set lead status",style: TextStyle(
                         fontFamily: 'SpaceGrotesk'
                     ),),
                   ),
                   Spacer(),
                   Padding(
                     padding: const EdgeInsets.only(right: 12),
                     child: Container(
                       width: width*0.40,
                       height: height*0.06,
                       child: Center(
                         child: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(left: 12),
                               child: Text("NOT INTRESTED",style: TextStyle(color: Colors.white,
                                   fontFamily: 'SpaceGrotesk',
                               fontSize: height*0.014),),
                             ),
                             Spacer(),
                             Padding(
                               padding: const EdgeInsets.only(right: 16),
                               child: Container(

                                 child: Icon(Icons.chevron_right,color: Colors.black,),
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     shape: BoxShape.circle
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                       decoration: BoxDecoration(
                         color: Color(0xFF651FFF),
                         borderRadius: BorderRadius.circular(50),
                       ),
                     ),
                   )
                 ],
               ),
             )


           ],
         ),
       ),
     );
  }
}
class NotIntrestedReasonsCheckboxWidget extends StatefulWidget {
  @override
  _NotIntrestedReasonsCheckboxWidgetState createState() => _NotIntrestedReasonsCheckboxWidgetState();
}

class _NotIntrestedReasonsCheckboxWidgetState extends State<NotIntrestedReasonsCheckboxWidget> {
  int? selectedIndex; // Stores the selected checkbox index

  final List<String> emotions = ["Budget issue", "Looking for different area & property",
    "Looking for differnt areas", "Looking for differnt property"];

  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(emotions.length, (index) {
        return CheckboxListTile(
          title: Text(emotions[index],style:
          TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: MediaQuery.of(context).size.height*0.016
          ),),
          value: selectedIndex == index, // Check only one at a time
          onChanged: (bool? value) {
            setState(() {
              selectedIndex = value! ? index : null;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          //contentPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(0),
          dense: true,
          activeColor: Colors.green,
          visualDensity: VisualDensity(horizontal: -3, vertical: -4),
        );
      }),
    );
  }
}