import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/app_button.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _dataUsageConsent = false;
  bool _shareAnonymousData = false;
  
  // Preferências de e-mail
  bool _emailNotificationsEnabled = false;

  void _viewPrivacyPolicy() {
    // TODO: Navegar para página de política de privacidade
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrindo Política de Privacidade...'),
        backgroundColor: AppColors.buttonPrimary,
      ),
    );
  }

  void _saveChanges() {
    // TODO: Salvar preferências de privacidade
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferências salvas com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context);
  }

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
          'Privacidade e Segurança',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                
                // Card 1 - Coleta de Dados
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.storage,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Coleta de Dados',
                            style: AppTypography.heading1Primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gerencie como deseja compartilhar seus dados de uso da aplicação de acordo com a Lei Geral de Proteção de Dados',
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Toggle 1 - Compartilhar minhas estatísticas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Compartilhar minhas estatísticas',
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Seus dados são protegidos e utilizados apenas para os propósitos descritos na política de privacidade.',
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppToggle(
                            value: _dataUsageConsent,
                            onChanged: (value) {
                              setState(() {
                                _dataUsageConsent = value;
                                if (value) {
                                  _shareAnonymousData = false; // Desabilita o outro
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Toggle 2 - Compartilhar somente dados de diagnóstico
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Compartilhar somente dados de diagnóstico',
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Serão coletados apenas dados do aplicativo para fins de melhoria do aplicativo.',
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppToggle(
                            value: _shareAnonymousData,
                            onChanged: (value) {
                              setState(() {
                                _shareAnonymousData = value;
                                if (value) {
                                  _dataUsageConsent = false; // Desabilita o outro
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Botão Ver Política de Privacidade
                      InkWell(
                        onTap: _viewPrivacyPolicy,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.open_in_new,
                                color: AppColors.buttonPrimary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ver Política de Privacidade',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.buttonPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card 2 - Preferências de E-mail
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Preferências de E-mail',
                            style: AppTypography.heading1Primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gerencie se deseja receber notificações por e-mail',
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Toggle único para ativar/desativar notificações por e-mail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Receber notificações por e-mail',
                              style: AppTypography.textPrimary.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppToggle(
                            value: _emailNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _emailNotificationsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'Salvar Alterações',
                onPressed: _saveChanges,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
