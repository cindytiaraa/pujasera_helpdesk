class TicketModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String userId;
  final String? assignedToId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String location;
  final String currentStage;

  const TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.userId,
    this.assignedToId,
    required this.createdAt,
    this.updatedAt,
    required this.location,
    required this.currentStage,
  });

  /// JSON -> Object
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      userId: json['user_id'] ?? '',
      assignedToId: json['assigned_to_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      location: json['location'] ?? '',
      currentStage: json['current_stage'] ?? '',
    );
  }

  /// Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'user_id': userId,
      'assigned_to_id': assignedToId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'location': location,
      'current_stage': currentStage,
    };
  }

  /// Copy Object
  TicketModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? userId,
    String? assignedToId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? location,
    String? currentStage,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      assignedToId: assignedToId ?? this.assignedToId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      currentStage: currentStage ?? this.currentStage,
    );
  }

  @override
  String toString() {
    return 'TicketModel(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TicketModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.priority == priority &&
        other.status == status &&
        other.userId == userId &&
        other.assignedToId == assignedToId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.location == location &&
        other.currentStage == currentStage;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      category,
      priority,
      status,
      userId,
      assignedToId,
      createdAt,
      updatedAt,
      location,
      currentStage,
    );
  }
}