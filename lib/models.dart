

class Recipes {
  final int id;
  final String tit;
  final List<String> engredyan;
  final List<String> enstriksyon;
  final String image;

  Recipes({
    required this.id,
    required this.tit,
    required this.engredyan,
    required this.enstriksyon,
    String? image,
  }) : image = image ?? '';

  factory Recipes.fromJson(Map<String, dynamic> el) {
    return Recipes(
      id: el['id'] ?? 0,
      tit: (el['name'] ?? '').toString(),
      engredyan: (el['ingredients'] != null)
          ? List<String>.from(el['ingredients'].where((e) => e != null).map((e) => e.toString()))
          : <String>[],
      enstriksyon: (el['instructions'] != null)
          ? List<String>.from(el['instructions'].where((e) => e != null).map((e) => e.toString()))
          : <String>[],
      image: (el['image'] ?? '').toString(),
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tit': tit,
      'engredyan': engredyan,
      'enstriksyon': enstriksyon,
      'image': image,
    };
  }
}