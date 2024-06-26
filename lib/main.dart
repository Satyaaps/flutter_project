import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_project/pages/home_page.dart';
import 'package:flutter_project/pages/login_page.dart';
import 'package:flutter_project/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signIn': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/homePage': (context) => HomePage(),
      },
      initialRoute: '/signIn',
      checkerboardOffscreenLayers: false,
    );
  }
}
