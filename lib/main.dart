import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/shared/constants/constants.dart';
import 'package:manage_task_app/shared/style/theme.dart';
import 'package:manage_task_app/views/landing_screen/landing_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'controllers/observer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);
  await OneSignal.shared.setAppId(
    appID,
  );
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getAllTasks()
        ..getAllEmployees(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightTheme,
        home: const LandingScreen(),
      ),
    );
  }
}
