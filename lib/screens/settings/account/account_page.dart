import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import 'edit/edit_name_page.dart';
import 'edit/edit_birth_date_page.dart';
import 'edit/edit_gender_page.dart';
import 'edit/edit_phone_page.dart';
import 'edit/edit_email_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Valores iniciais (TODO: substituir por dados reais do backend)
  String _userFirstName = 'João';
  String _userLastName = 'Silva';
  String _userBirthDate = '15/03/1990';
  String _userGender = 'Masculino';
  String _userPhone = '(11) 98765-4321';
  String _userEmail = 'joao.silva@email.com';

  String get _userFullName => '$_userFirstName $_userLastName';

  Future<void> _navigateToEditName() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditNamePage(
          currentFirstName: _userFirstName,
          currentLastName: _userLastName,
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userFirstName = result['firstName'] ?? _userFirstName;
        _userLastName = result['lastName'] ?? _userLastName;
      });
    }
  }

  Future<void> _navigateToEditBirthDate() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthDatePage(currentBirthDate: _userBirthDate),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userBirthDate = result;
      });
    }
  }

  Future<void> _navigateToEditGender() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditGenderPage(currentGender: _userGender),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userGender = result;
      });
    }
  }

  Future<void> _navigateToEditPhone() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPhonePage(currentPhone: _userPhone),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userPhone = result;
      });
    }
  }

  Future<void> _navigateToEditEmail() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmailPage(currentEmail: _userEmail),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userEmail = result;
      });
    }
  }

  void _navigateToEditHealthData(String fieldName) {
    // TODO: Implementar navegação para telas de edição de dados de saúde
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar $fieldName - Em desenvolvimento'),
        backgroundColor: AppColors.buttonPrimary,
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
          'Conta',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Informações Pessoais
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/user-round.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Informações Pessoais',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Nome
                    _buildAccountField(
                      context: context,
                      label: 'Nome',
                      value: _userFullName,
                      onTap: _navigateToEditName,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Data de Nascimento
                    _buildAccountField(
                      context: context,
                      label: 'Data de Nascimento',
                      value: _userBirthDate,
                      onTap: _navigateToEditBirthDate,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Sexo
                    _buildAccountField(
                      context: context,
                      label: 'Sexo',
                      value: _userGender,
                      onTap: _navigateToEditGender,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Telefone
                    _buildAccountField(
                      context: context,
                      label: 'Telefone',
                      value: _userPhone,
                      onTap: _navigateToEditPhone,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo E-mail
                    _buildAccountField(
                      context: context,
                      label: 'E-mail',
                      value: _userEmail,
                      onTap: _navigateToEditEmail,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Dados de Saúde
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/forms/heart-pulse.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dados de Saúde',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Diagnóstico Principal
                    _buildAccountField(
                      context: context,
                      label: 'Diagnóstico Principal',
                      onTap: () => _navigateToEditHealthData('Diagnóstico Principal'),
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Comorbidades
                    _buildAccountField(
                      context: context,
                      label: 'Comorbidades',
                      onTap: () => _navigateToEditHealthData('Comorbidades'),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Opções da Conta
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/settings.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Opções da Conta',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Opção Alterar senha
                    _buildAccountField(
                      context: context,
                      label: 'Alterar senha',
                      onTap: () => _navigateToEditHealthData('Alterar senha'),
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Excluir Conta (com texto em vermelho)
                    _buildAccountField(
                      context: context,
                      label: 'Excluir minha conta',
                      onTap: () => _showDeleteAccountDialog(context),
                      isLast: true,
                      isDestructive: true,
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

  /// Mostra dialog de confirmação para excluir conta
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Excluir sua conta?',
            style: AppTypography.heading1Primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Esta ação é irreversível. Todos os seus dados serão permanentemente excluídos.',
              style: AppTypography.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Divider acima de Excluir
            Container(
              height: 1,
              color: AppColors.inputBackground,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implementar exclusão de conta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Função de exclusão em desenvolvimento'),
                      backgroundColor: AppColors.stateError,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Excluir conta',
                  style: AppTypography.heading2Primary.copyWith(
                    color: AppColors.stateError,
                  ),
                ),
              ),
            ),
            // Divider sutil
            Container(
              height: 1,
              color: AppColors.inputBackground,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Cancelar',
                  style: AppTypography.heading2Primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói um campo de informação pessoal clicável
  Widget _buildAccountField({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    String? value,
    bool isLast = false,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.textPrimary.copyWith(
                      color: isDestructive ? AppColors.stateError : AppColors.textDisabled,
                      fontSize: 11,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: AppTypography.textPrimary,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? AppColors.stateError : AppColors.textDisabled,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
