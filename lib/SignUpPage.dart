import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_copy/Data/Local/database_helper.dart';
import 'package:snapchat_copy/LoginPage.dart';
import 'package:snapchat_copy/Providers/BirthdayProvider.dart';

class signUpPage extends StatefulWidget {
  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  late TextEditingController fName;
  late TextEditingController lName;
  late TextEditingController Day;
  late TextEditingController Year;
  late TextEditingController username;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    fName = TextEditingController();
    lName = TextEditingController();
    Day = TextEditingController();
    Year = TextEditingController();
    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    fName.dispose();
    lName.dispose();
    Day.dispose();
    Year.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    DBManager db =DBManager.getInstance();

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth * 0.92,
            height: screenHeight * 0.8,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.yellow,
                        ),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.snapchat, size: 50),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: TextField(
                                controller: fName,
                                decoration: InputDecoration(
                                  hintText:
                                      'First Name', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: TextField(
                                controller: lName,
                                decoration: InputDecoration(
                                  hintText:
                                      'Last Name(Optional)', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          'Birthday',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 35,
                              child: Consumer<BirthdayProvider>(
                                builder: (context, birthdayProvider, _) {
                                  return DropdownButtonFormField<String>(
                                    value: birthdayProvider.selectedMonth,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        birthdayProvider.setMonth(newValue);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items:
                                        <String>[
                                          'January',
                                          'February',
                                          'March',
                                          'April',
                                          'May',
                                          'June',
                                          'July',
                                          'August',
                                          'September',
                                          'October',
                                          'November',
                                          'December',
                                        ].map<DropdownMenuItem<String>>((
                                          String month,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(month),
                                          );
                                        }).toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 35,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: Day,
                                decoration: InputDecoration(
                                  hintText: 'Day', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 35,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: Year,
                                decoration: InputDecoration(
                                  hintText: 'Year', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: TextField(
                                controller: username,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter your username', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 35,
                              child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter your password', // optional placeholder
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ), // <-- grey border
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'By tapping "Agree and Continue" below, you agree to the Terms of Service and acknowledge that you have read the Privacy Policy.',
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      final birthdayProvider = Provider.of<BirthdayProvider>(context, listen: false);
                      int currentYear = DateTime.now().year;
                      int? day = int.tryParse(Day.text);
                      int? year = int.tryParse(Year.text);
                      String? month = birthdayProvider.selectedMonth;

                      if (username.text.isEmpty ||
                          password.text.isEmpty ||
                          fName.text.isEmpty ||
                          Day.text.isEmpty ||
                          Year.text.isEmpty ||
                          month == null ||
                          month.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all required fields.', style: TextStyle(fontSize: 18)),
                          ),
                        );
                        return;
                      }

                      if (year == null || year > currentYear || year < 1900) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter a valid year between 1900 and $currentYear.', style: TextStyle(fontSize: 18)),
                          ),
                        );
                        return;
                      }

                      if (day == null || day < 1 || day > 31) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter a valid day between 1 and 31.', style: TextStyle(fontSize: 18)),
                          ),
                        );
                        return;
                      }

                      Map<String, int> maxDays = {
                        'January': 31,
                        'February': (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28,
                        'March': 31,
                        'April': 30,
                        'May': 31,
                        'June': 30,
                        'July': 31,
                        'August': 31,
                        'September': 30,
                        'October': 31,
                        'November': 30,
                        'December': 31,
                      };
                      if (day > maxDays[month]!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$month doesn\'t have more than ${maxDays[month]} days.', style: TextStyle(fontSize: 18)),
                          ),
                        );
                        return;
                      }

                      bool success = await DBManager.getInstance().createUser(
                        Username: username.text,
                        Password: password.text,
                        fName: fName.text,
                        lName: lName.text,
                        Day: day,
                        Year: year,
                        Month: month,
                      );
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => loginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unable to create user', style: TextStyle(fontSize: 18)),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Agree and Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Divider(
                    color: Colors.grey, // Optional: color of the line
                    thickness: 1,       // Optional: thickness of the line
                    indent: 20,         // Optional: space from the left
                    endIndent: 20,      // Optional: space from the right
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginPage()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Log in!",
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


