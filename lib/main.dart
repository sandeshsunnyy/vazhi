import 'package:flutter/material.dart';
import 'start_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

Future<String> getPathsFileLocation() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/pathh.json';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  String pathsFilePath = await getPathsFileLocation();
  EssentialData essentialData = EssentialData(pathsFilePath: pathsFilePath);
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
  EssentialData({required this.pathsFilePath});
  final String pathsFilePath;
}