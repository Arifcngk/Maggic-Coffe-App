import 'package:flutter/material.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 21,
                child: Image.asset('assets/images/profile.png'),
              ),
              title: const Text('Name'),
              subtitle: const Text('John Doe'),
            ),
          ],
        ),
      ),
    );
  }
}
