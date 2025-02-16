import 'package:app_task/app/presentation/home/home_screen.dart';
import 'package:app_task/app/presentation/screen_launcher/screen_launcher_view.dart';
import 'package:app_task/component/routes_screen.dart';
import 'package:app_task/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: appColor),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
