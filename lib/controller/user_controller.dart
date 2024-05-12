import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "package:dio/dio.dart";
import "package:get_storage/get_storage.dart";
import "package:logger/logger.dart";

class UserController {
  static const String _apiUrl = "https://mobileapis.manpits.xyz/api";
  final myStorage = GetStorage();

  static dynamic getUserData() async {
    final myStorage = GetStorage();
    var logger = Logger();
    try {
      var response = await Dio().get("$_apiUrl/user",
          options: Options(
              headers: {'Authorization': "Bearer ${myStorage.read("token")}"}));

      if (response.statusCode == 200) {
        return response.data["data"]["user"];
      } else {
        throw DioException.connectionTimeout;
      }
    } on DioException catch (e) {
      logger.e(e);
    }
  }
}
