# Integração Flutter + Backend API

## 📱 Configuração do App Flutter

### 1. Atualizar API Constants

No arquivo `lib/core/constants/api_constants.dart`, atualize a base URL:

```dart
class ApiConstants {
  // Base URL - Atualizar após deploy
  // Desenvolvimento local
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  // Produção (PythonAnywhere)
  // static const String baseUrl = 'https://seuusuario.pythonanywhere.com/api/v1';
  
  // ... resto do código
}
```

---

## 🔄 Modelos já criados

Os modelos Flutter já estão alinhados com o backend:

### ✅ UserModel
- `id`, `email`, `first_name`, `last_name`
- `birth_date`, `phone`, `gender`
- `created_at`, `updated_at`

### ✅ PainRecordModel
- `id`, `user_id`, `body_part`, `intensity`
- `description`, `symptoms`, `timestamp`
- `created_at`, `updated_at`

### ✅ AuthResponseModel
- `token`, `user`

---

## 🔧 Ajustes Necessários no Flutter

### 1. Criar modelo de Preferências

Crie o arquivo `lib/core/models/user_preferences_model.dart`:

```dart
class UserPreferencesModel {
  final int id;
  final int userId;
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final String? notificationTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferencesModel({
    required this.id,
    required this.userId,
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    this.notificationTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      language: json['language'] as String,
      theme: json['theme'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool,
      notificationTime: json['notification_time'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'language': language,
      'theme': theme,
      'notifications_enabled': notificationsEnabled,
      'notification_time': notificationTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
```

### 2. Adicionar endpoint de preferências

No `lib/core/constants/api_constants.dart`:

```dart
// User endpoints
static const String userProfile = '/user/profile';
static const String userPreferences = '/user/preferences'; // ✅ Já existe
```

### 3. Criar serviço de preferências

Crie `lib/core/services/preferences_service.dart`:

```dart
import '../constants/api_constants.dart';
import '../models/user_preferences_model.dart';
import 'api_service.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  final ApiService _apiService = ApiService();

  /// Obter preferências do usuário
  Future<UserPreferencesModel> getPreferences() async {
    try {
      final response = await _apiService.get(ApiConstants.userPreferences);
      return UserPreferencesModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualizar preferências do usuário
  Future<UserPreferencesModel> updatePreferences({
    String? language,
    String? theme,
    bool? notificationsEnabled,
    String? notificationTime,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      
      if (language != null) body['language'] = language;
      if (theme != null) body['theme'] = theme;
      if (notificationsEnabled != null) {
        body['notifications_enabled'] = notificationsEnabled;
      }
      if (notificationTime != null) {
        body['notification_time'] = notificationTime;
      }

      final response = await _apiService.put(
        ApiConstants.userPreferences,
        body: body,
      );

      return UserPreferencesModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## 📊 Adicionar Estatísticas de Dor

### 1. Criar modelo de estatísticas

Crie `lib/core/models/pain_statistics_model.dart`:

```dart
class PainStatisticsModel {
  final StatisticsPeriod period;
  final int totalRecords;
  final double averageIntensity;
  final List<BodyPartCount> mostAffectedParts;
  final IntensityDistribution intensityDistribution;
  final List<SymptomCount> commonSymptoms;

  PainStatisticsModel({
    required this.period,
    required this.totalRecords,
    required this.averageIntensity,
    required this.mostAffectedParts,
    required this.intensityDistribution,
    required this.commonSymptoms,
  });

  factory PainStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PainStatisticsModel(
      period: StatisticsPeriod.fromJson(json['period']),
      totalRecords: json['total_records'] as int,
      averageIntensity: (json['average_intensity'] as num).toDouble(),
      mostAffectedParts: (json['most_affected_parts'] as List)
          .map((e) => BodyPartCount.fromJson(e))
          .toList(),
      intensityDistribution: IntensityDistribution.fromJson(
        json['intensity_distribution']
      ),
      commonSymptoms: (json['common_symptoms'] as List)
          .map((e) => SymptomCount.fromJson(e))
          .toList(),
    );
  }
}

class StatisticsPeriod {
  final DateTime startDate;
  final DateTime endDate;

  StatisticsPeriod({required this.startDate, required this.endDate});

