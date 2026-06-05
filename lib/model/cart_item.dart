class CartItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  int quantity;
  final String content;

  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
    required this.quantity,
    required this.content,
  });
}
