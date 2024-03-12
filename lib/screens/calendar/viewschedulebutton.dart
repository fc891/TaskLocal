import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// create class 
class ViewScheduleButton extends StatelessWidget {

  final String label;
  final Function()? onTap;

  const ViewScheduleButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  // build layout
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ontap button creation
      onTap: onTap,
      child:Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:Colors.blue,
        ),
        alignment: Alignment.center,
        child:Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:Colors.white,
          )
        )
      ),
    );
  }
}