class Completedwashmodel {
  Completedwashmodel({
    required this.success,
    required this.booking,
  });

  final bool success;
  final CompletedBooking? booking;

  factory Completedwashmodel.fromJson(Map<String, dynamic> json) {
    return Completedwashmodel(
      success: json["success"] ?? false,
      booking: json["booking"] == null
          ? null
          : CompletedBooking.fromJson(json["booking"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "booking": booking?.toJson(),
      };
}

class CompletedBooking {
  CompletedBooking({
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
  });

  final String id;
  final String bookingCode;
  final int customerId;
  final String customerName;
  final String vehicle;
  final int serviceId;
  final String serviceName;
  final DateTime? scheduledAt;
  final String washerId;
  final String washerName;
  final String status;
  final String amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int slotId;

  factory CompletedBooking.fromJson(Map<String, dynamic> json) {
    return CompletedBooking(
      id: json["id"] ?? "",
      bookingCode: json["booking_code"] ?? "",
      customerId: json["customer_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      vehicle: json["vehicle"] ?? "",
      serviceId: json["service_id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ""),
      washerId: json["washer_id"] ?? "",
      washerName: json["washer_name"] ?? "",
      status: json["status"] ?? "",
      amount: json["amount"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      slotId: json["slot_id"] ?? 0,
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
      };
}
