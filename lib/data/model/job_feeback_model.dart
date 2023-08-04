class JobFeedbackModel {
  late int id;
  late int jobId;
  late String title;
  late String productTitle;
  late String description;
  late String file;
  late String video;
  late int userId;
  late String createdAt;
  late String updatedAt;

  JobFeedbackModel(
      {required this.id,
      required this.jobId,
      required this.title,
      required this.productTitle,
      required this.description,
      required this.file,
      required this.video,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});

  JobFeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'] ?? 0;
    title = json['title'] ?? '';
    productTitle = json['product_title'] ?? '';
    description = json['description'] ?? '';
    file = json['file'] ?? '';
    video = json['video'] ?? '';
    userId = json['user_id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['title'] = this.title;
    data['product_title'] = this.productTitle;
    data['description'] = this.description;
    data['file'] = this.file;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
