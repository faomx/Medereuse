// lib/models/request_model.dart

class RequestModel {
  final String id;
  final String medicineId;
  final String requesterId; // ID of the user requesting the medicine
  final DateTime requestDate;
  final String status; // e.g., 'pending', 'accepted', 'rejected'

  RequestModel({
    required this.id,
    required this.medicineId,
    required this.requesterId,
    required this.requestDate,
    this.status = 'pending',
  });

  // From JSON
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      medicineId: json['medicineId'],
      requesterId: json['requesterId'],
      requestDate: DateTime.parse(json['requestDate']),
      status: json['status'] ?? 'pending',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'requesterId': requesterId,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
    };
  }
}
