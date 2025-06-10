import 'package:flutter/material.dart';
import 'constants.dart';
import 'task.dart';

class TaskTile extends StatefulWidget {
  TaskTile({required this.task});
  
  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task.taskName, style: kDefaultTextStyle.copyWith(color: Colors.white70, decoration: widget.task.isDone ? TextDecoration.lineThrough : null),),
      trailing: Checkbox(value: widget.task.isDone, onChanged: (bool? value){
        setState(() {
          widget.task.toggleDone();
        });
      },
      ),
    );
  }
}
