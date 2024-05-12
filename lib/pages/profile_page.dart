import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final myStorage = GetStorage();
  static const String _apiUrl = "https://mobileapis.manpits.xyz/api";
  dynamic userData;

  void getUserData() async {
    var logger = Logger();
    try {
      var response = await Dio().get("$_apiUrl/user",
          options: Options(
              headers: {'Authorization': "Bearer ${myStorage.read("token")}"}));

      if (response.statusCode == 200) {
        setState(() {
          userData = response.data["data"]["user"];
        });
      } else {
        throw DioException.connectionTimeout;
      }
    } on DioError catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          children: [
            const Text('Profile',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(214, 251, 112, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat')),
            _buildProfileRow(
                'Name', userData != null ? userData["name"] : "Loading..."),
            _buildProfileRow(
                'Email', userData != null ? userData["email"] : "Loading..."),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text('$label ',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(214, 251, 112, 1),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat')),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(value,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(214, 251, 112, 1),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat')),
          ),
        ],
      ),
    );
  }
}
