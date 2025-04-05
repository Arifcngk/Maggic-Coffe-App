import 'package:flutter/material.dart';
import 'package:maggic_coffe/global/theme.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/provider/coffe_provider.dart';
import 'package:maggic_coffe/view/profile/profile_view_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CoffeeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: buildAppTheme(),
      home: const ProfileViewScreen(),
    );
  }
}


// Consumer<AuthProvider>(
//         builder: (context, auth, _) {
//           return auth.isAuthenticated
//                const BottomBarWidget()
//               : const SigninViewScreen();
//         },
//       ),