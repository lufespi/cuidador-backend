import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import 'app_info_page.dart';
import 'team_page.dart';
import 'terms_page.dart';
import 'feedback_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sobre o Aplicativo',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card com Logo e Versão
              Center(
                child: AppCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(40),
                  borderColor: AppColors.buttonPrimary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // Logo do aplicativo
                    Image.asset(
                      'assets/images/cuidador-main-logo.png',
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    
                    // Versão
                    Text(
                      'Versão 1.0.0',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Informações
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Sobre o Aplicativo
                    _buildAboutField(
                      context: context,
                      label: 'Sobre o Aplicativo',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppInfoPage(),
                          ),
                        );
                      },
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Equipe e Desenvolvimento
                    _buildAboutField(
                      context: context,
                      label: 'Equipe e Desenvolvimento',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeamPage(),
                          ),
                        );
                      },
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Termos e Política de Privacidade
                    _buildAboutField(
                      context: context,
                      label: 'Termos e Política de Privacidade',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsPage(),
                          ),
                        );
                      },
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Feedback
                    _buildAboutField(
                      context: context,
                      label: 'Feedback',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackPage(),
                          ),
                        );
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Copyright
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '© Todos os Direitos Reservados - 2025\nDesenvolvido por Luis Fernando Souza Pinto e Kaue Müller',
                  style: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um campo clicável
  Widget _buildAboutField({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: AppColors.textDisabled,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
