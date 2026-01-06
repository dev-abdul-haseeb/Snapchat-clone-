import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_copy/LoginPage.dart';
import 'package:snapchat_copy/Providers/BirthdayProvider.dart';
import 'package:snapchat_copy/SignUpPage.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow,
        child: Stack(
          children: [
            Center(child: FaIcon(FontAwesomeIcons.snapchat, size: 100)),
            Positioned(
              bottom: screenHeight*0.15,
              left: screenWidth*0.13,
              child: Container(
                width: 140,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginPage(),));
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight*0.15,
              right: screenWidth*0.13,
              child: Container(
                width: 140,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context){
                            return BirthdayProvider();
                          },
                          child: signUpPage(),
                        );
                      }),
                    );
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
