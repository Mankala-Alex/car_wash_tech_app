class Historymodel {
  Historymodel({
    required this.success,
    required this.bookings,
  });

  final bool success;
  final List<HistoryBookingModel> bookings;

  factory Historymodel.fromJson(Map<String, dynamic> json) {
    return Historymodel(
      success: json["success"] ?? false,
      bookings: json["bookings"] == null
          ? []
          : List<HistoryBookingModel>.from(
              json["bookings"]!.map((x) => HistoryBookingModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "bookings": bookings.map((x) => x.toJson()).toList(),
      };
}

class HistoryBookingModel {
  HistoryBookingModel({
    required this.id,
    required this.bookingCode,
    required this.customerId,
    required this.customerName,
    required this.vehicle,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledAt,
    required this.washerId,
    required this.washerName,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.slotId,
    required this.beforeImages,
    required this.afterImages,
  });

  final String id;
  final String bookingCode;
  final String customerId;
  final String customerName;
  final String vehicle;
  final String serviceId;
  final String serviceName;
  final DateTime? scheduledAt;
  final String washerId;
  final String washerName;
  final String status;
  final String amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int slotId;

  /// ✅ NEW
  final List<String> beforeImages;
  final List<String> afterImages;

  factory HistoryBookingModel.fromJson(Map<String, dynamic> json) {
    return HistoryBookingModel(
      id: json["id"] ?? "",
      bookingCode: json["booking_code"] ?? "",
      customerId: json["customer_id"]?.toString() ?? "",
      customerName: json["customer_name"] ?? "",
      vehicle: json["vehicle"] ?? "",
      serviceId: json["service_id"]?.toString() ?? "",
      serviceName: json["service_name"] ?? "",
      scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ""),
      washerId: json["washer_id"] ?? "",
      washerName: json["washer_name"] ?? "",
      status: json["status"] ?? "",
      amount: json["amount"]?.toString() ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      slotId: json["slot_id"] ?? 0,

      /// ✅ IMAGE LISTS (SAFE PARSING)
      beforeImages: json["before_images"] == null
          ? []
          : List<String>.from(json["before_images"]),
      afterImages: json["after_images"] == null
          ? []
          : List<String>.from(json["after_images"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_code": bookingCode,
        "customer_id": customerId,
        "customer_name": customerName,
        "vehicle": vehicle,
        "service_id": serviceId,
        "service_name": serviceName,
        "scheduled_at": scheduledAt?.toIso8601String(),
        "washer_id": washerId,
        "washer_name": washerName,
        "status": status,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "slot_id": slotId,
        "before_images": beforeImages,
        "after_images": afterImages,
      };
}
