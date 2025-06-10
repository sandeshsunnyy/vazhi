import 'package:flutter/material.dart';
import 'package:vazhi/constants.dart';
import 'task_container.dart';

class PathStorage extends StatefulWidget {
  PathStorage({required this.pathData});

  Map<String, dynamic> pathData;

  @override
  State<PathStorage> createState() => _PathStorageState();
}

class _PathStorageState extends State<PathStorage> {

  List<String> paths = [];
  bool isEmpty = false;

  void getPaths(){
    List<String> pathsList = widget.pathData.keys.toList();
    setState(() {
      paths = pathsList;
    });
  }

  void isEmptySet(){
    if(widget.pathData == {}){
      setState(() {
        isEmpty = true;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getPaths();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Color(0xFFE2E0C8),
      child: (!isEmpty) ? Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: paths.length,
                itemBuilder: (context, index) {
                  return TaskContainer(title: paths[index], tasks: widget.pathData[paths[index]]["tasks"]);
                },
            ),
          ),
        ],
      ) : Center(child: Text('No paths available', style: kDefaultTextStyle.copyWith(color: Colors.black54),),),
    );
  }
}
