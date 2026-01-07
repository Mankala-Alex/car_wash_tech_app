class BookingImageResponse {
  final bool success;
  final List<BookingImageModel> images;

  BookingImageResponse({
    required this.success,
    required this.images,
  });

  factory BookingImageResponse.fromJson(Map<String, dynamic> json) {
    return BookingImageResponse(
      success: json['success'] ?? false,
      images: json['images'] == null
          ? []
          : List<BookingImageModel>.from(
              json['images'].map((x) => BookingImageModel.fromJson(x)),
            ),
    );
  }
}

class BookingImageModel {
  final String id;
  final String bookingId;
  final String imageType;
  final String imageUrl;
  final DateTime? createdAt;

  BookingImageModel({
    required this.id,
    required this.bookingId,
    required this.imageType,
    required this.imageUrl,
    required this.createdAt,
  });

  factory BookingImageModel.fromJson(Map<String, dynamic> json) {
    return BookingImageModel(
      id: json['id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      imageType: json['image_type'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}
