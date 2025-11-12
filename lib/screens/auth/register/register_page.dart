import 'package:flutter/material.dart';

import 'register_page_step_1.dart';
import 'register_page_step_2.dart';
import 'register_page_step_3.dart';

/// Página principal de registro com navegação entre as 3 etapas
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Desabilita swipe, navegação apenas por botões
      children: const [
        RegisterPageStep1(),
        RegisterPageStep2(),
        RegisterPageStep3(),
      ],
    );
  }
}
