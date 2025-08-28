// lib/models/ebook_models.dart

class Ebook {
  final String title;
  final String subtitle;
  final String imagePath;
  final String? pdfPath; // Path ke file PDF (opsional)
  final String? description; // Deskripsi e-book (opsional)
  final DateTime? publishedDate; // Tanggal terbit (opsional)
  final String? author; // Penulis (opsional)
  final int? pages; // Jumlah halaman (opsional)

  const Ebook({
    required this.title,
    this.subtitle = '',
    required this.imagePath,
    this.pdfPath,
    this.description,
    this.publishedDate,
    this.author,
    this.pages,
  });

  // Membuat instance Ebook dari Map (berguna untuk parsing JSON)
  factory Ebook.fromMap(Map<String, dynamic> map) {
    return Ebook(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      imagePath: map['imagePath'] ?? '',
      pdfPath: map['pdfPath'],
      description: map['description'],
      publishedDate: map['publishedDate'] != null 
          ? DateTime.parse(map['publishedDate']) 
          : null,
      author: map['author'],
      pages: map['pages'],
    );
  }

  // Mengonversi instance Ebook ke Map (berguna untuk serialisasi JSON)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'pdfPath': pdfPath,
      'description': description,
      'publishedDate': publishedDate?.toIso8601String(),
      'author': author,
      'pages': pages,
    };
  }

  // Membuat salinan Ebook dengan perubahan tertentu
  Ebook copyWith({
    String? title,
    String? subtitle,
    String? imagePath,
    String? pdfPath,
    String? description,
    DateTime? publishedDate,
    String? author,
    int? pages,
  }) {
    return Ebook(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      pdfPath: pdfPath ?? this.pdfPath,
      description: description ?? this.description,
      publishedDate: publishedDate ?? this.publishedDate,
      author: author ?? this.author,
      pages: pages ?? this.pages,
    );
  }

  @override
  String toString() {
    return 'Ebook(title: $title, subtitle: $subtitle, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ebook &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imagePath == imagePath &&
        other.pdfPath == pdfPath &&
        other.description == description &&
        other.publishedDate == publishedDate &&
        other.author == author &&
        other.pages == pages;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      subtitle,
      imagePath,
      pdfPath,
      description,
      publishedDate,
      author,
      pages,
    );
  }
}