import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Auth/signIn.dart';

import '../Database.dart';


class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp>{
  String _name,_email, _password,_phoneNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Account'),
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
                if(input.isEmpty){
                  return 'Invalid Username';
                }
                return null;
              },
              onSaved: (input) => _name = input,
              decoration: InputDecoration(labelText: 'UserName'),
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
            TextFormField(
              validator: (input) {
                if(input.length != 10){
                    return 'Invalid Contact Details';
                }
                return null;
              },
              onSaved: (input) => _phoneNumber = input,
              decoration: InputDecoration(labelText: 'Contact Details'),
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        user.sendEmailVerification();
        await DatabaseService(uid: user.uid).updateUserData(_name, _phoneNumber, _email);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(e){
        print(e.message);
      }
    }
  }
}
