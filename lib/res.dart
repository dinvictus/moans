import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum Languages { russian, english }
enum Voices { she, he, they, sheHe, sheThey, heThey, sheHeThey }
enum Statuses { draft, publish, banned, deleted }

class NotifyLogout extends ChangeNotifier {
  logOut() {
    notifyListeners();
  }
}

class NoneOverscroll extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

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
        print(userInfo["access_token"]);
        Utilities.setUser(email, password);
        return 200;
      } else {
        return responce.statusCode;
      }
    } catch (e) {
      return 404;
    }
  }

  static Future<int> signUp(
      String email, String password, BuildContext context) async {
    var passbyte = utf8.encode(password);
    var passhash = sha256.convert(passbyte);
    var user = {
      "email": email,
      "password": passhash.toString(),
      "password2": passhash.toString()
    };
    Utilities.showLoadingScreen(context);
    try {
      var responce = await http.post(Uri.parse(Utilities.url + "users/"),
          body: jsonEncode(user),
          headers: {"Content-Type": "application/json"});
      Navigator.of(context).pop();
      return responce.statusCode;
    } catch (e) {
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
          "tracks_info": jsonDecode(responce.body)
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
        "Content-Type": "application/json"
      });
      request.fields.addAll(parameters);
      request.files.add(await http.MultipartFile.fromPath("record", filePath));
      var res = await request.send();
      var responced = await http.Response.fromStream(res);
      Navigator.of(context).pop();
      print(responced.statusCode);
      return responced.statusCode;
    } catch (e) {
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
          "tracks_info": jsonDecode(responce.body)
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
          "track_info": jsonDecode(responce.body)
        };
        return trackInfo;
      } else {
        return errorMap;
      }
    } catch (e) {
      return errorMap;
    }
  }

  static Future<int> editTrackInfo(
      Map<String, String> parameters, BuildContext context) async {
    try {
      Utilities.showLoadingScreen(context);
      var request =
          http.MultipartRequest('PATCH', Uri.parse(Utilities.url + "tracks/"));
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

  static Future<int> changePassword(Map<String, String> parameters) async {
    String newPass = parameters["new_password"]!;
    var passbyteOld = utf8.encode(parameters["password"]!);
    var passhashOld = sha256.convert(passbyteOld);
    var passbyteNew = utf8.encode(parameters["new_password"]!);
    var passhashNew = sha256.convert(passbyteNew);
    parameters["password"] = passhashOld.toString();
    parameters["new_password"] = passhashNew.toString();
    try {
      var responce = await http.patch(Uri.parse(Utilities.url + "users/"),
          body: jsonEncode(parameters),
          headers: {
            "Authorization": "Bearer " + Utilities.authToken,
            "Content-Type": "application/json"
          });
      if (responce.statusCode == 200) {
        Utilities.password = newPass;
      }
      return responce.statusCode;
    } catch (e) {
      print(e);
      return 404;
    }
  }
}

class Utilities {
  static init() async {
    currentLanguage = Languages.english;
    showHelpNotification = false;
    preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_keyEmailUser) != null) {
      email = preferences.getString(_keyEmailUser)!;
    }
    if (preferences.getString(_keyPassUser) != null) {
      password = preferences.getString(_keyPassUser)!;
    }
    if (preferences.getBool(_keyAgeConfirm) != null) {
      ageConfirm = preferences.getBool(_keyAgeConfirm)!;
    }
    if (preferences.getInt(_keyVoices) != null) {
      curVoice = Voices.values.elementAt(preferences.getInt(_keyVoices)!);
    }
    if (preferences.getInt(_keyLanguage) != null) {
      currentLanguage = Languages.values[preferences.getInt(_keyLanguage)!];
    }
    if (preferences.getBool(_keyHelpNotification) != null) {
      showHelpNotification = preferences.getBool(_keyHelpNotification)!;
    }
    changeLanguage(currentLanguage);
    if (email != "" && password != "") {
      int statusCodeLogin = await Server.logIn(email, password, null);
      if (statusCodeLogin == 200) {
        authorized = true;
      }
    }
  }

  static helpNotificationViewied() {
    preferences.setBool(_keyHelpNotification, true);
  }

  static showLoadingScreen(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
              child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MColors.mainColor),
            ),
          ));
        });
  }

  static Uri getUri(String uri, Map<String, String> parameters) {
    String finalUri = uri + "?";
    parameters.forEach((key, value) {
      finalUri += key + "=" + value + "&";
    });
    return Uri.parse(finalUri.substring(0, finalUri.length - 1));
  }

  static changeVoice(int iDvoice) {
    preferences.setInt(_keyVoices, iDvoice);
    curVoice = Voices.values.elementAt(iDvoice);
  }

  static ageConfirmed() {
    preferences.setBool(_keyAgeConfirm, true);
    ageConfirm = true;
  }

  static setUser(String email, String password) {
    preferences.setString(_keyEmailUser, email);
    preferences.setString(_keyPassUser, password);
  }

  static logOut() async {
    preferences.setString(_keyEmailUser, "");
    preferences.setString(_keyPassUser, "");
    preferences.setInt(_keyVoices, 6);
    curVoice = Voices.sheHeThey;
    email = "";
    password = "";
    authorized = false;
    authToken = "";
    logout.logOut();
  }

  static const bool isConnectedToServer = true;
  static List<AudioManager> handlers = [];
  static NotifyLogout logout = NotifyLogout();
  static bool authorized = false;
  static bool ageConfirm = false;
  static Voices curVoice = Voices.sheHeThey;
  static int languageId = 0;
  static int voiceId = 6;
  static String authToken = "";
  static late bool showHelpNotification;
  static const String _keyLanguage = "Languages";
  static const String _keyHelpNotification = "HelpNotification";
  static const String _keyVoices = "Voices";
  static const String _keyAgeConfirm = "AgeConfirm";
  static const String _keyEmailUser = "Email";
  static const String _keyPassUser = "Password";
  static late SharedPreferences preferences;
  static late AudioHandler audioHandler;
  static late AudioManager managerForRecord;
  static String url = "https://moans.pagekite.me/";
  static ValueNotifier<int> curPage = ValueNotifier(0);
  static ValueNotifier<Map> curLang = ValueNotifier<Map>(_englishStrings);
  static String email = "test@test";
  static String password = "";
  static late Languages currentLanguage;
  static ValueNotifier<bool> isPlaying = ValueNotifier(false);
  static const Map _englishStrings = {
    "lang": "English",
    "18eText":
        "18 or over and legal with the acknowledgement that you are not offended by audio recordings of any nature? Wonderful! Come on in!",
    "18eQuesText": "How old are you?",
    "18eButText": "I am 18 and over",
    "18eTerAndCondText": "Terms and conditions",
    "login": "Log in",
    "Email": "Email",
    "Password": "Password",
    "LogQues": "Not registred yet?",
    "Signup": "Sign up",
    "Forgotpass": "Forgot pasword?",
    "Click": "Click here",
    "EmailNotCorrect": "Your email is not correct",
    "ShortPass": "Your password is too short",
    "SignUp": "Sign up",
    "CreatePass": "Create a password",
    "SignText1": "By signing up you agree to our\n",
    "SignText2": "Terms of Service ",
    "SignText3": "and",
    "SignText4": " Privacy Policy, ",
    "SignText5": "and confirm that you are at least 18 years old.",
    "HaveAcc": "Already have an account?",
    "Thank": "Thank you!",
    "ConfEmail": "We have sent an e-mail to ",
    "ToConfEmail":
        "To confirm your e-mail, follow the link from the letter.\n\nIf you have not received the email, check your SPAM folder.\n\nIf you have any problems, please write to us by mail: ",
    "OurEmail": "dmitry.deev@bk.ru",
    "Feed": "For You",
    "Record": "Record",
    "Profile": "Profile",
    "Share": "Share",
    "Update": "Update",
    "TapToRecord": "Tap here to start recording",
    "PickLib": "Pick from library",
    "ChangePas": "Change password",
    "Voice": "What voice do you want to hear?",
    "she/her": "she/her",
    "he/him": "he/him",
    "they/them": "they/them",
    "MyRec": "My recodings",
    "StopRec": "Stop recording",
    "Again": "Try again",
    "Save": "Save",
    "SaveTitle": "Title",
    "SaveDesc": "Description",
    "SaveTags": "Tags",
    "SaveVoice": "Voice",
    "SavePost": "Post",
    "Back": "Back",
    "Continue": "Or continue with",
    "OldPass": "Old password",
    "NewPass": "New password",
    "PassMatch": "Passwords don't match",
    "OldPassMatch": "Old password incorrect",
    "Shure": "Are you shure?",
    "Yes": "Yes",
    "No": "No",
    "Edit": "Edit",
    "ToDraft": "To draft",
    "NoTracks": "You don't have any entries yet",
    "EndFeed": "You have listened to all records. Great job!",
    "Refresh": "Refresh",
    "Logout": "Logout",
  };

  static const Map _russianStrings = {
    "lang": "Русский",
    "18eText":
        "Тебе больше восемнадцати лет и ты подтверждаешь, что не будешь оскорблен аудио-записями любого содержания? Замечательно! Заходи!",
    "18eQuesText": "Сколько вам лет?",
    "18eButText": "Мне 18 лет или больше",
    "18eTerAndCondText": "Условия и положения",
    "login": "Вход",
    "Email": "Email",
    "Password": "Пароль",
    "LogQues": "Ещё не зарегестрированы?",
    "Signup": "Регистрация",
    "Forgotpass": "Забыли пароль?",
    "Click": "Нажмите сюда",
    "EmailNotCorrect": "Ваш email введён неверно",
    "ShortPass": "Ваш пароль слишком короткий",
    "SignUp": "Регистрация",
    "CreatePass": "Придумайте пароль",
    "SignText1": "Регистрируясь, вы соглашаетесь с нашими\n",
    "SignText2": "Условиями использования ",
    "SignText3": "и",
    "SignText4": " Политикой конфиденциальности, ",
    "SignText5": "и подтверждаете, что вам не менее 18 лет",
    "HaveAcc": "Уже есть аккаунт?",
    "Thank": "Спасибо!",
    "ConfEmail": "Мы отправили электронное письмо по адресу ",
    "ToConfEmail":
        "Для подтверждения вашего e-mail перейдите по ссылке в письме.\n\nЕсли вы не получили письмо, проверьте папку спам.\n\nЕсли у вас ещё остались вопросы, то напишите нам: ",
    "OurEmail": "dmitry.deev@bk.ru",
    "Feed": "Для вас",
    "Record": "Запись",
    "Profile": "Профиль",
    "Share": "Поделиться",
    "Update": "Обновить",
    "TapToRecord": "Нажмите, чтобы начать запись",
    "PickLib": "Выбрать из библиотеки",
    "ChangePas": "Изменить пароль",
    "Voice": "Какой голос вы хотите слышать?",
    "she/her": "she/her",
    "he/him": "he/him",
    "they/them": "they/them",
    "MyRec": "Мои записи",
    "StopRec": "Остановить запись",
    "Again": "Ещё раз",
    "Save": "Сохранить",
    "SaveTitle": "Название",
    "SaveDesc": "Описание",
    "SaveTags": "Тэги",
    "SaveVoice": "Голос",
    "SavePost": "Опубликовать",
    "Back": "Назад",
    "Continue": "Или продолжите с",
    "OldPass": "Старый пароль",
    "NewPass": "Новый пароль",
    "PassMatch": "Пароли не совпадают",
    "OldPassMatch": "Старый пароль неверный",
    "Shure": "Вы уверены?",
    "Yes": "Да",
    "No": "Нет",
    "Edit": "Изменить",
    "ToDraft": "В черновики",
    "NoTracks": "У вас пока нет записей",
    "EndFeed": "Вы прослушали все записи. Отличная работа!",
    "Refresh": "Обновить",
    "Logout": "Выйти",
  };
  static void changeLanguage(Languages language) {
    switch (language) {
      case Languages.english:
        curLang.value = _englishStrings;
        break;
      case Languages.russian:
        curLang.value = _russianStrings;
        break;
    }
    currentLanguage = language;
    preferences.setInt(_keyLanguage, Languages.values.indexOf(language));
  }
}

class MColors {
  static const Color mainColor = Color(0xff9900a7);
}
