import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:moans/utils/utilities.dart';
import 'dart:io' show File;

class Server {
  static Future<int> logIn(
      String email, String password, BuildContext? context) async {
    var _passbyte = utf8.encode(password);
    var _passhash = sha256.convert(_passbyte);
    var _user = {"email": email, "password": _passhash.toString()};
    if (context != null) {
      Utilities.showLoadingScreen(context);
    }
    try {
      var responce = await http.post(Uri.parse(Utilities.url + "auth/"),
          body: jsonEncode(_user),
          headers: {"Content-Type": "application/json"});
      if (context != null) {
        Navigator.of(context).pop();
      }
      if (responce.statusCode == 200) {
        Map userInfo = jsonDecode(responce.body);
        Utilities.authToken = userInfo["access_token"];
        Utilities.email = email;
        Utilities.setUser(email, password);
        return 200;
      } else {
        return responce.statusCode;
      }
    } catch (e) {
      if (context != null) {
        Navigator.of(context).pop();
      }
      return 404;
    }
  }

  static Future<int> signUp(
      String email, String password, BuildContext? context) async {
    var passbyte = utf8.encode(password);
    var passhash = sha256.convert(passbyte);
    var user = {
      "email": email,
      "password": passhash.toString(),
      "password2": passhash.toString()
    };
    if (context != null) {
      Utilities.showLoadingScreen(context);
    }
    try {
      var responce = await http.post(Uri.parse(Utilities.url + "users/"),
          body: jsonEncode(user),
          headers: {"Content-Type": "application/json"});
      if (context != null) {
        Navigator.of(context).pop();
      }
      return responce.statusCode;
    } catch (e) {
      if (context != null) {
        Navigator.of(context).pop();
      }
      return 404;
    }
  }

