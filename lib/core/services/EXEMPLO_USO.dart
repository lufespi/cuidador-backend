/// EXEMPLO DE USO DOS SERVIÇOS DA API
/// 
/// Este arquivo mostra como usar os serviços criados para integração com o backend Flask

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/pain_service.dart';
import '../services/api_service.dart';

// ============================================
// 1. AUTENTICAÇÃO
// ============================================

class ExemploAuth extends StatelessWidget {
  final AuthService _authService = AuthService();

  ExemploAuth({super.key});

  /// Exemplo: Fazer Login
  Future<void> exemploLogin() async {
    try {
      final response = await _authService.login(
        email: 'usuario@example.com',
        password: 'senha123',
      );
      
      print('Login bem-sucedido!');
      print('Token: ${response.token}');
      print('Usuário: ${response.user['first_name']}');
      
      // O token é automaticamente salvo e usado nas próximas requisições
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
      // Tratar erro específico da API
    } catch (e) {
      print('Erro desconhecido: $e');
    }
  }

  /// Exemplo: Fazer Registro
  Future<void> exemploRegistro() async {
    try {
      final response = await _authService.register(
        email: 'novousuario@example.com',
        password: 'senha123',
        firstName: 'João',
        lastName: 'Silva',
        birthDate: '1990-01-15', // Formato: YYYY-MM-DD
        phone: '+5511999999999',
        gender: 'masculino', // masculino, feminino, outro, prefiro_nao_dizer
      );
      
      print('Registro bem-sucedido!');
      print('Token: ${response.token}');
      
      // Usuário já está logado após registro
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Verificar se está autenticado
  Future<void> exemploCheckAuth() async {
    final isAuth = await _authService.checkAuth();
    
    if (isAuth) {
      print('Usuário autenticado!');
      print('Nome: ${_authService.currentUser?.fullName}');
    } else {
      print('Usuário não autenticado');
    }
  }

  /// Exemplo: Fazer Logout
  Future<void> exemploLogout() async {
    await _authService.logout();
    print('Logout realizado!');
  }

  /// Exemplo: Atualizar Perfil
  Future<void> exemploAtualizarPerfil() async {
    try {
      final user = await _authService.updateProfile(
        firstName: 'João Pedro',
        phone: '+5511888888888',
      );
      
      print('Perfil atualizado!');
      print('Novo nome: ${user.fullName}');
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Exemplo apenas
  }
}

// ============================================
// 2. GERENCIAMENTO DE DOR
// ============================================

class ExemploPain extends StatelessWidget {
  final PainService _painService = PainService();

  ExemploPain({super.key});

  /// Exemplo: Criar Registro de Dor
  Future<void> exemploCriarRegistro() async {
    try {
      final record = await _painService.createPainRecord(
        bodyPart: 'joelho_direito',
        intensity: 7, // 1-10
        description: 'Dor ao subir escadas',
        symptoms: ['inchaço', 'rigidez', 'vermelhidão'],
        timestamp: DateTime.now(),
      );
      
      print('Registro criado!');
      print('ID: ${record.id}');
      print('Parte do corpo: ${record.bodyPart}');
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Listar Registros de Dor
  Future<void> exemploListarRegistros() async {
    try {
      // Listar todos
      final records = await _painService.getPainRecords();
      print('Total de registros: ${records.length}');
      
      // Listar com filtro de data
      final recordsFiltered = await _painService.getPainRecords(
        startDate: '2025-01-01',
        endDate: '2025-12-31',
      );
      print('Registros de 2025: ${recordsFiltered.length}');
      
      for (var record in records) {
        print('${record.bodyPart}: ${record.intensity}/10');
      }
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Buscar Registro Específico
  Future<void> exemploBuscarRegistro(int id) async {
    try {
      final record = await _painService.getPainRecordById(id);
      print('Registro #${record.id}');
      print('Intensidade: ${record.intensity}/10');
      print('Descrição: ${record.description}');
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Atualizar Registro
  Future<void> exemploAtualizarRegistro(int id) async {
    try {
      final record = await _painService.updatePainRecord(
        id: id,
        intensity: 5,
        description: 'Dor melhorou com medicação',
      );
      
      print('Registro atualizado!');
      print('Nova intensidade: ${record.intensity}/10');
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Deletar Registro
  Future<void> exemploDeletarRegistro(int id) async {
    try {
      await _painService.deletePainRecord(id);
      print('Registro deletado!');
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  /// Exemplo: Buscar Estatísticas
  Future<void> exemploEstatisticas() async {
    try {
      final stats = await _painService.getPainStatistics(
        startDate: '2025-01-01',
        endDate: '2025-12-31',
      );
      
      print('Estatísticas de 2025:');
      print('Média de intensidade: ${stats.averageIntensity.toStringAsFixed(1)}');
      print('Mínimo: ${stats.minIntensity}');
      print('Máximo: ${stats.maxIntensity}');
      print('Total de registros: ${stats.totalRecords}');
      
      if (stats.bodyPartCounts != null) {
        print('Por parte do corpo:');
        stats.bodyPartCounts!.forEach((part, count) {
          print('  $part: $count registros');
        });
      }
    } on ApiException catch (e) {
      print('Erro: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Exemplo apenas
  }
}

// ============================================
// 3. USO EM TELAS REAIS
// ============================================

class ExemploTelaLogin extends StatefulWidget {
  const ExemploTelaLogin({super.key});

  @override
  State<ExemploTelaLogin> createState() => _ExemploTelaLoginState();
}

class _ExemploTelaLoginState extends State<ExemploTelaLogin> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        // Navegar para home
        Navigator.pushReplacementNamed(context, '/home');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao fazer login. Verifique sua conexão.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Entrar'),
                  ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 4. CONFIGURAÇÃO NO MAIN.DART
// ============================================

/// No seu main.dart, adicione:
/// 
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Verificar se usuário está autenticado
///   final authService = AuthService();
///   final isAuth = await authService.checkAuth();
///   
///   runApp(MyApp(isAuthenticated: isAuth));
/// }
///
/// class MyApp extends StatelessWidget {
///   final bool isAuthenticated;
///   
///   const MyApp({super.key, required this.isAuthenticated});
///   
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: isAuthenticated ? const HomePage() : const LoginPage(),
///     );
///   }
/// }
