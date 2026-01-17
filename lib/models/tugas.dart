class Tugas {
  int? id;
  String title;
  String description;
  int isDone;
  String createdAt;

  Tugas({
    this.id,
    required this.title,
    required this.description,
    this.isDone = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt,
    };
  }
}
