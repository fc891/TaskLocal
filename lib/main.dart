import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasklocal/screens/notifications/notification_services.dart';
import 'package:tasklocal/screens/rateandreview/review_card.dart';
import 'package:tasklocal/screens/rateandreview/reviews_page.dart';
import 'package:tasklocal/screens/supportpage/supportpage.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:tasklocal/screens/calendar/calendarfront.dart';
// import 'package:tasklocal/screens/notifications/notification_services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//AUTHORIZATION-RELATED IMPORTS
import 'package:tasklocal/Screens/authorization/onboardingpage.dart';

//THEME-RELATED IMPORTS
import 'package:tasklocal/Screens/app_theme/app_themes.dart';
import 'package:tasklocal/Screens/app_theme/appthemecustomization.dart';
import 'package:tasklocal/screens/app_theme/theme_provider.dart';

//MESSAGES-RELATED IMPORTS
import 'package:tasklocal/screens/messages/messages_home.dart';

//CUSTOMER IMPORTS
import 'package:tasklocal/Screens/home_pages/customer_home.dart';
import 'package:tasklocal/Screens/authorization/customerregistration.dart';
import 'package:tasklocal/Screens/profiles/customerprofilepage.dart';
import 'package:tasklocal/Screens/profiles/customertaskinfopage.dart';
import 'package:tasklocal/screens/profiles/completedtask.dart';

//TASKER IMPORTS
import 'package:tasklocal/Screens/home_pages/tasker_home.dart';
import 'package:tasklocal/Screens/authorization/tasker_registration.dart';
import 'package:tasklocal/Screens/profiles/taskerprofilepage.dart';
import 'package:tasklocal/Screens/profiles/taskertaskinfopage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();
  
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkProvider);
    return MaterialApp(
      title: 'TaskLocal',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context, isDarkMode),
      // Initial page that is shown when program is loaded up
      // >FOR TESTING: change initialRoute to an option from routing options below
      initialRoute: '/home',
      // Routing between pages
      routes: {
        //'/': (context) => LoadScreen(), //loading screen (WIP)
        '/home': (context) => OnboardingPage(),
        '/customerregistration': (context) =>
            CustomerRegistration(onTap: () {}),
        '/taskerregistration': (context) => TaskerRegistration(onTap: () {}),
        '/customerhomepage': (context) => CustomerHomePage(),
        '/taskerhomepage': (context) => TaskerHomePage(),
        '/messageshome': (context) => MessagesHome(),
      },
    );
  }
}