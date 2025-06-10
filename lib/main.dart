import 'package:flutter/material.dart';
import 'start_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, dynamic> defaultData = {
  "paths" : 0};

Future<String> getDefaultFileLocation() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/default.json';
}

Future<String> getPathsFileLocation() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/pathh.json';
}

Future<int> setPathNumber() async {
  try {
    String defaultFilePath = await getDefaultFileLocation();
    var file = File(defaultFilePath);

    if (await file.exists()) {
      String jsonString = await file.readAsString();
      if (jsonString.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(jsonString);
        return data["paths"] ?? 0;
      } else {return 0;}
    } else {return 0;}
  } catch (e) {
    print("Could not read path number, defaulting to 0. Error: $e");
    return 0;
  }
}

Future<void> createDefaultFile(Map<String, dynamic> defaultData) async {
  try{
    final directory = await getApplicationDocumentsDirectory();
    String documentPath = '${directory.path}/default.json';
    final file = File(documentPath);
    bool isExist = false;
    isExist = await file.exists();
    if(isExist){
      print('Filed already exists');
    } else {
      final jsonString = JsonEncoder.withIndent(' ').convert(defaultData);
      await file.writeAsString(jsonString);
    }
  } catch(e){
    print('An exception was thrown ${e}');
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createDefaultFile(defaultData);
  String defaultFilePath = await getDefaultFileLocation();
  String pathsFilePath = await getPathsFileLocation();
  int pathNumber = await setPathNumber();
  EssentialData essentialData = EssentialData(pathNumber: pathNumber,defaultFilePath: defaultFilePath, pathsFilePath: pathsFilePath);
  await dotenv.load(fileName: ".env");
  runApp(MyApp(essentialData: essentialData,),);
}

class MyApp extends StatelessWidget {

  final EssentialData essentialData;
  MyApp({Key? key, required this.essentialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider<EssentialData>.value(
        value: essentialData,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FirstPage(),
        ),
      );
    }
  }

class EssentialData extends ChangeNotifier {
  EssentialData({required this.pathNumber, required this.defaultFilePath, required this.pathsFilePath});

  int pathNumber;
  final String defaultFilePath;
  final String pathsFilePath;


  Future<void> increamentPathNumber() async {
    pathNumber += 1;
    notifyListeners();
    if(await File(defaultFilePath).exists()){
      var file = File(defaultFilePath);
      String jsonString = await file.readAsString();
      if(jsonString.isNotEmpty){
        var jsonData = jsonDecode(jsonString);
        jsonData["paths"] = pathNumber;
        jsonString = jsonEncode(jsonData);
        await file.writeAsString(jsonString);
      } else {
        Map<String, dynamic> jsonData = {
          "paths": pathNumber
        };
        String jsonString = jsonEncode(jsonData);
        await File(defaultFilePath).writeAsString(jsonString);
      }
    }
  }

}