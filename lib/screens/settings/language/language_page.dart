import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'pt';

  void _selectLanguage(String languageCode) {
    if (languageCode == 'es') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Español - Não está disponível no momento.'),
          backgroundColor: AppColors.stateError,
        ),
      );
      return;
    }
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  void _applyLanguage() {
    // TODO: Implementar mudança de idioma
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedLanguage == 'pt'
              ? 'Idioma Português (Brasil) aplicado'
              : 'English (United States) language applied',
        ),
        backgroundColor: AppColors.buttonPrimary,
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
          'Idioma',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Card único com tudo
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título e descrição
                          Text(
                            'Seleção de Idioma',
                            style: AppTypography.heading1Primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Você pode alterar o idioma de sua preferência',
                            style: AppTypography.textPrimary.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Português
                          _buildLanguageOption(
                            code: 'pt',
                            flag: 'BR',
                            language: 'Português',
                            country: 'Brasil',
                            isSelected: _selectedLanguage == 'pt',
                            isEnabled: true,
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                          ),
                          
                          // Espanhol (desabilitado)
                          _buildLanguageOption(
                            code: 'es',
                            flag: 'ES',
                            language: 'Español',
                            country: 'Spanish',
                            isSelected: _selectedLanguage == 'es',
                            isEnabled: false,
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                          ),
                          
                          // Inglês
                          _buildLanguageOption(
                            code: 'en',
                            flag: 'US',
                            language: 'English',
                            country: 'United States',
                            isSelected: _selectedLanguage == 'en',
                            isEnabled: true,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Aviso
                          Row(
                            children: [
                              const Icon(
                                Icons.language,
                                color: AppColors.textDisabled,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Alguns textos podem não estar totalmente traduzidos. Estamos trabalhando para adicionar suporte completo a todos os idiomas.',
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                  ),
                                ),
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
            
            // Botão aplicar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'Aplicar Idioma',
                onPressed: _applyLanguage,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String code,
    required String flag,
    required String language,
    required String country,
    required bool isSelected,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: () => _selectLanguage(code),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEnabled
                      ? (isSelected ? AppColors.buttonPrimary : AppColors.textDisabled)
                      : AppColors.textDisabled.withAlpha(128),
                  width: 2,
                ),
                color: isSelected && isEnabled
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
              ),
              child: isSelected && isEnabled
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Flag (código do país)
            Container(
              width: 48,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  flag,
                  style: AppTypography.heading2Primary.copyWith(
                    color: isEnabled ? AppColors.textPrimary : AppColors.textDisabled,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Nome do idioma e país
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: AppTypography.heading2Primary.copyWith(
                      color: isEnabled ? AppColors.textPrimary : AppColors.textDisabled,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    country,
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
