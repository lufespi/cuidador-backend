import 'package:flutter/material.dart';

// Classe responsável pela definição da paleta de cores da aplicação
class AppColors {
  // === Botões e ações principais ===
  static const Color buttonPrimary = Color(0xFF28BDBD);       // botão principal, cor da marca
  static const Color buttonPrimaryVariant = Color(0xFF07DFD5); // variação de destaque/gradiente
  static const Color buttonSecondary = Color(0xFF3D3D3D);      // botão alternativo (voltar, cancelar)
  static const Color buttonSurface = Color(0xFFFBFEFE);        // botão branco / superfície leve
  static const Color buttonText = Color(0xFFFFFFFF);           // texto sobre botões coloridos

  // === Fundo e superfícies ===
  static const Color background = Color(0xFFFBFCFC);           // fundo geral da aplicação
  static const Color surface = Color(0xFFFFFFFF);              // cartões e áreas brancas
  static const Color surfaceVariant = Color(0xFFEAFBFA);       // superfície alternativa (verde suave)

  // === Inputs e campos de formulário ===
  static const Color inputBackground = Color(0xFFDDE3E3);      // fundo dos campos de entrada

  // === Textos ===
  static const Color textPrimary = Color(0xFF3D3D3D);          // texto principal
  static const Color textSecondary = Color(0xFF28BDBD);        // texto de destaque / link
  static const Color textWhite = Color(0xFFFFFFFF);            // texto branco

  static const Color textDisabled = Color(0xFF787878);         // texto desabilitado / placeholder

  // === Bordas e divisores ===
  static const Color border = Color(0xFF28BDBD);               // bordas e divisores

  // === Estados e feedback ===
  static const Color stateSuccess = Color(0xFF1FA97A);         // sucesso / confirmação
  static const Color stateWarning = Color(0xFFF2A700);         // alerta / aviso
  static const Color stateError = Color(0xFFE55757);           // erro / falha
}

// Define nomes semânticos (pelo uso e contexto, não pela cor real), mantém consistência visual e facilita manutenção e futuros temas

class AppSemantic {
  // Identidade visual / marca
  static const Color brand = AppColors.buttonPrimary;
  static const Color brandVariant = AppColors.buttonPrimaryVariant;

  // Botões
  static const Color buttonPrimary = AppColors.buttonPrimary;
  static const Color buttonPrimaryVariant = AppColors.buttonPrimaryVariant;
  static const Color buttonSecondary = AppColors.buttonSecondary;
  static const Color buttonSurface = AppColors.buttonSurface;
  static const Color buttonText = AppColors.buttonText;

  // Fundo e superfícies
  static const Color background = AppColors.background;
  static const Color surface = AppColors.surface;
  static const Color surfaceVariant = AppColors.surfaceVariant;

    // === Inputs e campos de formulário ===
  static const Color inputBackground = AppColors.inputBackground;

  // Textos
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textDisabled = AppColors.textDisabled;
  static const Color textWhite = AppColors.textWhite;

  // Bordas e divisores
  static const Color border = AppColors.border;
  static const Color divider = AppColors.border;

  // Estados de feedback
  static const Color stateSuccess = AppColors.stateSuccess;
  static const Color stateWarning = AppColors.stateWarning;
  static const Color stateError = AppColors.stateError;
}
