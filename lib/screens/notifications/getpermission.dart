import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// create class to get permission from user
void checkAndRequestPermission() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  // check on version 
  if (androidInfo.version.sdkInt >= 31) { 
    final intent = AndroidIntent(
      action: 'android.settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  } else {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
}