class Quote {
  final int id;
  final String text;
  final String author;
  final String category;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
