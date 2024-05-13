// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:dio/dio.dart';

// void main() async {
//   await GetStorage.init();
//   runApp(MainApp());
// }

// class MainApp extends StatelessWidget {
//   MainApp({super.key});

//   final _dio = Dio();
//   final _storage = GetStorage();
//   final _apiUrl = 'https://mobileapis.manpits.xyz/api';

//   void goLogin() {
//     ElevatedButton(
//       onPressed: () {
//         goLogin();
//       },
//       child: const Text('Login'),
//     );
//   }

//   void goUser() {
//     ElevatedButton(
//       onPressed: () {
//         goUser();
//       },
//       child: const Text('Get User'),
//     );
//   }

//   void goLogout() {
//     ElevatedButton(
//       onPressed: () {
//         goLogout();
//       },
//       child: const Text('Logout'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('MainApp'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: goLogin,
//                 child: const Text('Login'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: goUser,
//                 child: const Text('User Page'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: goLogout,
//                 child: const Text('Logout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void goLogin() async {
//   try {
//     final _response = await _dio.post(
//       '${_apiUrl}/login',
//       data: {
//         'email': 'admin@gmail.com',
//         'password': 'admin',
//       },
//     );
//     print(_response.data);
//     _storage.write('token', _response.data['data']['token']);
//   } on DioException catch (e) {
//     print('${e.response} - ${e.response?.statusCode}');
//   }
// }

// void goUser() async {
//   try {
//     final _response = await _dio.get(
//       '${_apiUrl}/user',
//       option: Options(
//         headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
//       ),
//     );
//     print(_response.data);
//   } on DioException catch (e) {
//     print('${e.response} - ${e.response?.statusCode}');
//   }
// }

// void goLogout() async {
//   try {
//     final _response = await _dio.get(
//       '${_apiUrl}/logout',
//       option: Options(
//         headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
//       ),
//     );
//     print(_response.data);
//   } on DioException catch (e) {
//     print('${e.response} - ${e.response?.statusCode}');
//   }
// }
