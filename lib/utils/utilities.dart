import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:moans/utils/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MColors {
  static const Color mainColor = Color(0xff9900a7);
}

class Utilities {
  static init() async {
    currentLanguage = Languages.english;
    showHelpNotification = true;
    preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(_keyGoogleSignUp) != null) {
      isGoogleSignUp = preferences.getBool(_keyGoogleSignUp)!;
    }
    if (preferences.getDouble(_keyDeviceSizeMultiply) != null) {
      deviceSizeMultiply = preferences.getDouble(_keyDeviceSizeMultiply)!;
    }
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
    if (isGoogleSignUp) {
      int statusCodeLogin = await Server.googleSignUp(null);
      if (statusCodeLogin == 200) {
        authorized = true;
      }
    }
  }

  static helpNotificationViewied() {
    preferences.setBool(_keyHelpNotification, false);
    showHelpNotification = false;
  }

  static showLoadingScreen(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: const Center(
                  child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MColors.mainColor),
                ),
              )));
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
    preferences.setBool(_keyGoogleSignUp, false);
    curVoice = Voices.sheHeThey;
    if (isGoogleSignUp) {
      await googleSignIn.disconnect();
    }
    email = "";
    password = "";
    authorized = false;
    isGoogleSignUp = false;
    authToken = "";
    logout.logOut();
  }

  static setDeviceSize(double deviceSize) {
    preferences.setDouble(_keyDeviceSizeMultiply, deviceSize);
    deviceSizeMultiply = deviceSize;
  }

  static showToast(String text) {
    Fluttertoast.showToast(msg: text);
  }

  static setGoogleSignUp() {
    preferences.setBool(_keyGoogleSignUp, true);
    isGoogleSignUp = true;
  }

  static setNewPassword(String newPass) {
    preferences.setString(_keyPassUser, newPass);
    password = newPass;
  }

  static bool isGoogleSignUp = false;
  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  static List<AudioManager> handlers = [];
  static NotifyLogout logout = NotifyLogout();
  static bool authorized = false;
  static bool ageConfirm = false;
  static Voices curVoice = Voices.sheHeThey;
  static int languageId = 0;
  static int voiceId = 6;
  static String authToken = "";
  static late bool showHelpNotification;
  static late double deviceSizeMultiply;
  static const String _keyGoogleSignUp = "GoogleSignUp";
  static const String _keyDeviceSizeMultiply = "DeviceSize";
  static const String _keyLanguage = "Languages";
  static const String _keyHelpNotification = "HelpNotification";
  static const String _keyVoices = "Voices";
  static const String _keyAgeConfirm = "AgeConfirm";
  static const String _keyEmailUser = "Email";
  static const String _keyPassUser = "Password";
  static late SharedPreferences preferences;
  static late AudioHandler audioHandler;
  static late AudioManager managerForRecord;
  static const String url = "https://moans2.pagekite.me/";
  static ValueNotifier<int> curPage = ValueNotifier(0);
  static ValueNotifier<Map> curLang = ValueNotifier<Map>(_englishStrings);
  static String email = "";
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
    "ToastChangePass": "Password changed successfully",
    "ToastPostTrack": "Record successfully published",
    "ToastEditTrack": "Record edited successfully",
    "ToastDraftTrack": "Record successfully sent to draft",
    "ServerError": "Server connection error. Please try again later.",
    "Error": "Error",
    "InvalidUser": "Invalid email or password",
    "UserAlreadyExists": "User already exists",
    "AlreadyHaveTitle": "You already have record with this title",
    "TrackName": "Track name",
    "HintFeed": "Swipe up for more",
    "ShareMsg": "Check this track: ",
    "ErrorLinkShare": "Unable to open link",
    "SendEmail": "Send email",
    "ForgotPassText":
        "To recover your password, enter the email associated with your account. We will send an email with instructions.",
    "ForgotPassTitle": "Password recovery",
    "EmailNotConfirm": "Your email has not been verified yet",
    "EmailSendTrue": "The email was successfully sent to your mail"
  };

  static const Map _russianStrings = {
    "lang": "Русский",
    "18eText":
        "Тебе больше восемнадцати лет и ты подтверждаешь, что не будешь оскорблен аудио-записями любого содержания? Замечательно! Заходи!",
    "18eQuesText": "Сколько вам лет?",
    "18eButText": "Мне 18 лет или больше",
    "18eTerAndCondText": "Terms and conditions",
    "login": "Вход",
    "Email": "Email",
    "Password": "Пароль",
    "LogQues": "Ещё не зарегистрированы?",
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
    "ToastChangePass": "Пароль успешно изменён",
    "ToastPostTrack": "Запись успешно опубликована",
    "ToastEditTrack": "Запись успешно отредактирована",
    "ToastDraftTrack": "Запись успешно отправлена в черновики",
    "ServerError": "Ошибка подключения к серверу. Повторите попытку позже.",
    "Error": "Ошибка",
    "InvalidUser": "Неверный email или пароль",
    "UserAlreadyExists": "Пользователь уже существует",
    "AlreadyHaveTitle": "У вас уже есть запись с таким названием",
    "TrackName": "Название",
    "HintFeed": "Смахните, чтобы увидеть больше",
    "ShareMsg": "Послушай это: ",
    "ErrorLinkShare": "Невозможно открыть ссылку",
    "SendEmail": "Отправить письмо",
    "ForgotPassText":
        "Чтобы восстановить пароль, введите почту, привязанную к вашему аккаунту. Мы отправим на неё письмо с инструкцией.",
    "ForgotPassTitle": "Восстановление пароля",
    "EmailNotConfirm": "Ваш email ещё не подтверждён",
    "EmailSendTrue": "Письмо успешно отправлено на вашу почту"
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
