import 'package:flutter/material.dart';
import 'home_page.dart';
import 'constants.dart';

class TeeFirst extends StatelessWidget {
  const TeeFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF818C78),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF818C78),
              foregroundColor: Color(0xFF818C78),
              radius: 160.0,
              child: Image(image: AssetImage('images/tee.png'),),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFFE2E0C8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Hey there! I’m Tee.\n\nEver wondered what your life could look like if everything turned out just the way you dreamed?\n\nCome on, let’s take a peek into your future.", style: kDefaultTextStyle.copyWith(color: Colors.black54, fontSize: 12.0),),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0,),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffD3D3FF).withAlpha(200),),
                ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
                    },
                  child: Text("Let's go!", style: kDefaultTextStyle.copyWith(color: Colors.black, fontSize: 12.0),),),
            ),
          ],
        ),
      ),
    );
  }
}
