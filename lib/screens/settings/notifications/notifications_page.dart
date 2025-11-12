import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/app_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Notificações gerais
  bool _notificationsEnabled = true;
  
  // Lembretes personalizados
  bool _remindersEnabled = true;
  bool _exerciciosEnabled = true;
  bool _respiracaoEnabled = true;
  bool _alongamentoEnabled = true;
  bool _relaxamentoEnabled = true;
  
  // Horário e frequência
  bool _scheduleEnabled = true;
  final TextEditingController _hourController = TextEditingController(text: '09');
  final TextEditingController _minuteController = TextEditingController(text: '00');
  String _frequency = 'diariamente';
  
  // Dias da semana para frequência personalizada
  final Map<String, bool> _selectedDays = {
    'Segunda-feira': false,
    'Terça-feira': false,
    'Quarta-feira': false,
    'Quinta-feira': false,
    'Sexta-feira': false,
    'Sábado': false,
    'Domingo': false,
  };

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alterações salvas com sucesso!'),
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
          'Notificações e Alertas',
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
                    
                    // Mini Card - Ativar/Desativar Notificações
                    AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ativar Notificações',
                            style: AppTypography.heading2Primary,
                          ),
                          AppToggle(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Cards condicionais
                    if (_notificationsEnabled) ...[
                      const SizedBox(height: 16),
                      
                      // Card 1 - Lembretes Personalizados
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.notifications_outlined,
                                        color: AppColors.textPrimary,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Lembretes Personalizados',
                                          style: AppTypography.heading1Primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppToggle(
                                  value: _remindersEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _remindersEnabled = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Escolha quais atividades você deseja ser lembrado',
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Exercícios
                            Opacity(
                              opacity: _remindersEnabled ? 1.0 : 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Exercícios',
                                    style: AppTypography.textPrimary,
                                  ),
                                  IgnorePointer(
                                    ignoring: !_remindersEnabled,
                                    child: AppToggle(
                                      value: _exerciciosEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _exerciciosEnabled = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Respiração
                            Opacity(
                              opacity: _remindersEnabled ? 1.0 : 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Respiração',
                                    style: AppTypography.textPrimary,
                                  ),
                                  IgnorePointer(
                                    ignoring: !_remindersEnabled,
                                    child: AppToggle(
                                      value: _respiracaoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _respiracaoEnabled = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Alongamento
                            Opacity(
                              opacity: _remindersEnabled ? 1.0 : 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Alongamento',
                                    style: AppTypography.textPrimary,
                                  ),
                                  IgnorePointer(
                                    ignoring: !_remindersEnabled,
                                    child: AppToggle(
                                      value: _alongamentoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _alongamentoEnabled = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Relaxamento
                            Opacity(
                              opacity: _remindersEnabled ? 1.0 : 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Relaxamento',
                                    style: AppTypography.textPrimary,
                                  ),
                                  IgnorePointer(
                                    ignoring: !_remindersEnabled,
                                    child: AppToggle(
                                      value: _relaxamentoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _relaxamentoEnabled = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Card 2 - Horário e Frequência
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: AppColors.textPrimary,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Horário e Frequência',
                                          style: AppTypography.heading1Primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppToggle(
                                  value: _scheduleEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _scheduleEnabled = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Horário preferido
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: Text(
                                'Horário preferido',
                                style: AppTypography.heading2Primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: IgnorePointer(
                                ignoring: !_scheduleEnabled,
                                child: Row(
                                  children: [
                                    // Input de hora
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: _hourController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          maxLength: 2,
                                          style: AppTypography.textPrimary,
                                          decoration: InputDecoration(
                                            hintText: 'HH',
                                            hintStyle: AppTypography.textPrimary.copyWith(
                                              color: AppColors.textDisabled,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            counterText: '',
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: AppColors.buttonPrimary,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            // Remove caracteres não numéricos
                                            String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                                            
                                            // Valida e limita a 23
                                            if (cleaned.isNotEmpty) {
                                              int? hour = int.tryParse(cleaned);
                                              if (hour != null && hour > 23) {
                                                cleaned = '23';
                                                _hourController.value = TextEditingValue(
                                                  text: cleaned,
                                                  selection: TextSelection.collapsed(offset: cleaned.length),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    
                                    // Separador
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDisabled,
                                        ),
                                      ),
                                    ),
                                    
                                    // Input de minuto
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: _minuteController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          maxLength: 2,
                                          style: AppTypography.textPrimary,
                                          decoration: InputDecoration(
                                            hintText: 'MM',
                                            hintStyle: AppTypography.textPrimary.copyWith(
                                              color: AppColors.textDisabled,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            counterText: '',
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: AppColors.buttonPrimary,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            // Remove caracteres não numéricos
                                            String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                                            
                                            // Valida e limita a 59
                                            if (cleaned.isNotEmpty) {
                                              int? minute = int.tryParse(cleaned);
                                              if (minute != null && minute > 59) {
                                                cleaned = '59';
                                                _minuteController.value = TextEditingValue(
                                                  text: cleaned,
                                                  selection: TextSelection.collapsed(offset: cleaned.length),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Frequência
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: IgnorePointer(
                                ignoring: !_scheduleEnabled,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Frequência',
                                      style: AppTypography.heading2Primary,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildFrequencyOption('diariamente', 'Diariamente'),
                                    const SizedBox(height: 8),
                                    _buildFrequencyOption('dias_uteis', 'Dias úteis'),
                                    const SizedBox(height: 8),
                                    _buildFrequencyOption('personalizado', 'Personalizado'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                  ],
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

  void _showWeekdaysDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final days = _selectedDays.keys.toList();
            
            return AlertDialog(
              title: Text(
                'Selecionar Dias',
                style: AppTypography.heading1Primary,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Organizar em 2 colunas
                    for (int i = 0; i < days.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            // Primeira coluna
                            Expanded(
                              child: _buildDayButton(
                                days[i],
                                setDialogState,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Segunda coluna (se existir)
                            Expanded(
                              child: i + 1 < days.length
                                  ? _buildDayButton(
                                      days[i + 1],
                                      setDialogState,
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Atualiza o estado principal
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Confirmar',
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.buttonPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDayButton(String day, StateSetter setDialogState) {
    final isSelected = _selectedDays[day]!;
    
    return InkWell(
      onTap: () {
        setDialogState(() {
          _selectedDays[day] = !_selectedDays[day]!;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.buttonPrimary
              : AppColors.buttonPrimary.withAlpha(51), // 20% de opacidade (verde claro)
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            day,
            style: AppTypography.textPrimary.copyWith(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyOption(String value, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _frequency = value;
          
          // Reseta os dias selecionados se mudar para outra opção
          if (value != 'personalizado') {
            _selectedDays.updateAll((key, val) => false);
          }
        });
        
        // Abre o popup se for personalizado
        if (value == 'personalizado') {
          _showWeekdaysDialog();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _frequency == value
                      ? AppColors.buttonPrimary
                      : AppColors.textDisabled,
                  width: 2,
                ),
                color: _frequency == value
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
              ),
              child: _frequency == value
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
            Text(
              label,
              style: AppTypography.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
