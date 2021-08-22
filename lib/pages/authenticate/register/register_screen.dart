import 'package:chat_app/pages/authenticate/toggle.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  String _email = "";
  String _password = "";
  String _name = "";

  late String code;

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
                    "Register to Chat!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
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
                          maxLength: 40,
                          validator: (value) => validateName(value!),
                          onChanged: (value) {
                            setState(() => _name = value);
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                            hintText: 'Enter your name',
                            labelText: "Name",
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          maxLength: 36,
                            obscureText: _obscureText,
                            validator: (value) => validatePassword(value!),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () => {_toggle()},
                                  child: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                              counterText: '',
                              border: OutlineInputBorder(),
                              hintText: 'Enter your password',
                              labelText: "Password",
                            ),
                            onChanged: (value) {
                              setState(() => _password = value);
                            }),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          maxLength: 36,
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (value == _password) {
                                return null;
                              } else {
                                return "Password not same";
                              }
                            } else {
                              return "Password not blank";
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            suffixIcon: InkWell(
                                onTap: () => {_toggle()},
                                child: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            border: OutlineInputBorder(),
                            hintText: 'Enter your confirm password',
                            labelText: "Confirm Password",
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text("Have an Account?"),
                            SizedBox(width: 3),
                            InkWell(
                              splashColor: Colors.white,
                              child: Text(
                                "Login",
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
                                code = await auth.registrationEmail(
                                    _email, _password, _name);
                                if (code != "Success") {
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
                              'REGISTER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
}

String? validatePassword(String value) {
  Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = new RegExp(pattern.toString());
  if (value.isEmpty) {
    return 'Please enter password';
  } else if (value.length < 8) {
    return 'Password length atleast 8';
  } else {
    if (!regex.hasMatch(value))
      return 'Password atleast have one uppercase, lowercase and number';
    else
      return null;
  }
}

String? validateName(String value) {
  Pattern pattern = r'^[a-zA-Z ]+$';
  RegExp regex = new RegExp(pattern.toString());
  if (value.isEmpty) {
    return 'Please enter your name';
  } else if (value.length < 3) {
    return 'Password length atleast 3';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Invalid username must character!';
    } else {
      return null;
    }
  }
}
