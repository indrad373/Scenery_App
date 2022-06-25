// ignore_for_file: non_constant_identifier_names

class TodayTopicModel {
  final String id;
  final String title;
  final String sub_title;
  final String image;
  final String description;
  final String category;
  final String readTime;
  final String author;
  final String createdDate;

  TodayTopicModel(
      {required this.id,
      required this.title,
      required this.sub_title,
      required this.image,
      required this.description,
      required this.category,
      required this.readTime,
      required this.author,
      required this.createdDate});

  factory TodayTopicModel.fromJson(Map<String, dynamic> json) {
    return TodayTopicModel(
        id: json['id'],
        title: json['title'],
        sub_title: json['sub_title'],
        image: json['image'],
        description: json['description'],
        category: json['category'],
        readTime: json['readTime'],
        author: json['id'],
        createdDate: json['createdDate']);
  }
}
