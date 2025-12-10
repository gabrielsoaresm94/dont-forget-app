class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['Id'], name: json['Name']);
  }

  Map<String, dynamic> toJson() {
    return {"Name": name};
  }

  CategoryModel copyWith({String? name}) {
    return CategoryModel(id: id, name: name ?? this.name);
  }
}
