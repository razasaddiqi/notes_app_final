import 'package:flutter/material.dart';
import 'package:notes_app_final/animation/FadeAnimation.dart';
import 'package:notes_app_final/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'Notes.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginaPageState createState() => _LoginaPageState();
}
class _LoginaPageState extends State<LoginPage> {
  void _signInWithEmailAndPassword() async {

    User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        //
        // _success = true;
        // _userEmail = user.email;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotesPage(auth: _auth,user: user,)));
      });
    } else {
      setState(() {
        print("fail");
        // _success = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(1, Text("Login", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),)),
                      SizedBox(height: 20,),
                      FadeAnimation(1.2, Text("Login to your account", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.2, makeInput(label: "Email",controller_: _emailController)),
                        FadeAnimation(1.3, makeInput(label: "Password", obscureText: true,controller_: _passwordController)),
                      ],
                    ),
                  ),
                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          _signInWithEmailAndPassword();
                          // Navigator.pushReplacement(
                          //     context, MaterialPageRoute(builder: (context) => SignupPage()));
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Login", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  )),
                  FadeAnimation(1.5, Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),

                      MaterialButton(
                        minWidth: double.infinity,
                        height: 18,
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => SignupPage()));
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Signup", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            FadeAnimation(1.2, Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.fill
                  )
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false,controller_}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: controller_,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}