import 'package:chat_app/pages/authenticate/toggle.dart';
import 'package:chat_app/pages/home/home_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  String _email = "";
  String _password = "";

  late String code;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome to Chat!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Keep your privacy safe!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            maxLength: 36,
                            validator: (value) => EmailValidator.validate(value!)
                                ? null
                                : "Please enter a valid email",
                            onChanged: (value) {
                              setState(() => _email = value);
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              hintText: 'Enter your email',
                              labelText: "Email",
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                              maxLength: 36,
                              obscureText: _obscureText,
                              validator: (value) => value!.isNotEmpty
                                  ? null
                                  : "Please not blank password",
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: () => {_toggle()},
                                    child: Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintText: 'Enter your password',
                                labelText: "Password",
                              ),
                              onChanged: (value) {
                                setState(() => _password = value);
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text("Don\'t Have Account?"),
                              SizedBox(width: 3),
                              InkWell(
                                splashColor: Colors.white,
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  final _toggle =
                                      Provider.of<Toggle>(context, listen: false);
                                  _toggle.changeStatus();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  AuthService auth = new AuthService();
                                  code = await auth.loginEmail(_email, _password);
                                  if(code != "Success"){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(code),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                }
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
