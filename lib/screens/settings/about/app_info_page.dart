import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

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
              
              // Card - Objetivo
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objetivo',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'O Cuidador App foi desenvolvido para auxiliar cuidadores de idosos no acompanhamento diário de suas atividades, saúde e bem-estar. O aplicativo oferece ferramentas para registro de dor, lembretes de medicamentos, exercícios práticos e orientações educacionais.',
                      style: AppTypography.textPrimary,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Funcionalidades
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funcionalidades',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Registro e acompanhamento de dor'),
                    _buildFeatureItem('Lembretes de medicamentos e cuidados'),
                    _buildFeatureItem('Práticas e exercícios guiados'),
                    _buildFeatureItem('Conteúdo educacional'),
                    _buildFeatureItem('Recursos de acessibilidade'),
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

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle,
              color: AppColors.buttonPrimary,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
