import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/app_button.dart';

class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  @override
  State<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  double _fontSizeLevel = 3; // 0-6, onde 3 é médio
  bool _highContrast = false;
  bool _textToSpeech = false;

  String _getFontSizeLabel() {
    const labels = ['Muito Pequeno', 'Pequeno', 'Pequeno-Médio', 'Médio', 'Médio-Grande', 'Grande', 'Muito Grande'];
    return labels[_fontSizeLevel.toInt()];
  }

  void _handleSave() {
    // TODO: Salvar preferências de acessibilidade
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
          'Acessibilidade',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Preferências de Acessibilidade
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/accessibility/person-standing.svg',
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Preferências de Acessibilidade',
                          style: AppTypography.heading2Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Descrição
                    Text(
                      'Ajuste a interface para melhor atender suas necessidades.',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tamanho da Fonte
                    Text(
                      'Tamanho da Fonte: ${_getFontSizeLabel()}',
                      style: AppTypography.textPrimary.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Preview Box (acima do slider)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.buttonPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Bem vindo ao CuidaDor!\nCriado por Luis Fernando e Kaue Müller',
                          textAlign: TextAlign.center,
                          style: AppTypography.textPrimary.copyWith(
                            fontSize: 6 + (_fontSizeLevel * 2), // Nível 3 (médio) = 6 + (3*2) = 12px (padrão textPrimary)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Slider de tamanho de fonte
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.buttonPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'A',
                            style: AppTypography.textPrimary.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: AppColors.buttonPrimary,
                                inactiveTrackColor: Colors.grey.shade400,
                                thumbColor: AppColors.buttonPrimary,
                                overlayColor: AppColors.buttonPrimary.withValues(alpha: 0.1),
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                showValueIndicator: ShowValueIndicator.never,
                                trackShape: const RoundedRectSliderTrackShape(),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Slider(
                                    value: _fontSizeLevel,
                                    min: 0,
                                    max: 6,
                                    divisions: 6,
                                    onChanged: (value) {
                                      setState(() {
                                        _fontSizeLevel = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(7, (index) {
                                        return Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: index <= _fontSizeLevel 
                                                ? AppColors.buttonPrimary 
                                                : Colors.grey.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'A',
                            style: AppTypography.heading1Primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Alto Contraste toggle
                    Row(
                      children: [
                        Icon(
                          Icons.contrast,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alto Contraste',
                                style: AppTypography.textPrimary.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Melhor visibilidade para textos',
                                style: AppTypography.textDisabled,
                              ),
                            ],
                          ),
                        ),
                        AppToggle(
                          value: _highContrast,
                          onChanged: (value) {
                            setState(() {
                              _highContrast = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Texto-Para-Fala toggle
                    Row(
                      children: [
                        Icon(
                          Icons.volume_up,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Texto-Para-Fala',
                                style: AppTypography.textPrimary.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Leitura de textos em voz alta',
                                style: AppTypography.textDisabled,
                              ),
                            ],
                          ),
                        ),
                        AppToggle(
                          value: _textToSpeech,
                          onChanged: (value) {
                            setState(() {
                              _textToSpeech = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botão Salvar Alterações
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton(
                  label: 'Salvar Alterações',
                  onPressed: _handleSave,
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
