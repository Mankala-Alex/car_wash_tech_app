class Pendingbookingsmodel {
  Pendingbookingsmodel({
    required this.success,
    required this.bookings,
  });

  final bool success;
  final List<Booking> bookings;

  factory Pendingbookingsmodel.fromJson(Map<String, dynamic> json) {
    return Pendingbookingsmodel(
      success: json["success"] ?? false,
      bookings: json["bookings"] == null
          ? []
          : List<Booking>.from(
              json["bookings"]!.map((x) => Booking.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "bookings": bookings.map((x) => x?.toJson()).toList(),
      };
}

class Booking {
  Booking({
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
  final dynamic washerId;
  final dynamic washerName;
  final String status;
  final String amount;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final int slotId;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json["id"] ?? "",
      bookingCode: json["booking_code"] ?? "",
      customerId: json["customer_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      vehicle: json["vehicle"] ?? "",
      serviceId: json["service_id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ""),
      washerId: json["washer_id"],
      washerName: json["washer_name"],
      status: json["status"] ?? "",
      amount: json["amount"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: json["updated_at"],
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
        "updated_at": updatedAt,
        "slot_id": slotId,
      };
}
