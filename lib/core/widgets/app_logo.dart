import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppLogo extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final double iconSize;
  final MainAxisAlignment mainAxisAlignment;
  final String? imagePath; // caminho para PNG ou asset
  final bool showDefaultIcon; // mostrar ícone padrão (coração)

  const AppLogo({
    super.key,
    this.title = 'CuidaDor',
    this.subtitle = 'Gerencie sua saúde osteoarticular',
    this.subtitleStyle,
    this.iconSize = 72,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.imagePath,
    this.showDefaultIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        // Logo - Imagem PNG ou ícone padrão
        if (imagePath != null)
          Image.asset(
            imagePath!,
            filterQuality: FilterQuality.high,
          )
        else if (showDefaultIcon)
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              borderRadius: BorderRadius.circular(iconSize / 4),
            ),
            child: Center(
              child: Icon(
                Icons.favorite,
                size: iconSize * 0.6,
                color: AppColors.textWhite,
              ),
            ),
          ),
        const SizedBox(height: 16),
        if (title != null)
          Text(
            title!,
            style: AppTypography.heading1Primary.copyWith(
              color: AppColors.buttonPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: subtitleStyle ?? AppTypography.textPrimary,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
