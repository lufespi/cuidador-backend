import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedType = 'Sugestão';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar envio de feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback enviado com sucesso!'),
          backgroundColor: AppColors.buttonPrimary,
        ),
      );
      Navigator.pop(context);
    }
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
          'Feedback',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                
                // Card - Informações
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sua opinião é importante!',
                        style: AppTypography.heading1Primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Compartilhe suas sugestões, reporte problemas ou envie elogios. Seu feedback nos ajuda a melhorar o aplicativo.',
                        style: AppTypography.textPrimary,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card - Formulário
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de Feedback
                      Text(
                        'Tipo de Feedback',
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
                          value: _selectedType,
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
                          style: AppTypography.textPrimary,
                          items: ['Sugestão', 'Problema', 'Elogio', 'Outro']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Nome
                      AppTextField(
                        label: 'Nome (opcional)',
                        hint: 'Seu nome',
                        controller: _nameController,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // E-mail
                      AppTextField(
                        label: 'E-mail (opcional)',
                        hint: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!value.contains('@')) {
                              return 'E-mail inválido';
                            }
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Mensagem
                      AppTextField(
                        label: 'Mensagem *',
                        hint: 'Descreva seu feedback aqui...',
                        controller: _messageController,
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, descreva seu feedback';
                          }
                          if (value.trim().length < 10) {
                            return 'A mensagem deve ter pelo menos 10 caracteres';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão Enviar
                      AppButton(
                        label: 'Enviar Feedback',
                        onPressed: _submitFeedback,
                        height: 48,
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
    );
  }
}
