import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class Authenticate extends StatefulWidget {
  final bool register;
  final Function toggleScreen;

  const Authenticate(
      {Key? key, required this.register, required this.toggleScreen})
      : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String email = "";
  String password = "";
  String authError = "";
  bool showPassword = false;

  final FirebaseAuthService _authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required.'),
    MinLengthValidator(8,
        errorText: 'Password must be at least 8 digits long.'),
  ]);

  Widget onAuthError() {
    if (authError == "") {
      return SizedBox(
        height: 20,
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        authError,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PlatformScaffold(
        backgroundColor: Colors.white,
        iosContentPadding: true,
        appBar: PlatformAppBar(
          backgroundColor: AppColors.secondaryUofIDark,
          title: widget.register
              ? Text(
                  "Sign up for OnePlace",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "Sign in to OnePlace",
                  style: TextStyle(color: Colors.white),
                ),
          trailingActions: <Widget>[
            TextButton.icon(
              icon: Icon(
                PlatformIcons(context).person,
                color: AppColors.urbanaOrange,
              ),
              label: Text(
                widget.register ? "Sign In" : "Register",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => widget.toggleScreen(),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.secondaryUofILight,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: EmailValidator(
                      errorText: "Please enter a valid email address."),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.secondaryUofILight,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: PlatformIconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: showPassword
                          ? Icon(PlatformIcons(context).eyeSolid)
                          : Icon(PlatformIcons(context).eyeSlashSolid),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: passwordValidator,
                ),
                onAuthError(),
                PlatformElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic user;
                      if (widget.register) {
                        user = await _authService.register(email, password);
                      } else {
                        user = await _authService.signIn(email, password);
                      }
                      if (user is FirebaseAuthException) {
                        if (user.code == 'weak-password') {
                          setState(() {
                            authError = "The password provided is too weak.";
                          });
                        } else if (user.code == 'email-already-in-use') {
                          setState(() {
                            authError =
                                "The account already exists for that email.";
                          });
                        } else if (user.code == "user-not-found") {
                          setState(() {
                            authError = "This account does not exist.";
                          });
                        }
                      }
                    }
                  },
                  child: Text(
                    widget.register ? "Register" : "Sign In",
                  ),
                  cupertino: (context, platform) =>
                      CupertinoElevatedButtonData(color: AppColors.primaryUofI),
                  material: (context, platform) => MaterialElevatedButtonData(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryUofI))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}