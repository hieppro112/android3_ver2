class ThongBao {
  final int? id;
  final String title;
  final String noiDung;

  ThongBao({this.id, required this.title, required this.noiDung});

  factory ThongBao.fromMap(Map<String, dynamic> map) {
    return ThongBao(
      id: map['id'],
      title: map['title'],
      noiDung: map['noiDung'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'noiDung': noiDung};
  }
}