  factory StatisticsPeriod.fromJson(Map<String, dynamic> json) {
    return StatisticsPeriod(
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}

class BodyPartCount {
  final String bodyPart;
  final int count;

  BodyPartCount({required this.bodyPart, required this.count});

  factory BodyPartCount.fromJson(Map<String, dynamic> json) {
    return BodyPartCount(
      bodyPart: json['body_part'] as String,
      count: json['count'] as int,
    );
  }
}

class IntensityDistribution {
  final int low; // 1-3
  final int medium; // 4-6
  final int high; // 7-10

  IntensityDistribution({
    required this.low,
    required this.medium,
    required this.high,
  });

  factory IntensityDistribution.fromJson(Map<String, dynamic> json) {
    return IntensityDistribution(
      low: json['1-3'] as int,
      medium: json['4-6'] as int,
      high: json['7-10'] as int,
    );
  }

  int get total => low + medium + high;
}

class SymptomCount {
  final String symptom;
  final int count;

  SymptomCount({required this.symptom, required this.count});

  factory SymptomCount.fromJson(Map<String, dynamic> json) {
    return SymptomCount(
      symptom: json['symptom'] as String,
      count: json['count'] as int,
    );
  }
}
```

### 2. Adicionar método no PainService

No arquivo `lib/core/services/pain_service.dart`, adicione:

```dart
import '../models/pain_statistics_model.dart';

// ... resto do código

/// Obter estatísticas de dor
Future<PainStatisticsModel> getStatistics({
  DateTime? startDate,
  DateTime? endDate,
}) async {
  try {
    final Map<String, String> queryParams = {};
    
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.painStatistics}'
    ).replace(queryParameters: queryParams);

    final response = await _apiService.get(uri.toString());
    
    return PainStatisticsModel.fromJson(response);
  } catch (e) {
    rethrow;
  }
}
```

---

## 🔐 Tratamento de Erros

### Adicionar tratamento no ApiService

No `lib/core/services/api_service.dart`, melhore o tratamento de erros:

```dart
// No método _handleResponse
dynamic _handleResponse(http.Response response) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    if (response.body.isEmpty) return {};
    return json.decode(response.body);
  } else {
    final error = json.decode(response.body);
    final errorMessage = error['error'] ?? 'Unknown error';
    final detailMessage = error['message'] ?? '';
    
    switch (response.statusCode) {
      case 400:
        throw Exception('Bad Request: $errorMessage - $detailMessage');
      case 401:
        throw Exception('Unauthorized: $errorMessage');
      case 403:
        throw Exception('Forbidden: $errorMessage');
      case 404:
        throw Exception('Not Found: $errorMessage');
      case 409:
        throw Exception('Conflict: $errorMessage');
      case 422:
        throw Exception('Validation Error: $errorMessage');
      case 500:
        throw Exception('Server Error: $errorMessage');
      default:
        throw Exception('Error ${response.statusCode}: $errorMessage');
    }
  }
}
```

---

## 🧪 Testar Integração

### 1. Teste de Registro

```dart
// Exemplo de uso
final authService = AuthService();

try {
  final response = await authService.register(
    email: 'teste@exemplo.com',
    password: 'senha123',
    firstName: 'João',
    lastName: 'Silva',
    birthDate: '1990-01-15',
    phone: '+5511999999999',
    gender: 'male',
  );
  
  print('Token: ${response.token}');
  print('User: ${response.user.fullName}');
} catch (e) {
  print('Erro: $e');
}
```

### 2. Teste de Login

```dart
try {
  final response = await authService.login(
    email: 'teste@exemplo.com',
    password: 'senha123',
  );
  
  print('Login successful!');
} catch (e) {
  print('Erro no login: $e');
}
```

### 3. Teste de Registro de Dor

```dart
final painService = PainService();

try {
  final record = await painService.createPainRecord(
    bodyPart: 'left_knee',
    intensity: 7,
    description: 'Dor ao subir escadas',
    symptoms: ['swelling', 'stiffness'],
  );
  
  print('Registro criado: ${record.id}');
} catch (e) {
  print('Erro: $e');
}
```

---

## 🎨 UI para Estatísticas

### Criar página de estatísticas

Crie `lib/screens/statistics/statistics_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/models/pain_statistics_model.dart';
import '../../core/services/pain_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final PainService _painService = PainService();
  bool _isLoading = true;
  PainStatisticsModel? _statistics;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stats = await _painService.getStatistics(
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );

      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erro: $_error'))
              : _buildStatistics(),
    );
  }

  Widget _buildStatistics() {
    if (_statistics == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildMostAffectedParts(),
          const SizedBox(height: 16),
          _buildIntensityDistribution(),
          const SizedBox(height: 16),
          _buildCommonSymptoms(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo (últimos 30 dias)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  _statistics!.totalRecords.toString(),
                ),
                _buildStatItem(
                  'Média',
                  _statistics!.averageIntensity.toStringAsFixed(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildMostAffectedParts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partes mais afetadas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._statistics!.mostAffectedParts.map((part) {
              return ListTile(
                title: Text(part.bodyPart),
                trailing: Text('${part.count}x'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityDistribution() {
    final dist = _statistics!.intensityDistribution;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição de intensidade',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildDistributionBar('Leve (1-3)', dist.low, Colors.green),
            _buildDistributionBar('Moderada (4-6)', dist.medium, Colors.orange),
            _buildDistributionBar('Intensa (7-10)', dist.high, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBar(String label, int count, Color color) {
    final total = _statistics!.intensityDistribution.total;
    final percentage = total > 0 ? (count / total * 100) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count (${percentage.toStringAsFixed(0)}%)'),
        ],
      ),
    );
  }

  Widget _buildCommonSymptoms() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sintomas mais comuns',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._statistics!.commonSymptoms.map((symptom) {
              return ListTile(
                title: Text(symptom.symptom),
                trailing: Text('${symptom.count}x'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
```

---

## 📝 Checklist de Integração

- [ ] Base URL atualizada em `api_constants.dart`
- [ ] Modelo `UserPreferencesModel` criado
- [ ] Modelo `PainStatisticsModel` criado
- [ ] `PreferencesService` criado
- [ ] Método `getStatistics()` adicionado ao `PainService`
- [ ] Tratamento de erros melhorado
- [ ] Página de estatísticas criada
- [ ] Testes de registro e login realizados
- [ ] Testes de CRUD de dor realizados
- [ ] Testes de estatísticas realizados

---

## 🔄 Fluxo Completo do App

1. **Registro** → `AuthService.register()` → Salva token
2. **Login** → `AuthService.login()` → Salva token
3. **Home** → Carregar dados do usuário
4. **Registrar Dor** → `PainService.createPainRecord()`
5. **Listar Dores** → `PainService.getPainRecords()`
6. **Estatísticas** → `PainService.getStatistics()`
7. **Configurações** → `PreferencesService.updatePreferences()`

---

## 🎯 Próximos Passos

1. Implementar refresh token
2. Adicionar cache local (sqflite)
3. Implementar modo offline
4. Adicionar sincronização automática
5. Implementar notificações push
