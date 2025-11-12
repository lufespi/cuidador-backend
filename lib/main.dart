import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/auth/index.dart';

void main() => runApp(const CuidaDorApp());

class CuidaDorApp extends StatelessWidget {
  const CuidaDorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaDor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonPrimary),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
