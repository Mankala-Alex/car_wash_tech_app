class NavigationRouteModel {
  final int distanceMeters;
  final String duration;
  final String encodedPolyline;

  NavigationRouteModel({
    required this.distanceMeters,
    required this.duration,
    required this.encodedPolyline,
  });

  factory NavigationRouteModel.fromJson(Map<String, dynamic> json) {
    return NavigationRouteModel(
      distanceMeters: json['distanceMeters'] ?? 0,
      duration: json['duration'] ?? '',
      encodedPolyline: json['encodedPolyline'] ?? '',
    );
  }
}
