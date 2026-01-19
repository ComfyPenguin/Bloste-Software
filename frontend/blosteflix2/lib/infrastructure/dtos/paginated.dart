class Paginated<T> {
  final List<T> content; // Aqui se guardan los videos y las categorias
  final int page;
  final int size;
  final int totalPages;
  final bool last;

  Paginated({
    required this.content,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.last,
  });

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Paginated(
      content: (json['content'] as List)
          .map((e) => fromJsonT(e))
          .toList(),
      page: json['number'],
      size: json['size'],
      totalPages: json['totalPages'],
      last: json['last'],
    );
  }
}