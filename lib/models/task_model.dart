class TaskModel {
  final int id;
  final String description;
  final DateTime expiredAt;
  final int categoryId;

  TaskModel({
    required this.id,
    required this.description,
    required this.expiredAt,
    required this.categoryId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['Id'],
      description: json['Description'],
      expiredAt: DateTime.parse(json['ExpiredAt']),
      categoryId: json['CategoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Description": description,
      "ExpiredAt": expiredAt.toIso8601String(),
      "CategoryId": categoryId,
    };
  }

  TaskModel copyWith({
    String? description,
    DateTime? expiredAt,
    int? categoryId,
  }) {
    return TaskModel(
      id: id,
      description: description ?? this.description,
      expiredAt: expiredAt ?? this.expiredAt,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
