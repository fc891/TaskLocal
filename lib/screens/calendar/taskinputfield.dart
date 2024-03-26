import 'package:flutter/material.dart';
import 'package:tasklocal/screens/calendar/calendartheme.dart';

// class to take in input
class TaskInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const TaskInputField ({Key? key,
  required this.title,
  required this.hint,
  this.controller,
  this.widget,
  }) : super(key: key);

  // build layout
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: maintitle,
          ),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    controller: controller,
                    style: subtitle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 0
                        ),
                      ),
                    ),
                  ),
                ),
                widget==null?Container():Container(child:widget)
              ],
            ),
          ),
        ],
      ),
    );
  }
}