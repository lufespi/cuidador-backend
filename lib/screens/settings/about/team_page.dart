import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

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
          'Equipe e Desenvolvimento',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Desenvolvedores
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desenvolvedores',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 16),
                    
                    // Desenvolvedor 1 - Luis Fernando
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Círculo para foto
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.inputBackground,
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Informações
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Luis Fernando Souza Pinto',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Responsável pela gestão do projeto, design e desenvolvimento front-end da aplicação utilizando Flutter.',
                                style: AppTypography.textPrimary,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Desenvolvedor 2 - Kaue Muller
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Círculo para foto
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.inputBackground,
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Informações
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kaue Müller',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Responsável pelo desenvolvimento back-end, integração de APIs e gerenciamento de banco de dados da aplicação.',
                                style: AppTypography.textPrimary,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Projeto
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o Projeto',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Esse projeto foi desenvolvido como trabalho final da disciplina de Desenvolvimento de Aplicativos Móveis, ministrado pelo professor Gilson Augusto Helfer, com o objetivo de apoiar o autocuidado e o manejo da dor em pessoas com osteoartrite. Oferecendo ferramentas para monitoramento da dor, práticas terapêuticas guiadas e conteúdo educativo baseado em evidências científicas.\n\nDesenvolvido com Flutter, o aplicativo oferece uma experiência nativa tanto para Android quanto iOS, garantindo desempenho e usabilidade em diferentes plataformas.',
                      style: AppTypography.textPrimary,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Tecnologias Utilizadas
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tecnologias Utilizadas',
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 16),
                    
                    // Grid de tecnologias
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildTechItem('Trello'),
                        _buildTechItem('Figma'),
                        _buildTechItem('Flutter'),
                        _buildTechItem('Python'),
                        _buildTechItem('Github'),
                        _buildTechItem('PythonAnywhere'),
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
    );
  }

  Widget _buildTechItem(String name) {
    return Column(
      children: [
        // Círculo para logo da tecnologia
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.inputBackground,
            border: Border.all(
              color: AppColors.buttonPrimary,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.code,
            size: 30,
            color: AppColors.textDisabled,
          ),
        ),
        const SizedBox(height: 8),
        
        // Nome da tecnologia
        Text(
          name,
          style: AppTypography.textPrimary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