  static Future<Map> getTracks(Map<String, String> parameters) async {
    Map errorMap = {"status_code": 404, "tracks_info": ""};
    try {
      var responce = await http.get(
          Utilities.getUri(Utilities.url + "tracks/", parameters),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      if (responce.statusCode == 200) {
        Map trackInfo = {
          "status_code": 200,
          "tracks_info": jsonDecode(utf8.decode(responce.bodyBytes))
        };
        return trackInfo;
      } else {
        return errorMap;
      }
    } catch (e) {
      return errorMap;
    }
  }

  static Future<int> refreshFeed() async {
    try {
      var responce =
          await http.get(Uri.parse(Utilities.url + "tracks/refresh"), headers: {
        "Authorization": "Bearer " + Utilities.authToken,
        "Content-Type": "application/json"
      });
      return responce.statusCode;
    } catch (e) {
      return 404;
    }
  }

  static Future<int> uploadTrack(
      Map<String, String> parameters, filePath, BuildContext context) async {
    try {
      Utilities.showLoadingScreen(context);
      var request =
          http.MultipartRequest('POST', Uri.parse(Utilities.url + "tracks/"));
      request.headers.addAll({
        "Authorization": "Bearer " + Utilities.authToken,
        "Content-Type": "multipart/form-data"
      });
      File record = File.fromUri(Uri.parse(filePath));
      request.fields.addAll(parameters);
      request.files
          .add(await http.MultipartFile.fromPath("record", record.path));
      var res = await request.send();
      var responced = await http.Response.fromStream(res);
      Navigator.of(context).pop();
      return responced.statusCode;
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      return 404;
    }
  }

  static Future<Map> getProfileTracks(Map<String, String> parameters) async {
    Map errorMap = {"status_code": 404, "tracks_info": ""};
    try {
      var responce = await http.get(
          Utilities.getUri(Utilities.url + "tracks/my_tracks", parameters),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      if (responce.statusCode == 200) {
        Map trackInfo = {
          "status_code": 200,
          "tracks_info": jsonDecode(utf8.decode(responce.bodyBytes))
        };
        return trackInfo;
      } else {
        return errorMap;
      }
    } catch (e) {
      return errorMap;
    }
  }

  static Future<Map> getEditTrackInfo(int trackId, BuildContext context) async {
    Map errorMap = {"status_code": 404, "tracks_info": ""};
    Map<String, String> trackIdMap = {"track_id": trackId.toString()};
    try {
      Utilities.showLoadingScreen(context);
      var responce = await http.get(
          Utilities.getUri(Utilities.url + "tracks/track/", trackIdMap),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      Navigator.of(context).pop();
      if (responce.statusCode == 200) {
        Map trackInfo = {
          "status_code": 200,
          "track_info": jsonDecode(utf8.decode(responce.bodyBytes))
        };
        return trackInfo;
      } else {
        return errorMap;
      }
    } catch (e) {
      Navigator.of(context).pop();
      return errorMap;
    }
  }

  static Future<int> editTrackInfo(
      Map<String, String> parameters, BuildContext context) async {
    try {
      Utilities.showLoadingScreen(context);
      var request = http.MultipartRequest(
          'POST', Uri.parse(Utilities.url + "tracks/update"));
      request.headers.addAll({
        "Authorization": "Bearer " + Utilities.authToken,
        "Content-Type": "application/x-www-form-urlencoded"
      });
      request.fields.addAll(parameters);
      var res = await request.send();
      var responced = await http.Response.fromStream(res);
      Navigator.of(context).pop();
      return responced.statusCode;
    } catch (e) {
      Navigator.of(context).pop();
      return 404;
    }
  }

  static Future<int> likeRequest(Map<String, String> parameters) async {
    try {
      var responce = await http.patch(
          Utilities.getUri(Utilities.url + "tracks/like", parameters),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      return responce.statusCode;
    } catch (e) {
      return 404;
    }
  }

  static Future<int> changePassword(
      Map<String, String> parameters, BuildContext context) async {
    String newPass = parameters["new_password"]!;
    var passbyteOld = utf8.encode(parameters["password"]!);
    var passhashOld = sha256.convert(passbyteOld);
    var passbyteNew = utf8.encode(parameters["new_password"]!);
    var passhashNew = sha256.convert(passbyteNew);
    parameters["password"] = passhashOld.toString();
    parameters["new_password"] = passhashNew.toString();
    try {
      Utilities.showLoadingScreen(context);
      var responce = await http.patch(Uri.parse(Utilities.url + "users/"),
          body: jsonEncode(parameters),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      Navigator.of(context).pop();
      if (responce.statusCode == 200) {
        Utilities.setNewPassword(newPass);
      }
      return responce.statusCode;
    } catch (e) {
      Navigator.of(context).pop();
      return 404;
    }
  }

  static Future<int> changeTrackStatus(
      int trackId, Statuses status, BuildContext context) async {
    try {
      Map<String, String> parameters = {
        "track_id": trackId.toString(),
        "track_status": Statuses.values.indexOf(status).toString()
      };
      Utilities.showLoadingScreen(context);
      var request = http.MultipartRequest(
          'PATCH', Uri.parse(Utilities.url + "tracks/set_track_status"));
      request.headers.addAll({
        "Authorization": "Bearer " + Utilities.authToken,
        "Content-Type": "application/x-www-form-urlencoded"
      });
      request.fields.addAll(parameters);
      var res = await request.send();
      var responced = await http.Response.fromStream(res);
      Navigator.of(context).pop();
      return responced.statusCode;
    } catch (e) {
      Navigator.of(context).pop();
      return 404;
    }
  }

  static Future<int> googleSignUp(BuildContext context) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      Utilities.showLoadingScreen(context);
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await _googleSignIn.currentUser!.authentication;
      await Server.signUp(
          _googleSignIn.currentUser!.email, googleAuth.accessToken!, null);
      int statusCodeLogin = await Server.logIn(
          _googleSignIn.currentUser!.email, googleAuth.accessToken!, null);
      Navigator.of(context).pop();
      return statusCodeLogin;
    } catch (e) {
      Navigator.of(context).pop();
      return 404;
    }
  }
}
