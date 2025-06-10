import 'package:flutter/material.dart';
import 'constants.dart';
import 'todo.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({required this.title, required this.tasks});

  final String title;
  List<dynamic> tasks;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Todo(title: title, taskList: tasks),),);
      },
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          constraints: BoxConstraints(maxWidth: 700.0, maxHeight: 100.0),
          decoration: BoxDecoration(
            color: Color(0xFF818C78),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              title,
              style: kDefaultTextStyle.copyWith(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}
