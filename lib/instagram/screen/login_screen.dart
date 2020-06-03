import 'package:doantotnghiep2020/instagram/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPass = false;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //login
      AuthService.login(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.cover)),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 400),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                  3.8,
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blue[100],
                                              blurRadius: 20.0,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.grey[100]))),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                labelText: 'Email',
                                              ),
                                              validator: (input) => input
                                                      .contains('@gmail.com')
                                                  ? null
                                                  : 'Hãy nhập email đúng dịnh dạng',
                                              onSaved: (input) =>
                                                  _email = input,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.lock_open,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                labelText: 'Mật khẩu',
                                              ),
                                              validator: (input) => input
                                                          .length <
                                                      6
                                                  ? 'Mật khẩu phải lớn hơn 6 ký tự'
                                                  : null,
                                              onSaved: (input) =>
                                                  _password = input,
                                              obscureText: !_showPass,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              FadeAnimation(
                                  2,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .4),
                                        ])),
                                    child: Center(
                                      child: FlatButton(
                                        onPressed: _submit,
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(),
                              FadeAnimation(
                                  1.5,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, SignupScreen.id),
                                        child: Text(
                                          "Sign up",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)),
                                        ),
                                      ),
                                      Text(
                                        "Forget password ?",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)),
                                      ),
                                    ],
                                  )),
                                  SizedBox(height: 65.0,)
                            ],
                          ),
                        ),
                        Positioned(
                          right: 50,
                          bottom: 365,
                          child: GestureDetector(
                            onTap: onToggleShowPass,
                            child: FadeAnimation(
                              3.8,
                              Text(
                                _showPass ? "HIDE" : "SHOW",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onToggleShowPass() {
    // Show password
    setState(() {
      _showPass = !_showPass;
    });
  }
}
