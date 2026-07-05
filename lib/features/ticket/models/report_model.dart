class ReportModel {
  final String id;
  final String? code; // Business Code: R001, R002, ...
  final String ticketId;
  final String resolvedBy;
  final String resolution;
  final String resolutionNote;
  final int durationMinutes;
  final int? customerRating;
  final String? customerFeedback;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    this.code,
    required this.ticketId,
    required this.resolvedBy,
    required this.resolution,
    required this.resolutionNote,
    required this.durationMinutes,
    this.customerRating,
    this.customerFeedback,
    required this.createdAt,
  });

  /// JSON -> Object
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      code: json['code'],
      ticketId: json['ticket_id'] ?? '',
      resolvedBy: json['resolved_by'] ?? '',
      resolution: json['resolution'] ?? '',
      resolutionNote: json['resolution_note'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      customerRating: json['customer_rating'],
      customerFeedback: json['customer_feedback'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (code != null) 'code': code,
      'ticket_id': ticketId,
      'resolved_by': resolvedBy,
      'resolution': resolution,
      'resolution_note': resolutionNote,
      'duration_minutes': durationMinutes,
      'customer_rating': customerRating,
      'customer_feedback': customerFeedback,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy Object
  ReportModel copyWith({
    String? id,
    String? code,
    String? ticketId,
    String? resolvedBy,
    String? resolution,
    String? resolutionNote,
    int? durationMinutes,
    int? customerRating,
    String? customerFeedback,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      code: code ?? this.code,
      ticketId: ticketId ?? this.ticketId,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolution: resolution ?? this.resolution,
      resolutionNote: resolutionNote ?? this.resolutionNote,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      customerRating: customerRating ?? this.customerRating,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ReportModel(id: $id, ticketId: $ticketId, resolvedBy: $resolvedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportModel &&
        other.id == id &&
        other.ticketId == ticketId &&
        other.resolvedBy == resolvedBy &&
        other.resolution == resolution &&
        other.resolutionNote == resolutionNote &&
        other.durationMinutes == durationMinutes &&
        other.customerRating == customerRating &&
        other.customerFeedback == customerFeedback &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      ticketId,
      resolvedBy,
      resolution,
      resolutionNote,
      durationMinutes,
      customerRating,
      customerFeedback,
      createdAt,
    );
  }
}