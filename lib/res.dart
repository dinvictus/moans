import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utilities {
  static init() async {
    curLang = _englishStrings;
    currentLanguage = "English";
    showHelpNotification = false;
    preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_keyLanguage) != null) {
      currentLanguage = preferences.getString(_keyLanguage)!;
    }
    if (preferences.getBool(_keyHelpNotification) != null) {
      showHelpNotification = preferences.getBool(_keyHelpNotification)!;
    }
    changeLanguage(currentLanguage);
  }

  static helpNotificationViewied() {
    preferences.setBool(_keyHelpNotification, true);
  }

  static late bool showHelpNotification;
  static const String _keyLanguage = "Language";
  static const String _keyHelpNotification = "HelpNotification";
  static late SharedPreferences preferences;
  static late AudioHandler audioHandler;
  static late AudioManager managerForRecord;
  static String url = "https://05a2-178-66-32-212.ngrok.io/";
  static ValueNotifier<int> curPage = ValueNotifier(0);
  static late Map curLang;
  static String email = "test@test";
  static late String currentLanguage;
  static List<String> listLanguages = ["English", "Русский"];
  static ValueNotifier<String> forShare = ValueNotifier("Share");
  static String langForSaveTrack = "English";
  static ValueNotifier<int> tagsCountForSave = ValueNotifier(0);
  static ValueNotifier<int> descLength = ValueNotifier(0);
  static ValueNotifier<int> titleLength = ValueNotifier(0);
  static ValueNotifier<bool> isPlaying = ValueNotifier(false);
  static const Map _englishStrings = {
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
    "NewPass": "New password"
  };

  static const Map _russianStrings = {
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
    "NewPass": "Новый пароль"
  };
  static void changeLanguage(String language) {
    switch (language) {
      case "English":
        forShare.value = "Share";
        curLang = _englishStrings;
        break;
      case "Русский":
        forShare.value = "Поделиться";
        curLang = _russianStrings;
        break;
    }
    currentLanguage = language;
    preferences.setString(_keyLanguage, language);
  }
}

class MColors {
  static const Color mainColor = Color(0xff9900a7);
}
