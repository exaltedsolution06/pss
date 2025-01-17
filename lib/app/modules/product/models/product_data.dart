class FileData {
  String? id;
  String? filePath;

  FileData({this.id, this.filePath});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      filePath: json['file_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_path': filePath,
    };
  }
}

class ProductData {
  List<FileData>? fetchedFiles;
  final int product_id;
  final String category_name;
  final String artist_name;
  final String size_name;
  final String color_name;
  final String name;
  final String product_code;
  final String price;
  final String moulding_description;
  final String total_rating;
  final String total_reviews;
  final String average_rating;
  final double percentage_rating_one;
  final double percentage_rating_two;
  final double percentage_rating_three;
  final double percentage_rating_four;
  final double percentage_rating_five;

  ProductData({
    this.fetchedFiles,
    this.product_id = 0,
    this.category_name = '',
    this.artist_name = '',
    this.size_name = '',
    this.color_name = '',
    this.name = '',
    this.product_code = '',
    this.price = '',
    this.moulding_description = '',
    this.total_rating = '',
    this.total_reviews = '',
    this.average_rating = '',
    this.percentage_rating_one = 0.0,
    this.percentage_rating_two = 0.0,
    this.percentage_rating_three = 0.0,
    this.percentage_rating_four = 0.0,
    this.percentage_rating_five = 0.0,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    // Debugging the structure
    print("Full JSON response: $json");

    // Access 'data' and retrieve fields safely
    var data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      print("Error: 'data' field is null or not a Map.");
      return ProductData();
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

    // Extracting product_id, category_name, artist_name, size_name, color_name, name, product_code, price, moulding_description with null safety and debug statements
    int parsedProductId = data['product_id'] as int? ?? 0;
    String parsedCategoryName = (data['category_name'] ?? '').toString();
    String parsedArtistName = (data['artist_name'] ?? '').toString();
    String parsedSizeName = (data['size_name'] ?? '').toString();
    String parsedColorName = (data['color_name'] ?? '').toString();
    String parsedName = (data['name'] ?? '').toString();
    String parsedProductCode = (data['product_code'] ?? '').toString();
    String parsedPrice = (data['price'] ?? '').toString();
    String parsedMouldingDescription = (data['moulding_description'] ?? '').toString();
    String parsedTotalRating = (data['total_rating'] ?? '').toString();
    String parsedTotalReviews = (data['total_reviews'] ?? '').toString();
    String parsedAverageRating = (data['average_rating'] ?? '').toString();
    // Ensure null safety for double values using `?? 0.0`
    double parsedPercentageRatingOne = (data['percentage_rating_one'] as num?)?.toDouble() ?? 0.0;
    double parsedPercentageRatingTwo = (data['percentage_rating_two'] as num?)?.toDouble() ?? 0.0;
    double parsedPercentageRatingThree = (data['percentage_rating_three'] as num?)?.toDouble() ?? 0.0;
    double parsedPercentageRatingFour = (data['percentage_rating_four'] as num?)?.toDouble() ?? 0.0;
    double parsedPercentageRatingFive = (data['percentage_rating_five'] as num?)?.toDouble() ?? 0.0;

    print("Parsed Product Id: $parsedProductId");
    print("Parsed Category Name: $parsedCategoryName");
    print("Parsed Artist Name: $parsedArtistName");
    print("Parsed Size Name: $parsedSizeName");
    print("Parsed Color Name: $parsedColorName");
    print("Parsed Name: $parsedName");
    print("Product Code: $parsedProductCode");
    print("Price: $parsedPrice");
    print("Moulding Description: $parsedMouldingDescription");
    print("Total Rating: $parsedTotalRating");
    print("Total Reviews: $parsedTotalReviews");
    print("Average Rating: $parsedAverageRating");
    print("Percentage Rating One: $parsedPercentageRatingOne");
    print("Percentage Rating Two: $parsedPercentageRatingTwo");
    print("Percentage Rating Three: $parsedPercentageRatingThree");
    print("Percentage Rating Four: $parsedPercentageRatingFour");
    print("Percentage Rating Five: $parsedPercentageRatingFive");

    return ProductData(
		fetchedFiles: parsedFiles,
		product_id: parsedProductId,
		category_name: parsedCategoryName,
		artist_name: parsedArtistName,
		size_name: parsedSizeName,
		color_name: parsedColorName,
		name: parsedName,
		product_code: parsedProductCode,
		price: parsedPrice,
		moulding_description: parsedMouldingDescription,
		total_rating: parsedTotalRating,
		total_reviews: parsedTotalReviews,
		average_rating: parsedAverageRating,
		percentage_rating_one: parsedPercentageRatingOne,
		percentage_rating_two: parsedPercentageRatingTwo,
		percentage_rating_three: parsedPercentageRatingThree,
		percentage_rating_four: parsedPercentageRatingFour,
		percentage_rating_five: parsedPercentageRatingFive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
		'fetchedFiles': fetchedFiles?.map((file) => file.toJson()).toList(),
		'product_id': product_id,
		'category_name': category_name,
		'artist_name': artist_name,
		'size_name': size_name,
		'color_name': color_name,
		'name': name,
		'product_code': product_code,
		'price': price,
		'moulding_description': moulding_description,
		'total_rating': total_rating,
		'total_reviews': total_reviews,
		'average_rating': average_rating,
		'percentage_rating_one': percentage_rating_one,
		'percentage_rating_two': percentage_rating_two,
		'percentage_rating_three': percentage_rating_three,
		'percentage_rating_four': percentage_rating_four,
		'percentage_rating_five': percentage_rating_five,
    };
  }
}
