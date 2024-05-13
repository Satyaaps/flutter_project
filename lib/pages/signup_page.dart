import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_project/pages/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = false;
  bool _invalidInput = false;
  bool _invalidEmail = false;
  bool _invalidUsername = false;
  bool _invalidPassword = false;
  String _warningText = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final myStorage = GetStorage();

  void onCreateAccountTap() {
    if (!emailValidator() || !passwordValidator()) {
      return;
    } else {
      goRegister();
    }
  }

  void goRegister() async {
    final dio = Dio();
    var logger = Logger();
    try {
      final response = await dio.post(
        'https://mobileapis.manpits.xyz/api/register',
        data: {
          'email': _emailController.text,
          'name': _usernameController.text,
          'password': _passwordController.text,
        },
      );
      logger.i(response);
      if (response.statusCode == 200) {
        try {
          final response = await dio.post(
            'https://mobileapis.manpits.xyz/api/login',
            data: {
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          );
          logger.i(response);
          if (response.statusCode == 200) {
            myStorage.write('token', response.data['data']['token']);
            Navigator.pushReplacementNamed(context, '/homePage');
          }
        } on DioError catch (e) {
          handleDioError(e);
        }
      }
    } on DioError catch (e) {
      handleDioError(e);
    }
  }

  void handleDioError(DioError e) {
    setState(() {
      _invalidInput = true;
      Timer(const Duration(seconds: 3), () {
        setState(() {
          _invalidInput = false;
        });
      });
      _warningText = e.response?.data['message'] ?? 'Something went wrong';
    });
    var logger = Logger();
    logger.e(e);
  }

  bool emailValidator() {
    if (!EmailValidator.validate(_emailController.text)) {
      setState(() {
        _invalidInput = true;
        _invalidEmail = true;
        Timer(const Duration(seconds: 3), () {
          setState(() {
            _invalidInput = false;
            _invalidEmail = false;
          });
        });
        _warningText = "Please enter a valid email";
      });
      return false;
    }
    return true;
  }

  bool passwordValidator() {
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6 ||
        _passwordController.text.contains(RegExp(r'[0-9]')) == false ||
        _passwordController.text.contains(RegExp(r'[A-Z]')) == false ||
        _passwordController.text.contains(RegExp(r'[a-z]')) == false ||
        _passwordController.text
                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ==
            false ||
        _passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _invalidInput = true;
        _invalidPassword = true;
        Timer(const Duration(seconds: 3), () {
          setState(() {
            _invalidInput = false;
            _invalidPassword = false;
          });
        });
        _warningText = "Invalid Password";
      });
      return false;
    }
    return true;
  }

  void swapPasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 17, 17, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 84),
              PngPicture.asset(
                'lib/asset/image/log-in.png',
                semanticsLabel: 'Hero Image',
                height: 200,
                width: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: _invalidEmail
                              ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                )
                              : const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              : BorderSide(
                              color: Color.fromRGBO(215, 252, 112, 1),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: swapPasswordVisibility,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: _invalidPassword
                                ? const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  )
                                : const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(215, 252, 112, 1),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: swapPasswordVisibility,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _invalidInput,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        _warningText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: GestureDetector(
                    onTap: onCreateAccountTap,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(215, 252, 112, 1),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 114),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(27, 32, 51, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PngPicture {
  static asset(String s, {required String semanticsLabel, required int height, required int width}) {}
}
