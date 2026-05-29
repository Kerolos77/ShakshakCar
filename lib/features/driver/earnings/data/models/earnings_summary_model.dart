class EarningsSummaryModel {
  final double grossEarnings;
  final double netEarnings;
  final double totalCommission;
  final double cashCollected;
  final double digitalEarnings;
  final int completedTripsCount;
  final List<ChartDataModel> chartData;

  EarningsSummaryModel({
    required this.grossEarnings,
    required this.netEarnings,
    required this.totalCommission,
    required this.cashCollected,
    required this.digitalEarnings,
    required this.completedTripsCount,
    required this.chartData,
  });

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryModel(
      grossEarnings: (json['gross_earnings'] ?? 0).toDouble(),
      netEarnings: (json['net_earnings'] ?? 0).toDouble(),
      totalCommission: (json['total_commission'] ?? 0).toDouble(),
      cashCollected: (json['cash_collected'] ?? 0).toDouble(),
      digitalEarnings: (json['digital_earnings'] ?? 0).toDouble(),
      completedTripsCount: json['completed_trips_count'] ?? 0,
      chartData: (json['chart_data'] as List? ?? [])
          .map((e) => ChartDataModel.fromJson(e))
          .toList(),
    );
  }
}

class ChartDataModel {
  final String date;
  final double gross;
  final double net;
  final int trips;

  ChartDataModel({
    required this.date,
    required this.gross,
    required this.net,
    required this.trips,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      date: json['date'] ?? '',
      gross: (json['gross'] ?? 0).toDouble(),
      net: (json['net'] ?? 0).toDouble(),
      trips: json['trips'] ?? 0,
    );
  }
}
