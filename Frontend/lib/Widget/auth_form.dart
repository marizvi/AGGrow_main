import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(String? email, String? password, String? username,
      bool isLogin, BuildContext ctx) submitForm;
  final bool _isLoading;
  AuthForm(this.submitForm, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';

  AnimationController? controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 280));
    _opacityAnimation = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: controller as Animation<double>, curve: Curves.easeInSine));
    _slideAnimation = Tween(begin: Offset(0, -0.9), end: Offset(0, 0)).animate(
        //Offset(x,y)
        CurvedAnimation(
            parent: controller as Animation<double>,
            curve: Curves.easeInOutQuad));
  }

  void _submit() {
    FocusScope.of(context).unfocus(); //will close the keyboard
    final isValid = _formKey.currentState!.validate();
    // .validate is a boolean type and will return true if all
    // validated fields return null
    if (isValid) {
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces

      widget.submitForm(
        _userEmail!.trim(),
        _userPassword!.trim(),
        _userName!.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin) {
      controller!.reverse();
    } else {
      controller!.forward();
    }
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bb12.jpg'), fit: BoxFit.fill)),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 260),
            curve: Curves.easeInOutQuad,
            height: _isLogin ? 240 : 370,
            child: Card(
                margin: EdgeInsets.symmetric(horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 8,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: ValueKey('userEmail'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null; //means everything is alright
                          },
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                        if (!_isLogin)
                          FadeTransition(
                            opacity: _opacityAnimation as Animation<double>,
                            child: SlideTransition(
                              position: _slideAnimation as Animation<Offset>,
                              child: TextFormField(
                                key: ValueKey('userName'),
                                decoration:
                                    InputDecoration(label: Text('Username')),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null; //means everything is alright.
                                },
                                onSaved: (value) {
                                  _userName = value;
                                },
                              ),
                            ),
                          ),
                        TextFormField(
                          key: ValueKey('Password'),
                          decoration: InputDecoration(label: Text('Password')),
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return 'Password must be atleast 8 characters';
                            }
                            return null; //means everything is alright.
                          },
                          obscureText: true,
                          onSaved: (value) {
                            _userPassword = value;
                          },
                        ),
                        if (!_isLogin)
                          FadeTransition(
                            opacity: _opacityAnimation as Animation<double>,
                            child: SlideTransition(
                              position: _slideAnimation as Animation<Offset>,
                              child: TextFormField(
                                key: ValueKey('ConfirmPassword'),
                                decoration: InputDecoration(
                                    label: Text('Confirm Password')),
                                validator: (value) {
                                  if (_passwordController.text != value) {
                                    return 'password does not matches';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget._isLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.teal),
                            onPressed: _submit,
                            child: Text(_isLogin ? 'Login' : 'Register'),
                          ),
                        TextButton(
                          style:
                              TextButton.styleFrom(primary: Colors.teal[400]),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create Account'
                              : 'Already have an account?'),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }
}
