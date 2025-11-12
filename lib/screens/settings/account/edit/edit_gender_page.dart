import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class EditGenderPage extends StatefulWidget {
  final String currentGender;

  const EditGenderPage({
    super.key,
    required this.currentGender,
  });

  @override
  State<EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {
  late String _selectedGender;
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Outro',
    'Prefiro não informar',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.currentGender;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
    // TODO: Salvar alteração do sexo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sexo atualizado com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context, _selectedGender);
  }

  Widget _buildGenderOption(String gender) {
    final bool isSelected = _selectedGender == gender;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
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
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              gender,
              style: AppTypography.textPrimary.copyWith(
                color: isSelected ? AppColors.buttonPrimary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
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
          'Editar Sexo',
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
                              'Sexo',
                              style: AppTypography.heading2Primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Selecione seu sexo.',
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            Column(
                              children: _genderOptions
                                  .map((gender) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: _buildGenderOption(gender),
                                      ))
                                  .toList(),
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
