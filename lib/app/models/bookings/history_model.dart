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
              json["bookings"].map((x) => HistoryBookingModel.fromJson(x)),
            ),
    );
  }
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
    required this.images,
    required this.videos,
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

  final List<BookingImage> images;
  final List<BookingVideo> videos;

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
      images: json["images"] == null
          ? []
          : List<BookingImage>.from(
              json["images"].map((x) => BookingImage.fromJson(x)),
            ),
      videos: json["videos"] == null
          ? []
          : List<BookingVideo>.from(
              json["videos"].map((x) => BookingVideo.fromJson(x)),
            ),
    );
  }

  // 🔥 CLEAN FILTERED LISTS (USE THESE IN UI)

  List<String> get beforeImages =>
      images.where((i) => i.type == "BEFORE").map((i) => i.url).toList();

  List<String> get afterImages =>
      images.where((i) => i.type == "AFTER").map((i) => i.url).toList();

  List<String> get beforeVideos =>
      videos.where((v) => v.type == "BEFORE").map((v) => v.url).toList();

  List<String> get afterVideos =>
      videos.where((v) => v.type == "AFTER").map((v) => v.url).toList();
}

class BookingImage {
  final String url;
  final String type;

  BookingImage({required this.url, required this.type});

  factory BookingImage.fromJson(Map<String, dynamic> json) {
    return BookingImage(
      url: json["image_url"],
      type: json["image_type"],
    );
  }
}

class BookingVideo {
  final String url;
  final String type;

  BookingVideo({required this.url, required this.type});

  factory BookingVideo.fromJson(Map<String, dynamic> json) {
    return BookingVideo(
      url: json["video_url"],
      type: json["video_type"],
    );
  }
}
