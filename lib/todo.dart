import 'package:flutter/material.dart';
import 'constants.dart';
import 'task_tile.dart';
import 'task.dart';

class Todo extends StatefulWidget {
  Todo({required this.title, required this.taskList});

  final String title;
  List<dynamic> taskList;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E0C8),
      appBar: AppBar(
        backgroundColor: Color(0xFFE2E0C8),
        title: Text('Vazhi', style: kMainTextStyle.copyWith(color: Color(0xFF4E635E), fontSize: 40.0),),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFE2E0C8),
            child: Padding(
              padding: EdgeInsets.only(top: 80.0, bottom: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                    widget.title,
                    style: kDefaultTextStyle.copyWith(
                        color: Colors.blueGrey[500], fontSize: 30.0),
                                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Color(0xFF818C78),
              ),
              child: ListView.builder(
                itemCount: widget.taskList.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                      task: Task(taskName: widget.taskList[index]));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
