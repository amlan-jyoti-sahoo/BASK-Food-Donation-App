import 'package:bask_app/screen/sign_up_and_user_detail_screen.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/widget/gradient_widget.dart';
import 'package:bask_app/widget/alret_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isPasswordVisible = false;
  bool isTriedToSubmit = false;
  bool isLoding = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();

  void signInWithEmail() async {
    if (loginFormkey.currentState!.validate()) {
      print('validated');
      final auth = Provider.of<Auth>(context, listen: false);
      try {
        setState(() {
          isLoding = true;
        });
        await auth.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
      } on Exception catch (e) {
        print(e.toString());
        setState(() {
          isLoding = false;
        });
        showExceptionAlertDialog(
          context,
          title: 'Sign in failed',
          exception: e,
        );
      }
    } else {
      setState(() {
        isTriedToSubmit = true;
      });
    }
  }

  void signInWithGoogle() async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        isLoding = true;
      });
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      setState(() {
        isLoding = false;
      });
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void signInWithFacebook() async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        isLoding = true;
      });
      await auth.signInWithFacebook();
    } on Exception catch (e) {
      setState(() {
        isLoding = false;
      });
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLoding)
                    Text(
                      'LOG IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  if (isLoding)
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: ClipPath(
                            clipper: TopClipper(),
                            child: Container(
                              height: 320,
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Form(
                                  autovalidate: isTriedToSubmit,
                                  key: loginFormkey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: 45),
                                      TextFormField(
                                        controller: emailController,
                                        enabled: !isLoding,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          prefixIcon: makeWidgetGradient(
                                            child: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: 'Email required *'),
                                          EmailValidator(
                                              errorText: 'not a valid email')
                                        ]),
                                        autocorrect: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      SizedBox(height: 15),
                                      TextFormField(
                                        enabled: !isLoding,
                                        controller: passwordController,
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: makeWidgetGradient(
                                            child: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),
                                          ),
                                          suffixIcon: passwordController
                                                  .text.isNotEmpty
                                              ? (isPasswordVisible
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isPasswordVisible =
                                                              !isPasswordVisible;
                                                        });
                                                      },
                                                      icon: makeWidgetGradient(
                                                        child: Icon(
                                                          Icons.visibility_off,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isPasswordVisible =
                                                              !isPasswordVisible;
                                                        });
                                                      },
                                                      icon: makeWidgetGradient(
                                                        child: Icon(
                                                          Icons.visibility,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ))
                                              : Container(
                                                  width: 0,
                                                ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: 'Password required *'),
                                          // PatternValidator(
                                          //     r'(?=.*?[#?!@$%^&*-])',
                                          //     errorText:
                                          //         'passwords must have at least one special character'),
                                          LengthRangeValidator(
                                              min: 6,
                                              max: 20,
                                              errorText:
                                                  'Password must be 6 to 20 character long')
                                        ]),
                                        textInputAction: TextInputAction.done,
                                        obscureText: !isPasswordVisible,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Forgot Password ?',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      SizedBox(height: 15),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              onSurface: Colors.green,
                                              shape: CircleBorder(),
                                              fixedSize: Size(45, 45)),
                                          onPressed:
                                              isLoding ? null : signInWithEmail,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 30,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 280, left: 20, right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: ClipPath(
                            clipper: BottomClipper(),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('OR'),
                                    SizedBox(height: 10),
                                    Text('Log In With Social Media'),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: signInWithFacebook,
                                          icon: Icon(
                                            Icons.facebook_outlined,
                                            color: isLoding
                                                ? Colors.lightBlue.shade100
                                                : Colors.lightBlue,
                                            size: 40,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange.shade800,
                                              shape: CircleBorder(),
                                              onSurface: Colors.red,
                                            ),
                                            onPressed: isLoding
                                                ? null
                                                : signInWithGoogle,
                                            child: Icon(
                                              Icons.g_mobiledata_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return SignUpScreen(isThirdpartySignup: false);
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Click Here ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
