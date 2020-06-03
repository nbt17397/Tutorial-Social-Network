import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //login
      AuthService.signUpUser(context, _name, _email, _password);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                            EdgeInsets.only(right: 30.0, left: 30.0, top: 350),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                3.8,
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
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
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              labelText: 'Họ tên',
                                              prefixIcon: Icon(
                                                Icons.person_pin,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            validator: (input) =>
                                                input.length < 4
                                                    ? 'Hãy ghi rõ họ tên'
                                                    : null,
                                            onSaved: (input) => _name = input,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[100]))),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.email,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              labelText: 'Email',
                                            ),
                                            validator: (input) => input
                                                    .contains('@gmail.com')
                                                ? null
                                                : 'Hãy nhập email đúng dịnh dạng',
                                            onSaved: (input) => _email = input,
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
                                            validator: (input) => input.length <
                                                    6
                                                ? 'Mật khẩu phải lớn hơn 6 ký tự'
                                                : null,
                                            onSaved: (input) =>
                                                _password = input,
                                            obscureText: true,
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
                                        "Sign Up",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(),
                            FadeAnimation(
                              1.5,
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Back to login",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 45.0,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
