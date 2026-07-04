class HistoryModel {
  final String id;
  final String ticketId;
  final String actorId;
  final String actorName;
  final String status;
  final String title;
  final String description;
  final String location;
  final DateTime createdAt;

  const HistoryModel({
    required this.id,
    required this.ticketId,
    required this.actorId,
    required this.actorName,
    required this.status,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
  });

  /// JSON -> Object
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      ticketId: json['ticket_id'] ?? '',
      actorId: json['actor_id'] ?? '',
      actorName: json['actor_name'] ?? '',
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'actor_id': actorId,
      'actor_name': actorName,
      'status': status,
      'title': title,
      'description': description,
      'location': location,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy Object
  HistoryModel copyWith({
    String? id,
    String? ticketId,
    String? actorId,
    String? actorName,
    String? status,
    String? title,
    String? description,
    String? location,
    DateTime? createdAt,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'HistoryModel(id: $id, ticketId: $ticketId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryModel &&
        other.id == id &&
        other.ticketId == ticketId &&
        other.actorId == actorId &&
        other.actorName == actorName &&
        other.status == status &&
        other.title == title &&
        other.description == description &&
        other.location == location &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      ticketId,
      actorId,
      actorName,
      status,
      title,
      description,
      location,
      createdAt,
    );
  }
}