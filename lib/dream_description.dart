import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vazhi/story_page.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DreamDescription extends StatefulWidget {

  @override
  State<DreamDescription> createState() => _DreamDescriptionState();
}

class _DreamDescriptionState extends State<DreamDescription> {
  String generatedText = " ";
  String contextString =
      "The task that you are to do is to describe a person's day in their future life. Our app serves as an interface where users write their dream job, dream relationship, dream everything. And your job is to take them to a day in their future. Explain to them how beautiful their life is gonna be as if you are telling a story. Make sure that you tell the story in a simple fashion. Generate in less than 500 words. The prompt by the user is as follows: ";
  String closingString = "/n Generate only the their future life. no pleasantries are needed";

  Future<void> sendPrompt(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(dotenv.env["GEMINI_URL"] ?? ' '),
        body: jsonEncode({'prompt': prompt}),
        headers: {
          "content-type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var reply = jsonDecode(utf8.decode(response.bodyBytes));
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

  bool isDone = true;
  final textEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFE2E0C8),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'What do you dream of?',
                    style: kDefaultTextStyle.copyWith(fontSize: 40.0, color: Colors.blueGrey[400]),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Column(
                  children: [
                    TextField(
                      controller: textEditor,
                      maxLines: 12,
                      style: kDefaultTextStyle.copyWith(color: Colors.black54),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle:
                            kDefaultTextStyle.copyWith(color: Colors.black54,),
                        hintText:
                            'describe your dream job, dream place, your dream everything',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Color(0xFF5D4037),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isDone = false;
                              });
                              await sendPrompt(
                                  contextString + textEditor.text + closingString);
                              if (isDone) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryPage(
                                      prompt: textEditor.text,
                                      story: generatedText,
                                    ),
                                  ),
                                );
                                textEditor.clear();
                              }
                            },
                            child: (isDone)
                                ? Text(
                              'take me there..',
                              style: kDefaultTextStyle.copyWith(
                                  color: Colors.white),
                            )
                                : Padding(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}
