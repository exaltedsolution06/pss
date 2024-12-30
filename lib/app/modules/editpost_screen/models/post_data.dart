class FileData {
  String? id;
  String? filePath;

  FileData({this.id, this.filePath});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      filePath: json['file_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_path': filePath,
    };
  }
}

class PostData {
  List<FileData>? fetchedFiles;
  final int price;
  final String text;

  PostData({
    this.fetchedFiles,
    this.price = 0,
    this.text = '',
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    // Debugging the structure
    print("Full JSON response: $json");

    // Access 'data' and retrieve fields safely
    var data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      print("Error: 'data' field is null or not a Map.");
      return PostData();
    }

    print("Data section extracted successfully: $data");

    // Extracting 'files' with additional null safety
    var filesList = data['files'] as List<dynamic>?;
    if (filesList == null) {
      print("Files field is missing or null.");
    } else {
      print("Files list: $filesList");
    }

    List<FileData> parsedFiles = filesList != null
        ? filesList.map((file) => FileData.fromJson(file as Map<String, dynamic>)).toList()
        : [];

    // Extracting 'price' and 'text' with null safety and debug statements
    int parsedPrice = data['price'] as int? ?? 0;
    String parsedText = data['text'] as String? ?? '';

    print("Parsed Price: $parsedPrice");
    print("Parsed Text: $parsedText");

    return PostData(
      fetchedFiles: parsedFiles,
      price: parsedPrice,
      text: parsedText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fetchedFiles': fetchedFiles?.map((file) => file.toJson()).toList(),
      'price': price,
      'text': text,
    };
  }
}
