class PainRecordModel {
  final int? id;
  final int userId;
  final String bodyPart;
  final int intensity;
  final String? description;
  final List<String>? symptoms;
  final DateTime? timestamp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PainRecordModel({
    this.id,
    required this.userId,
    required this.bodyPart,
    required this.intensity,
    this.description,
    this.symptoms,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
  });

  factory PainRecordModel.fromJson(Map<String, dynamic> json) {
    return PainRecordModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      bodyPart: json['body_part'] as String,
      intensity: json['intensity'] as int,
      description: json['description'] as String?,
      symptoms: json['symptoms'] != null
          ? List<String>.from(json['symptoms'] as List)
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user_id': userId,
      'body_part': bodyPart,
      'intensity': intensity,
    };

    if (id != null) data['id'] = id;
    if (description != null) data['description'] = description;
    if (symptoms != null) data['symptoms'] = symptoms;
    if (timestamp != null) data['timestamp'] = timestamp!.toIso8601String();
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }

  PainRecordModel copyWith({
    int? id,
    int? userId,
    String? bodyPart,
    int? intensity,
    String? description,
    List<String>? symptoms,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PainRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bodyPart: bodyPart ?? this.bodyPart,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PainStatisticsModel {
  final double averageIntensity;
  final int minIntensity;
  final int maxIntensity;
  final int totalRecords;
  final Map<String, int>? bodyPartCounts;

  PainStatisticsModel({
    required this.averageIntensity,
    required this.minIntensity,
    required this.maxIntensity,
    required this.totalRecords,
    this.bodyPartCounts,
  });

  factory PainStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PainStatisticsModel(
      averageIntensity: (json['average_intensity'] as num).toDouble(),
      minIntensity: json['min_intensity'] as int,
      maxIntensity: json['max_intensity'] as int,
      totalRecords: json['total_records'] as int,
      bodyPartCounts: json['body_part_counts'] != null
          ? Map<String, int>.from(json['body_part_counts'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_intensity': averageIntensity,
      'min_intensity': minIntensity,
      'max_intensity': maxIntensity,
      'total_records': totalRecords,
      'body_part_counts': bodyPartCounts,
    };
  }
}
