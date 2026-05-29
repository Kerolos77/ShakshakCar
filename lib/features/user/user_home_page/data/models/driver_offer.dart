class DriverOffer {
  final String driverName;
  final double price;
  final int offerDuration;
  bool isAccepted = false;

  DriverOffer({required this.driverName, required this.price, this.offerDuration = 5});
}
