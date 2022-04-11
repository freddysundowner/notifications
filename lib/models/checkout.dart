

class Order {
  String shippingId;
  String productId;
  String shopId;
  String subTotal;
  String? shippingAddress;
  String tax;
  String shippingFee;
  int quantity;
  String productOwnerId;
  String variation;

  Order({
    required this.shippingId,
    required this.productId,
    required this.shopId,
    required this.subTotal,
    required this.tax,
    required this.shippingFee,
    this.shippingAddress,
    required this.quantity,
    required this.productOwnerId,
    required this.variation,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      shippingId: json["shippingId"],
      shippingAddress: json["shippingAddress"] ?? "",
      productId: json["productId"],
      shopId: json["shopId"],
      subTotal: json["subTotal"],
      tax: json["tax"],
      shippingFee: json["shippingFee"],
      quantity: json["quantity"],
      productOwnerId: json["productOwnerId"],
      variation: json["variation"]);

  Map<String, dynamic> toJson() => {
        "shippingId": shippingId,
        "productId": productId,
        "shippingAddress": shippingAddress,
        "shopId": shopId,
        "subTotal": subTotal,
        "tax": tax,
        "shippingFee": shippingFee,
        "quantity": quantity,
        "productOwnerId": productOwnerId,
        "variation": variation
      };
}
