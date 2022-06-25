class CarouselModel {
  final String id;
  final String title;
  final String description;
  final String province;
  final String city;
  final String district;
  final String latitude;
  final String longitude;
  final String image;
  final String readTime;
  final String author;
  final String createdDate;

  CarouselModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.province,
      required this.city,
      required this.district,
      required this.latitude,
      required this.longitude,
      required this.image,
      required this.readTime,
      required this.author,
      required this.createdDate});

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        province: json['province'],
        city: json['city'],
        district: json['district'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        image: json['image'],
        readTime: json['readTime'],
        author: json['id'],
        createdDate: json['createdDate']);
  }
}
