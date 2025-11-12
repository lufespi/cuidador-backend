import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import 'indicar_local_page.dart';

class DorPage extends StatefulWidget {
  const DorPage({super.key});

  @override
  State<DorPage> createState() => _DorPageState();
}

class _DorPageState extends State<DorPage> {
  double _nivelDor = 5.0;
  final TextEditingController _anotacaoController = TextEditingController();
  String _periodoHistorico = '30'; // dias

  @override
  void dispose() {
    _anotacaoController.dispose();
    super.dispose();
  }

  String _getDescricaoDor() {
    if (_nivelDor == 0) return 'Sem Dor';
    if (_nivelDor >= 1 && _nivelDor <= 2) return 'Dor Mínima';
    if (_nivelDor >= 3 && _nivelDor <= 4) return 'Dor Leve';
    if (_nivelDor >= 5 && _nivelDor <= 6) return 'Dor Moderada';
    if (_nivelDor >= 7 && _nivelDor <= 8) return 'Dor Intensa';
    return 'Dor Insuportável'; // 9-10
  }

  String _getSubtituloDor() {
    if (_nivelDor == 0) return 'Você está completamente confortável, sem nenhum desconforto';
    if (_nivelDor >= 1 && _nivelDor <= 2) return 'Dor muito leve que você consegue ignorar.\n\nExemplo: Pequena coceira, leve desconforto ao sentar em posição errada.';
    if (_nivelDor >= 3 && _nivelDor <= 4) return 'Dor perceptível mas não impede suas atividades.\n\nExemplo: Dor de cabeça leve, pequena dor muscular após exercício.\n\nVocê consegue trabalhar e se concentrar normalmente';
    if (_nivelDor >= 5 && _nivelDor <= 6) return 'Dor que interfere nas atividades mas você ainda consegue realizá-las.\n\nExemplo: Dor de dente chata, torção de tornozelo, cólica menstrual moderada,\n\nVocê pode precisar de analgésico simples,\nDificulta concentração em tarefas complexas.';
    if (_nivelDor >= 7 && _nivelDor <= 8) return 'Dor que domina seus sentidos e limita significativamente suas atividades.\n\nExemplo: Enxaqueca forte, cólica renal, fratura óssea.\n\nVocê não consegue ignorar a dor,\nDificuldade para dormir ou realizar atividades básicas,\nPrecisa de medicação mais forte.';
    return 'A pior dor imaginável, você não consegue fazer nada além de lidar com ela.\n\nExemplo: Apendicite aguda, trabalho de parto em transição, queimaduras graves.\n\nPode causar choque, náuseas, vômitos.\nRequer atendimento médico imediato. \n\nMuitas pessoas nunca experimentaram esse nível de dor.'; // 9-10
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Card - Como você está se sentindo hoje
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pain/stethoscope.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.buttonPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Como você está se sentindo hoje?',
                        style: AppTypography.textPrimary.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Registre seu nível de dor',
                    style: AppTypography.textDisabled.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  // Nível de Dor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nível de Dor',
                        style: AppTypography.textPrimary.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_nivelDor.toInt()}',
                            style: AppTypography.textPrimary.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.buttonPrimary,
                            ),
                          ),
                          Text(
                            '/10',
                            style: AppTypography.textDisabled.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.buttonPrimary,
                      inactiveTrackColor: AppColors.inputBackground,
                      thumbColor: AppColors.buttonPrimary,
                      overlayColor: AppColors.buttonPrimary.withValues(alpha: 0.2),
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      tickMarkShape: const RoundSliderTickMarkShape(
                        tickMarkRadius: 0,
                      ),
                    ),
                    child: Slider(
                      value: _nivelDor,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _nivelDor = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição da dor
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDescricaoDor(),
                          style: AppTypography.textPrimary.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtituloDor(),
                          style: AppTypography.textDisabled.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão indicar local da dor
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IndicarLocalPage(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/pain/locate-fixed.svg', 
                        width: 18, 
                        height: 18,
                        colorFilter: ColorFilter.mode(AppColors.buttonPrimary, BlendMode.srcIn),
                      ),
                      label: Text(
                        'Indicar local da dor',
                        style: AppTypography.textPrimary.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.buttonPrimary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de anotação
                  Text(
                    'Adicionar uma anotação',
                    style: AppTypography.textPrimary.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _anotacaoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ex.: Dor após a caminhada, degrau a mais...',
                      hintStyle: AppTypography.textDisabled.copyWith(
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.inputBackground,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.inputBackground,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.buttonPrimary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão Salvar Registro
                  AppButton(
                    label: 'Salvar Registro',
                    onPressed: () {
                      // Lógica para salvar registro
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registro salvo com sucesso!'),
                          backgroundColor: AppColors.stateSuccess,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Card - Histórico últimos 30 dias
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/pain/activity.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.buttonPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Histórico',
                            style: AppTypography.textPrimary.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // Dropdown de período
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.buttonPrimary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _periodoHistorico,
                          underline: const SizedBox(),
                          isDense: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.buttonPrimary,
                          ),
                          style: AppTypography.textPrimary.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonPrimary,
                          ),
                          items: const [
                            DropdownMenuItem(value: '7', child: Text('7 dias')),
                            DropdownMenuItem(value: '14', child: Text('14 dias')),
                            DropdownMenuItem(value: '30', child: Text('30 dias')),
                            DropdownMenuItem(value: '60', child: Text('60 dias')),
                            DropdownMenuItem(value: '90', child: Text('90 dias')),
                            DropdownMenuItem(value: 'custom', child: Text('Personalizado')),
                          ],
                          onChanged: (value) {
                            if (value == 'custom') {
                              // TODO: Implementar seletor de data personalizado
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Seletor de período personalizado em breve'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              setState(() {
                                _periodoHistorico = value!;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Visualize o padrão da sua dor',
                    style: AppTypography.textDisabled.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  // Placeholder para gráfico
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.buttonPrimary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart_outlined,
                            size: 48,
                            color: AppColors.buttonPrimary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gráfico será exibido aqui',
                            style: AppTypography.textDisabled.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card - Histórico Recente
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pain/calendar.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.buttonPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Histórico Recente',
                        style: AppTypography.textPrimary.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Com base em seus registros anteriores',
                    style: AppTypography.textDisabled.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  // Lista de registros recentes
                  _buildRegistroRecente(
                    nivel: 7,
                    data: '26 de out de 11:13',
                    descricao: 'Dor após exercício',
                    cor: AppColors.stateError,
                  ),
                  const SizedBox(height: 12),
                  _buildRegistroRecente(
                    nivel: 6,
                    data: '23 de out de 14:25',
                    descricao: 'Rigidez matinal',
                    cor: AppColors.stateWarning,
                  ),
                  const SizedBox(height: 12),
                  _buildRegistroRecente(
                    nivel: 5,
                    data: '20 de out de 16:32',
                    descricao: 'Dor moderada após caminhada',
                    cor: AppColors.stateWarning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Espaço para bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistroRecente({
    required int nivel,
    required String data,
    required String descricao,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonPrimary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Número do nível
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$nivel',
                style: AppTypography.textPrimary.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.buttonPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: AppTypography.textDisabled.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: AppTypography.textPrimary.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
