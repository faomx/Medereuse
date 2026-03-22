// lib/models/file_model.dart

class FileModel {
  final String id;
  final String name;
  final String url;
  final String type; // e.g. 'image/png', 'image/jpeg'

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  // From JSON
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: json['type'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
    };
  }
}
