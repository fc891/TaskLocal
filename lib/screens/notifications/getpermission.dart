import 'package:android_intent_plus/android_intent.dart';

// create class to get permission from user
class GetPerimssion {
  static void requestExactAlarmPermission() {
    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    intent.launch();
  }
}
