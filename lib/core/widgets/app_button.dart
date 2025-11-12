import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonKind {
  buttonPrimary,
  buttonSecondary,
  buttonForm,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final bool block;            // ocupar largura total
  final Widget? icon;          // ícone opcional (usado no outline)
  final double height;         // altura padrão do Figma
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.kind = AppButtonKind.buttonPrimary,
    this.block = true,
    this.icon,
    this.height = 52,
    this.padding,
  });

  // Botão "Indicar local da dor" com ícone e estilo outline
  const AppButton.indicarLocal({
    Key? key,
    required VoidCallback? onPressed,
  }) : this(
    key: key,
    label: 'Indicar local da dor',
    onPressed: onPressed,
    kind: AppButtonKind.buttonSecondary,
    block: true,
    icon: const Icon(
      Icons.location_on_outlined,
      size: 20,
      color: AppColors.buttonPrimary,
    ),
    height: 48,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );

  /// Botão "Continuar" com estilo preenchido
  const AppButton.continuar({
    Key? key,
    required VoidCallback? onPressed,
  }) : this(
    key: key,
    label: 'Continuar',
    onPressed: onPressed,
    kind: AppButtonKind.buttonPrimary,
    block: true,
    height: 52,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );

  /// Botão "Criar Conta" com bordas mais arredondadas
  const AppButton.criarConta({
    Key? key,
    required VoidCallback? onPressed,
  }) : this(
    key: key,
    label: 'Criar Conta',
    onPressed: onPressed,
    kind: AppButtonKind.buttonPrimary,
    block: true,
    height: 56,
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
  );

  /// Botão de abas (usado em LoginPage para Entrar/Criar Conta)
  const AppButton.tab({
    Key? key,
    required String label,
    required bool isActive,
    VoidCallback? onPressed,
  }) : this(
    key: key,
    label: label,
    onPressed: onPressed,  // Removida a condição que impedia o clique em tabs inativas
    kind: isActive ? AppButtonKind.buttonPrimary : AppButtonKind.buttonForm,
    block: true,
    height: 40,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );

  @override
  Widget build(BuildContext context) {
    final double radius = switch (kind) {
      AppButtonKind.buttonPrimary   => height / 2,
      AppButtonKind.buttonSecondary => 12,
      AppButtonKind.buttonForm      => 12,
    };

    return _buildButton(radius);
  }

  /// Constrói o botão de acordo com o tipo
  Widget _buildButton(double radius) {
    final buttonContent = _buildContent();

    if (kind == AppButtonKind.buttonSecondary) {
      // Botão outline (Indicar local da dor)
      return SizedBox(
        width: block ? double.infinity : null,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            side: const BorderSide(
              color: AppColors.buttonPrimary,
              width: 2,
            ),
            padding: padding,
          ),
          child: buttonContent,
        ),
      );
    }

    if (kind == AppButtonKind.buttonForm) {
      // Botão secundário/inativo (abas)
      return SizedBox(
        width: block ? double.infinity : null,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
              ),
              alignment: Alignment.center,
              child: buttonContent,
            ),
          ),
        ),
      );
    }

    // Botão preenchido (Continuar, Criar Conta)
    return Container(
      width: block ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.buttonPrimary.withAlpha(64),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: padding,
        ),
        child: buttonContent,
      ),
    );
  }

  /// Constrói o conteúdo do botão (texto + ícone se houver)
  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            label,
            style: kind == AppButtonKind.buttonSecondary
                ? AppTypography.buttonSecondary
                : AppTypography.buttonPrimary,
          ),
        ],
      );
    }

    // Para botão de abas (buttonForm), usa estilo de heading
    if (kind == AppButtonKind.buttonForm) {
      return Text(
        label,
        style: AppTypography.heading2Primary,
      );
    }

    return Text(
      label,
      style: kind == AppButtonKind.buttonSecondary
          ? AppTypography.buttonSecondary
          : AppTypography.buttonPrimary,
    );
  }
}

    