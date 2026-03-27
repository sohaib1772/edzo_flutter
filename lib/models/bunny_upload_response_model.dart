class BunnyUploadResponseModel {
  final String tusEndpoint;
  final String videoId;
  final String libraryId;
  final String authorizationSignature;
  final int authorizationExpire;
  final int? id;

  BunnyUploadResponseModel({
    required this.tusEndpoint,
    required this.videoId,
    required this.libraryId,
    required this.authorizationSignature,
    required this.authorizationExpire,
    this.id,
  });

  factory BunnyUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return BunnyUploadResponseModel(
      tusEndpoint:
          json['tus_endpoint'] ?? 'https://video.bunnycdn.com/tusupload',
      videoId: json['video_id'] ?? '',
      libraryId: json['library_id']?.toString() ?? '',
      authorizationSignature: json['authorization_signature'] ?? '',
      authorizationExpire: json['authorization_expire'] ?? 0,
      id: json['id'] is int
          ? json['id']
          : (json['db_video']?['id'] is int
                ? json['db_video']['id']
                : int.tryParse(json['db_video']?['id']?.toString() ?? '')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tus_endpoint': tusEndpoint,
      'video_id': videoId,
      'library_id': libraryId,
      'authorization_signature': authorizationSignature,
      'authorization_expire': authorizationExpire,
      'id': id,
    };
  }
}
