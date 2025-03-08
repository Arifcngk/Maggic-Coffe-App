import 'package:flutter/material.dart';
import 'package:maggic_coffe/global_widget/tabbar_global_widget.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';
import 'package:maggic_coffe/view/home/menu/menu_view_screen.dart';
import 'package:maggic_coffe/view/rewards/reward_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated
              ? const BottomBarWidget()
              : const SigninViewScreen();
        },
      ),
    );
  }
}
