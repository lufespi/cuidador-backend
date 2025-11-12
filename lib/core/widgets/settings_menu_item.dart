import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SettingsMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Row(
              children: [
                // Ícone
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.heading2Primary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
                // Seta (chevron)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textDisabled,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        // Divider
        if (showDivider)
          Container(
            height: 1,
            color: AppColors.inputBackground,
          ),
      ],
    );
  }
}
