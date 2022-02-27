import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/auth_form.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthScren extends StatefulWidget {
  @override
  State<AuthScren> createState() => _AuthScrenState();
}

class _AuthScrenState extends State<AuthScren> {
  bool _isLoading = false;
  void _submitForm(
    String? email,
    String? password,
    String? username,
    bool isLogin,
    BuildContext ctx, //for snack bar only) {}
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin)
        await Provider.of<Auth>(context, listen: false).login(email, password);
      else
        await Provider.of<Auth>(context, listen: false)
            .register(email, username, password);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      String message = "Authorization Error";
      if (error.toString().contains('EmailExists')) {
        message = 'Email already exist';
      } else if (error.toString().contains('InvalidEmail')) {
        message = 'Invalid Email Address';
      } else if (error.toString().contains('InvalidUsername')) {
        message = 'Username Invalid';
      } else if (error.toString().contains('InvalidPassword')) {
        message = 'Password Invalid';
      } else if (error.toString().contains('InvalidCredentials')) {
        message = 'Invalid Credentials';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      print('printing error code');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitForm, _isLoading),
    );
  }
}
