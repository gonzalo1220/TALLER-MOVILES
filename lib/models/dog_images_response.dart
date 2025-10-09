class DogImagesResponse {
  final String status;
  final List<String> images;

  DogImagesResponse({required this.status, required this.images});

  factory DogImagesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['message'] ?? [];
    return DogImagesResponse(
      status: json['status'] ?? 'unknown',
      images: List<String>.from(list.map((e) => e.toString())),
    );
  }
}
