import 'package:flutter/material.dart';
import 'dart:convert';
// import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

class ApiService {
  String? userId;
  String? accessToken;
  String? devicetoken;
  Dio dio = Dio();

  ApiService(userData);

  Future signUpCheck(userData) async {
    try {
      var passCode = userData['passCode'];
      var reqNumber = userData['reqNumber'];
      var ic = userData['ic'];
      var email = userData['email'];
      var phone = userData['phone'];
      var url =
          "http://10.10.0.11/trakcare/web/his/app/API/general.csp?passCode=$passCode&reqNumber=$reqNumber&ic=$ic&email=$email&phone=$phone";

      print("Url API = $url");

      return dio
          .post(url,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((Response response) async {
        print("Response = $response");
        print("email = $email");
        print("ic = $ic");
        print("phone = $phone");

        var data = response.toString();
        var jsonData = jsonDecode(data);

        return jsonData;
      });
    } catch (e) {
      print("Error message ${e}");
    }
  }

  Future loginCheck(userData) async {
    try {
      var email = userData['email'];
      var password = userData['password'];
      var passCode = userData['passCode'];
      var reqNumber = userData['reqNumber'];
      var url =
          "http://10.10.0.11/trakcare/web/his/app/API/general.csp?email=$email&password=$password&passCode=$passCode&reqNumber=$reqNumber";

      print("Url API = $url");

      return dio
          .post(url,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((Response response) async {
        print("Response = $response");
        print("email = $email");
        print("password = $password");

        var data = response.toString();
        var jsonData = jsonDecode(data);

        return jsonData;
      });
    } catch (e) {
      print("Error message ${e}");
    }
  }

  Future forgotPasswordCheck(userData) async {
    try {
      var passCode = userData['passCode'];
      var reqNumber = userData['reqNumber'];
      var ic = userData['ic'];
      var email = userData['email'];
      var phone = userData['phone'];
      var url =
          "http://10.10.0.11/trakcare/web/his/app/API/general.csp?passCode=$passCode&reqNumber=$reqNumber&ic=$ic&email=$email&phone=$phone";

      print("Url API = $url");

      return dio
          .post(url,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((Response response) async {
        print("Response = $response");
        print("email = $email");
        print("ic = $ic");
        print("phone = $phone");

        var data = response.toString();
        var jsonData = jsonDecode(data);

        return jsonData;
      });
    } catch (e) {
      print("Error message ${e}");
    }
  }

  Future updatePatientApi(userData) async {
    try {
      var url =
          "http://www.truecare2u.com.my/web/truecare2u/API/patient/update.php";
      var data;
      return await dio
          .post(url,
              data: userData,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((Response response) async {
        var statusCode = response.statusCode;
        print("status code ==== $statusCode");
        if (statusCode! < 200 || statusCode > 400 || json == null) {
          print("status code ===== $statusCode");
          throw new Exception("Error while fetching data 1 $statusCode");
        }
        data = response.toString();
        final jsonData = jsonDecode(data);
        // print('data response is ====== $jsonData');
        return jsonData;
      });
    } catch (e) {
      // print("error message ${e}");
    }
  }
}
