class BookingModel {
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

  // For Future (Before / After Images)
  final List<String>? beforeImages;
  final List<String>? afterImages;

  BookingModel({
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
    this.beforeImages,
    this.afterImages,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["id"] ?? "",
      bookingCode: json["booking_code"] ?? "",
      customerId: json["customer_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      vehicle: json["vehicle"] ?? "",
      serviceId: json["service_id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ""),
      washerId: json["washer_id"]?.toString() ?? "",
      washerName: json["washer_name"] ?? "",
      status: json["status"] ?? "",
      amount: json["amount"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      slotId: json["slot_id"] ?? 0,
      beforeImages: json["before_images"] == null
          ? []
          : List<String>.from(json["before_images"]),
      afterImages: json["after_images"] == null
          ? []
          : List<String>.from(json["after_images"]),
    );
  }
}
