class DrugModel {
  final String drugId;
  final String brandName;
  final String genericName;
  final String description;
  final String imageUrl;
  final String therapeuticCategory;
  final String type;
  final bool requiresOrdonnance; // ✅ NEW FIELD

  DrugModel({
    required this.drugId,
    required this.brandName,
    required this.genericName,
    required this.description,
    required this.imageUrl,
    required this.therapeuticCategory,
    required this.type,
    required this.requiresOrdonnance, // ✅ include in constructor
  });

  factory DrugModel.fromMap(Map<String, dynamic> map, {required String drugId}) {
    return DrugModel(
      drugId: drugId,
      brandName: map['brandName'] ?? '',
      genericName: map['genericName'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      therapeuticCategory: map['therapeuticCategory'] ?? '',
      type: map['type'] ?? '',
      requiresOrdonnance: map['requiresOrdonnance'] ?? false, // ✅ parse safely
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brandName': brandName,
      'genericName': genericName,
      'description': description,
      'imageUrl': imageUrl,
      'therapeuticCategory': therapeuticCategory,
      'type': type,
      'requiresOrdonnance': requiresOrdonnance, // ✅ include when saving
    };
  }
}
