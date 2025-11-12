import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class EditBirthDatePage extends StatefulWidget {
  final String currentBirthDate;

  const EditBirthDatePage({
    super.key,
    required this.currentBirthDate,
  });

  @override
  State<EditBirthDatePage> createState() => _EditBirthDatePageState();
}

class _EditBirthDatePageState extends State<EditBirthDatePage> {
  late DateTime _selectedDate;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tentar parsear a data atual, se falhar usa data padrão
    try {
      final parts = widget.currentBirthDate.split('/');
      if (parts.length == 3) {
        _selectedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        _selectedDate = DateTime(2000, 1, 1);
      }
    } catch (e) {
      _selectedDate = DateTime(2000, 1, 1);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.buttonPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirmar Alteração',
                  style: AppTypography.heading1Primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Por segurança, digite sua senha atual para confirmar a alteração.',
                  style: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: 'Senha Atual',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _passwordController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancelar',
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // TODO: Validar senha e salvar alteração
                        if (_passwordController.text.isNotEmpty) {
                          Navigator.of(context).pop();
                          _saveChanges();
                        }
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveChanges() {
    // TODO: Salvar alteração da data de nascimento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data de nascimento atualizada com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context, _formatDate(_selectedDate));
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
          'Editar Data de Nascimento',
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
                      
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data de Nascimento',
                              style: AppTypography.heading2Primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Selecione sua data de nascimento.',
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            InkWell(
                              onTap: _selectDate,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(_selectedDate),
                                      style: AppTypography.textPrimary,
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: AppColors.buttonPrimary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
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
                onPressed: _showPasswordDialog,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
