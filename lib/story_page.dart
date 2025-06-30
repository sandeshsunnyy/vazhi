import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vazhi/main.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class StoryPage extends StatefulWidget {
  StoryPage({required this.prompt, required this.story});

  final String prompt;
  final String story;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String generatedText = "";

  bool isDone = true;
  bool isGenerateDone = true;
  bool isDialogDone = true;

  Future<void> showContents(int fromWhere) async {
    String path = await Provider.of<EssentialData>(context, listen: false).pathsFilePath;
    if(await File(path).exists()){
      var file = File(path);
      String str = await file.readAsString();
      if(str.isNotEmpty){

        var jsonMap = jsonDecode(str);
        if(fromWhere == 1){
          print('From non-empty contents');
        } else if (fromWhere == 2){
          print('From empty contents');
        } else if (fromWhere == 3) {
          print('No file');
        }
        if(jsonMap is List){
          print(jsonMap[0].keys.toList());
        } else if(jsonMap is Map){
          print(jsonMap.keys.toList());
        }
      }
    }
  }

  Future<void> sendPrompt(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://gemini-api-backend-140623945393.asia-south1.run.app/gemini'),
        body: jsonEncode({'prompt': prompt}),
        headers: {
          "content-type": "application/json",
        },
      );
      if (response.statusCode == 200) {
          var reply = jsonDecode(utf8.decode(response.bodyBytes));
          setState(() {
            generatedText = reply['generated_text'];
            isDone = true;
          });

        print(generatedText);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text('Vazhi', style: kMainTextStyle.copyWith(fontSize: 40.0, color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.story, style: kDefaultTextStyle.copyWith(color: Colors.brown[700], height: 1.6, letterSpacing: 0.2), textAlign: TextAlign.left,),
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isDone = false;
                              isGenerateDone = false;
                            });
                            String contextString = "The following is the description of a day in the life of a user's dream future./n";
                            String ending = "/n What i want you to do is analyze the text and suggest 5 tasks to do daily as a student or someone who is trying to achieve such a life in the future.  The reply should consist of just a string, which could be json decodedable by dart. So just give me a string having key value pairs nested inside curly-braces, nothing more. Don't give me a json object that starts with '''json and ends with '''. It should have a 'path_name' key, which is the name of the path (example: If the story provided describes the life of a mechanical engineer, the path_name has to be a string 'Mechanical Engineer path'), and a key called 'task_list', which should be a list of the daily tasks seperated by a comma. No need to include any pleasantaries. Just the json decodable string has to be the reply. ";
                        await sendPrompt(contextString+widget.story+ending);
                        if(isDone){
                          print(generatedText);
                          var jsonMap = jsonDecode(generatedText);
                          List<dynamic> taskList = jsonMap["task_list"];
                          print(taskList);
                          String pathName = jsonMap["path_name"];
                          print(pathName);
                          Map<String, dynamic> path = {
                            "prompt" : widget.prompt,
                            "story" : widget.story,
                            "tasks" : taskList
                          };
                          Map<String, dynamic> path1 = {
                            pathName : path
                          };
                          print(path);
                          String pathsLocation = Provider.of<EssentialData>(context, listen: false).pathsFilePath;
                          print(pathsLocation);
                          if(await File(pathsLocation).exists()){
                            var file = File(pathsLocation);
                            String existingContent = await file.readAsString();
                            if(existingContent.isNotEmpty) {
                              var jsonData = jsonDecode(existingContent);

                              if(jsonData is List){
                                List<dynamic> itemList = [];
                                itemList = jsonData;
                                itemList[0][pathName] = path;
                                jsonData = jsonEncode(itemList);
                                await file.writeAsString(jsonData);
                                await showContents(1);
                              } else if(jsonData is Map){
                                Map<dynamic, dynamic> itemList = {};
                                itemList = jsonData;
                                itemList[pathName] = path;
                                jsonData = jsonEncode(itemList);
                                await file.writeAsString(jsonData);
                                await showContents(1);
                              }
                            } else {
                              print('The file was empty. New contents added.');
                              String jsonString = jsonEncode(path1);
                              await file.writeAsString(jsonString);
                              await showContents(2);
                            }
                          } else {
                            String jsonString = jsonEncode(path1);
                            await File(pathsLocation).writeAsString(jsonString);
                            await showContents(3);
                          }

                          if(!mounted) return;
                          setState(() {
                            isGenerateDone = true;
                            isDialogDone = false;

                          });
                          if(isGenerateDone){
                            print('dialog appeeared');
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  backgroundColor: Color(0xFF818C78),
                                  title: Text('Messege from Tee', style: kDefaultTextStyle.copyWith(color: Colors.black54, fontSize: 20.0),),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'images/tee.png',
                                          height: 200.0,
                                          width : 200,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: Color(0xFFE2E0C8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text("Your plan is ready. Head over to the Path Library to find them.\n\nRemember to do this everyday, okay?\n\nYou've got this!!", style: kDefaultTextStyle.copyWith(color: Colors.black54, fontSize: 12.0),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffD3D3FF).withAlpha(200),),
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          isDialogDone = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(padding: EdgeInsets.all(5.0),
                                        child:  Text("Let's go!", style: kDefaultTextStyle.copyWith(color: Colors.black, fontSize: 12.0),),),
                                    ),
                                  ],
                                );
                              },
                            );
                            if(isDialogDone){
                              print('Tee appeared');
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                          child: isGenerateDone ? Text('generate daily plan', style: kDefaultTextStyle,) : Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 15.0,
                              width: 15.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white70),
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF5D4037)),
                          ),
                        ),
                      ElevatedButton(
                          onPressed: (){
                            if(!mounted) return;
                            Navigator.pop(context);
                          },
                          child: Text('go back', style: kDefaultTextStyle,),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF5D4037)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
