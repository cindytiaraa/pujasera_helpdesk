class CommentModel {
  final String id;
  final String ticketId;
  final String userId;
  final String userName;
  final String role;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.userName,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  /// JSON -> Object
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      ticketId: json['ticket_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      role: json['role'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'user_id': userId,
      'user_name': userName,
      'role': role,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy Object
  CommentModel copyWith({
    String? id,
    String? ticketId,
    String? userId,
    String? userName,
    String? role,
    String? text,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, ticketId: $ticketId, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.id == id &&
        other.ticketId == ticketId &&
        other.userId == userId &&
        other.userName == userName &&
        other.role == role &&
        other.text == text &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      ticketId,
      userId,
      userName,
      role,
      text,
      createdAt,
    );
  }
}