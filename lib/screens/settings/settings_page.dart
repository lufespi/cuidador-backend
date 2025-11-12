import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/index.dart';
import 'account/account_page.dart';
import 'accessibility/accessibility_page.dart';
import 'notifications/notifications_page.dart';
import 'privacy/privacy_page.dart';
import 'theme/theme_page.dart';
import 'language/language_page.dart';
import 'about/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Ajustes
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e subtítulo dentro do card
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/settings.svg',
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ajustes',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Acessibilidade e preferências',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.inputBackground,
                    ),
                    const SizedBox(height: 4),
                    
                    // Itens do menu
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/user-round.svg',
                  title: 'Conta',
                  subtitle: 'Gerencie suas informações pessoais.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/person-standing.svg',
                  title: 'Acessibilidade',
                  subtitle: 'Ajuste o aplicativo para melhor atender suas necessidades.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccessibilityPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/bell-ring.svg',
                  title: 'Notificações e Alertas',
                  subtitle: 'Receba lembretes quando precisar.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/lock-keyhole.svg',
                  title: 'Privacidade e Segurança',
                  subtitle: 'Controle de dados e permissões.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/palette.svg',
                  title: 'Tema e Aparência',
                  subtitle: 'Personalize cores e modo de exibição.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ThemePage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/globe.svg',
                  title: 'Idioma',
                  subtitle: 'Selecione o idioma do aplicativo.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguagePage()),
                    );
                  },
                ),
                    SettingsMenuItem(
                      iconPath: 'assets/icons/settings/info.svg',
                      title: 'Sobre o Aplicativo',
                      subtitle: 'Saiba mais sobre o CuidaDor.',
                      showDivider: false, // Último item não tem divider
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Botão Sair (discreto)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    // TODO: Implementar logout
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(
                          child: Text(
                            'Sair da sua conta?',
                            style: AppTypography.heading1Primary,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            // Divider acima de Sair
                            Container(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // TODO: Implementar ação de logout
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'Sair',
                                  style: AppTypography.heading2Primary.copyWith(
                                    color: AppColors.stateError,
                                  ),
                                ),
                              ),
                            ),
                            // Divider sutil
                            Container(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: AppTypography.heading2Primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColors.stateError.withValues(alpha: 0.7),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sair',
                        style: AppTypography.heading2Primary.copyWith(
                          color: AppColors.stateError.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
