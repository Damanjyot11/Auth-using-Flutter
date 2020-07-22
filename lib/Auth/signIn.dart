import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/Auth/signUp.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body:
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Invalid Email or Password';
                }
                return null;
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              validator: (input) {
                if(input.length < 6){
                  return 'Invalid Email or Password';
                }
                return null;
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: 'Password'),
             obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Login'),
            ),
            Text("\n\nCreate a New Account"),
            RaisedButton(
              onPressed: NavigateToSignUp,
              child: Text("SignUp"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        if (user.isEmailVerified) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
        }
        else{
          Fluttertoast.showToast(
              msg: "Verify Your Email-id",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.redAccent,
              fontSize: 16.0
          );
        }
      }catch(e){
        print(e.message);
      }
    }
  }

  void NavigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }
}
