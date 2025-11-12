import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  String _selectedTheme = 'light'; // 'light' ou 'dark'

  void _saveTheme() {
    // TODO: Implementar lógica de salvamento do tema
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedTheme == 'light' 
              ? 'Modo Claro ativado' 
              : 'Modo Escuro ativado',
        ),
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
          'Tema e Aparência',
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
                    children: [
                      const SizedBox(height: 24),
                      
                      // Card - Modo de Exibição
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.palette_outlined,
                                  color: AppColors.textPrimary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Modo de Exibição',
                                  style: AppTypography.heading1Primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Escolha entre o modo claro ou escuro para melhor conforto visual',
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Opção Modo Claro
                            _buildThemeOption(
                              value: 'light',
                              icon: Icons.light_mode,
                              title: 'Modo Claro',
                              description: '',
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Opção Modo Escuro
                            _buildThemeOption(
                              value: 'dark',
                              icon: Icons.dark_mode,
                              title: 'Modo Escuro',
                              description: '',
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
                onPressed: _saveTheme,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedTheme == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.buttonPrimary
                      : AppColors.textDisabled,
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Texto
            Text(
              title,
              style: AppTypography.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
