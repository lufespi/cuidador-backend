import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/step_indicator.dart';
import 'register_page_step_2.dart';

class RegisterPageStep1 extends StatefulWidget {
  const RegisterPageStep1({super.key});

  @override
  State<RegisterPageStep1> createState() => _RegisterPageStep1State();
}

class _RegisterPageStep1State extends State<RegisterPageStep1> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? _selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione o sexo'),
            backgroundColor: AppColors.stateError,
          ),
        );
        return;
      }
      // Navigate to next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPageStep2(),
        ),
      );
    }
  }

  void _handleLogin() {
    // Navigate back to login
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.buttonPrimary,
              onPrimary: AppColors.textWhite,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _birthdateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/cuidador-horizontal-logo.png',
                  height: 60,
                ),
                const SizedBox(height: 24),
                
                // Welcome text
                Text(
                  'Bem-vindo! Complete seu cadastro para começar',
                  style: AppTypography.heading2Primary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Step indicators
                const StepIndicator(
                  currentStep: 0,
                  totalSteps: 3,
                ),
                const SizedBox(height: 32),
                
                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informações Pessoais',
                            style: AppTypography.heading2Primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // First name field
                      AppTextField(
                        label: 'Primeiro Nome',
                        hint: 'Digite seu primeiro nome',
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu primeiro nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Last name field
                      AppTextField(
                        label: 'Sobrenome',
                        hint: 'Digite seu sobrenome',
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Birthdate field
                      AppTextField(
                        label: 'Data de Nascimento',
                        hint: 'DD/MM/AAAA',
                        controller: _birthdateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          _DateInputFormatter(),
                        ],
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          onPressed: _selectDate,
                        ),
                        onTap: _selectDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua data de nascimento';
                          }
                          if (value.length < 10) {
                            return 'Data inválida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Gender field
                      Text(
                        'Sexo',
                        style: AppTypography.heading2Primary,
                      ),
                      const SizedBox(height: 8),
                      Container(
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
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          hint: Text(
                            'Selecione uma opção',
                            style: AppTypography.textDisabled,
                          ),
                          style: AppTypography.textPrimary,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            constraints: const BoxConstraints(minHeight: 48),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                          items: [
                            DropdownMenuItem(
                              value: 'masculino',
                              child: Text('Masculino', style: AppTypography.textPrimary),
                            ),
                            DropdownMenuItem(
                              value: 'feminino',
                              child: Text('Feminino', style: AppTypography.textPrimary),
                            ),
                            DropdownMenuItem(
                              value: 'outro',
                              child: Text('Outro', style: AppTypography.textPrimary),
                            ),
                            DropdownMenuItem(
                              value: 'prefiro_nao_dizer',
                              child: Text('Prefiro não dizer', style: AppTypography.textPrimary),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone field
                      AppTextField(
                        label: 'Telefone',
                        hint: '(15) 12345-6789',
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          _PhoneInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu telefone';
                          }
                          if (value.length < 15) {
                            return 'Telefone inválido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Continue button
                AppButton(
                  label: 'Continuar',
                  onPressed: _handleContinue,
                ),
                const SizedBox(height: 16),
                
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui conta? ',
                      style: AppTypography.heading2Primary,
                    ),
                    GestureDetector(
                      onTap: _handleLogin,
                      child: Text(
                        'Realize o login',
                        style: AppTypography.textLink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Date formatter for DD/MM/YYYY
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extrai apenas dígitos do novo valor
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 8 dígitos
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }
    
    // Monta a string formatada
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += digitsOnly[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Phone formatter for (XX) XXXXX-XXXX
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extrai apenas dígitos do novo valor
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 11 dígitos
    if (digitsOnly.length > 11) {
      digitsOnly = digitsOnly.substring(0, 11);
    }
    
    // Se não houver dígitos, retorna vazio
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    // Monta a string formatada
    String formatted = '';
    
    // DDD
    if (digitsOnly.isNotEmpty) {
      formatted += '(';
      formatted += digitsOnly.substring(0, digitsOnly.length >= 2 ? 2 : digitsOnly.length);
      if (digitsOnly.length >= 2) {
        formatted += ') ';
      }
    }
    
    // Primeira parte do número
    if (digitsOnly.length > 2) {
      int endIndex = digitsOnly.length >= 7 ? 7 : digitsOnly.length;
      formatted += digitsOnly.substring(2, endIndex);
    }
    
    // Hífen e segunda parte
    if (digitsOnly.length > 7) {
      formatted += '-';
      formatted += digitsOnly.substring(7);
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
