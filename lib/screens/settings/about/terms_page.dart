import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
          'Termos e Privacidade',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Termos de Uso
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Termos de Uso',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ao utilizar este aplicativo, você concorda com os seguintes termos:',
                      style: AppTypography.textPrimary,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem('1. Finalidade', 
                      'O aplicativo destina-se exclusivamente ao auxílio de cuidadores, não substituindo orientação médica profissional.'),
                    _buildTermItem('2. Responsabilidade', 
                      'As informações registradas são de responsabilidade do usuário. O desenvolvedor não se responsabiliza por decisões tomadas com base nos dados do aplicativo.'),
                    _buildTermItem('3. Uso Adequado', 
                      'O aplicativo deve ser utilizado de forma ética e responsável, respeitando as orientações médicas estabelecidas.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Política de Privacidade
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Política de Privacidade',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem('Coleta de Dados', 
                      'Os dados inseridos no aplicativo são armazenados de forma segura e poderão ser sincronizados com um banco de dados para backup e acesso em múltiplos dispositivos.'),
                    _buildTermItem('Uso dos Dados', 
                      'As informações coletadas são utilizadas exclusivamente para o funcionamento das funcionalidades do aplicativo e para fornecer uma melhor experiência ao usuário.'),
                    _buildTermItem('Compartilhamento', 
                      'Seus dados pessoais não serão compartilhados com terceiros sem o seu consentimento explícito, exceto quando exigido por lei.'),
                    _buildTermItem('Segurança', 
                      'O aplicativo utiliza autenticação por senha para proteger o acesso aos seus dados. Mantenha sua senha segura e não a compartilhe com terceiros.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Contato
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dúvidas ou Sugestões',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Para esclarecimentos sobre os termos de uso ou política de privacidade, utilize a seção de Feedback no menu Sobre.',
                      style: AppTypography.textPrimary,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.heading2Primary,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.textPrimary,
          ),
        ],
      ),
    );
  }
}
