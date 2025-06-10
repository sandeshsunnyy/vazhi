import 'package:flutter/material.dart';
import 'package:vazhi/home_page.dart';
import 'dart:ui' as ui;
import 'constants.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/UnKnown-4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Center(
                child: Container(
                  height: 500.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Vazhi',
                          style: kMainTextStyle.copyWith(color: Colors.white.withAlpha(190), fontSize: 150.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                      //Text('Manifest your Dreams', style: kDefaultTextStyle.copyWith(fontSize: 25.0, color: Colors.black),),
                      //SizedBox(height: 30.0,),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffD3D3FF).withAlpha(200),),
                        ),
                          onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(),),);
                          },
                          child: Text('Begin', style: kDefaultTextStyle.copyWith(fontSize: 20.0, color: Colors.black),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
