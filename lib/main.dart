import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'login_page.dart'; // Impor halaman LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
