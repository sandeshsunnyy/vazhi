import 'package:flutter/material.dart';
import 'package:vazhi/dream_description.dart';
import 'package:vazhi/path_storage.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'main.dart';
import 'dart:convert';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  void initState(){
    super.initState();
  }

  Map<String, dynamic> jsonMap = {};

  Future<Map<String, dynamic>> getJsonData() async {
    String path = Provider.of<EssentialData>(context, listen: false).pathsFilePath;
    if(await File(path).exists()){
      var file = File(path);
      String jsonString = await file.readAsString();
      var jsonMap = jsonDecode(jsonString);
      return jsonMap;
    } else {
      return {};
    }
  }

  final textEditor = TextEditingController();

  int selectedIndex = 0;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {

    List<Widget>_pages = [
      DreamDescription(),
      PathStorage(pathData: jsonMap),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF4E635E),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'Vazhi',
      //     style: kMainTextStyle.copyWith(fontSize: 40.0, color: Colors.black87),
      //   ),
      // ),
      body: Row(
        children: [
          NavigationRail(
            indicatorColor: Colors.white,
            backgroundColor: Color(0xFFA6B49E),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined, color: Colors.white,),
                selectedIcon: Icon(Icons.home_filled),
                label: Text('home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book_outlined, color: Colors.white,),
                selectedIcon: Icon(Icons.book),
                label: Text('paths'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) async {
              Map<String, dynamic> json = await getJsonData();
              setState(() {
                  jsonMap = json;
                  selectedIndex = index;
              });
            },
          ),
          VerticalDivider(
            color: Colors.black,
            width: 1.0,
            thickness: 2.0,
          ),
          Expanded(
            child: _pages[selectedIndex],
          ),
        ],
      ),
    );
  }
}
