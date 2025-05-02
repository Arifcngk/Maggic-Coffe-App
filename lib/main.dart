import 'package:flutter/material.dart';
import 'package:maggic_coffe/global/theme.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/provider/branch_provider.dart';
import 'package:maggic_coffe/provider/coffe_provider.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';
import 'package:maggic_coffe/view/home/caffe_map/caffe_map_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
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
      title: 'Maggic Coffee',
      theme: buildAppTheme(),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _authStatusFuture;

  @override
  void initState() {
    super.initState();
    // checkAuthStatus'u doğrudan başlat
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authStatusFuture = authProvider.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hata: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        _authStatusFuture = authProvider.checkAuthStatus();
                      });
                    },
                    child: const Text('Yeniden Dene'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          // Oturum açık, BottomBarWidget'a yönlendir
          return const CoffeMapViewScreen();
        }

        // Oturum kapalı, SigninViewScreen'e yönlendir
        return const SigninViewScreen();
      },
    );
  }
}
