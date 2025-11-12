import 'package:flutter/material.dart';

/// Provider para gerenciar o estado do registro em múltiplas etapas
class RegisterProvider extends ChangeNotifier {
  // Step 1 - Dados Pessoais
  String? firstName;
  String? lastName;
  String? birthDate; // Formato: DD/MM/YYYY (será convertido para YYYY-MM-DD)
  String? phone;
  String? gender;

  // Step 2 - Credenciais
  String? email;
  String? password;

  // Step 3 - Preferências
  bool acceptedTerms = false;
  Map<String, dynamic>? preferences;

  /// Salvar dados do Step 1
  void saveStep1({
    required String firstName,
    required String lastName,
    required String birthDate,
    required String phone,
    required String gender,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.phone = phone;
    this.gender = gender;
    notifyListeners();
  }

  /// Salvar dados do Step 2
  void saveStep2({
    required String email,
    required String password,
  }) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  /// Salvar dados do Step 3
  void saveStep3({
    required bool acceptedTerms,
    Map<String, dynamic>? preferences,
  }) {
    this.acceptedTerms = acceptedTerms;
    this.preferences = preferences;
    notifyListeners();
  }

  /// Converter data de DD/MM/YYYY para YYYY-MM-DD
  String _convertDateFormat(String date) {
    final parts = date.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date;
  }

  /// Converter gênero para formato da API
  String _convertGenderToApi(String gender) {
    final genderMap = {
      'Masculino': 'masculino',
      'Feminino': 'feminino',
      'Outro': 'outro',
      'Prefiro não informar': 'prefiro_nao_dizer',
    };
    return genderMap[gender] ?? 'prefiro_nao_dizer';
  }

  /// Obter dados formatados para a API
  Map<String, dynamic> getRegistrationData() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': _convertDateFormat(birthDate!),
      'phone': phone,
      'gender': _convertGenderToApi(gender!),
    };
  }

  /// Resetar todos os dados
  void reset() {
    firstName = null;
    lastName = null;
    birthDate = null;
    phone = null;
    gender = null;
    email = null;
    password = null;
    acceptedTerms = false;
    preferences = null;
    notifyListeners();
  }

  /// Verificar se todos os dados obrigatórios foram preenchidos
  bool isComplete() {
    return firstName != null &&
        lastName != null &&
        birthDate != null &&
        phone != null &&
        gender != null &&
        email != null &&
        password != null &&
        acceptedTerms;
  }
}
