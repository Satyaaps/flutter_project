import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/pages/home_page.dart';
import 'package:flutter_project/pages/signup_page.dart'; // Impor halaman SignupPage
import 'package:get_storage/get_storage.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';
import 'package:logger/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final myStorage = GetStorage();

  bool _passwordVisible = false;
  bool _invalidInput = false;
  bool _invalidEmail = false;
  bool _invalidPassword = false;
  String _warningText = '';

  void swapPasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void onSignInTap() {
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
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _invalidInput = true;
        _invalidPassword = true;

        Timer(const Duration(seconds: 3), () {
          setState(() {
            _invalidInput = false;
            _invalidPassword = false;
          });
        });
        _warningText = "Password can't be empty!";
      });
    } else {
      goLogin();
    }
  }

  void goLogin() async {
    var logger = Logger(printer: PrettyPrinter());
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://mobileapis.manpits.xyz/api/login',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      if (response.statusCode == 200) {
        myStorage.write('token', response.data['data']['token']);
        logger.i(response);
        Navigator.pushReplacementNamed(context, '/homePage');
      }
    } on DioError catch (e) {
      setState(() {
        _invalidInput = true;

        Timer(const Duration(seconds: 3), () {
          setState(() {
            _invalidInput = false;
          });
        });
        _warningText = e.response?.data['message'] ?? 'Something went wrong';
      });
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Color.fromARGB(255, 190, 153, 197).withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.email),
                      errorText: _invalidEmail ? 'Invalid email' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Color.fromARGB(255, 190, 153, 197).withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: swapPasswordVisibility,
                      ),
                      errorText: _invalidPassword ? 'Invalid password' : null,
                    ),
                  ),
                ],
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
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: onSignInTap,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color.fromARGB(255, 255, 255, 0),
                  ),
                ),
              ),
              const Center(child: Text("Or")),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
