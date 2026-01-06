import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_copy/CameraPage.dart';
import 'package:snapchat_copy/Data/Local/database_helper.dart';
import 'package:snapchat_copy/Providers/BirthdayProvider.dart';
import 'package:snapchat_copy/SignUpPage.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  late TextEditingController username;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Snapchat Login')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: screenWidth * 0.92,
            height: screenHeight * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(0, 5), // shadow only below
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(45)
                    ),
                    child: Center(child: FaIcon(FontAwesomeIcons.snapchat, size: 60))
                  ),
                  Text(
                    'Log in to Snapchat',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: screenWidth * 0.8,
                    child: Text(
                      'Username or email address',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.8,
                    height: 50,
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: screenWidth * 0.8,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.8,
                    height: 50,
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    width: 130,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      onPressed: () async {
                        if (username.text.isEmpty || password.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter both username and password.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                          return;
                        }

                        bool loggedIn = await DBManager.getInstance().loginUser(
                          username.text.trim(),
                          password.text.trim(),
                        );

                        if (loggedIn) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>cameraPage(username: username.text.trim())));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Invalid username or password.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        }
                      }
                      ,
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New to Snapchat? ', style: TextStyle(fontSize: 20)),
                      InkWell(
                        onTap: () {
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
                        child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
