import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyPointsChart extends StatefulWidget {
  @override
  _WeeklyPointsChartState createState() => _WeeklyPointsChartState();
}

class _WeeklyPointsChartState extends State<WeeklyPointsChart> {
  Map<DateTime, int> _pointsData = {};

  @override
  void initState() {
    super.initState();
    _loadPointsData(); // Load points data directly
  }

  // Load points data from SharedPreferences and display last 7 days' points with keys
  Future<void> _loadPointsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<DateTime, int> pointsMap = {};

    // Get last 7 days' keys
    List<String> lastSevenDaysKeys = _getLastSevenDaysKeys();

    for (String key in lastSevenDaysKeys) {
      DateTime date = _parseDateFromKey(key);
      int points =
          prefs.getInt(key) ?? 0; // Default to 0 if no points for that date
      pointsMap[date] = points;
      print("Key: $key, Points: $points"); // Display key and points in console
    }

    setState(() {
      _pointsData = pointsMap; // Update the UI with points data
    });
  }

  // Helper method to generate the key for a specific date
  String _getDateKey(DateTime date) {
    // Example: For a date like 2023-03-15, the key will be "2023-3-15_taskpoint"
    return "${date.year}-${date.month}-${date.day}_taskpoint";
  }

  // Get the last 7 days' keys
  List<String> _getLastSevenDaysKeys() {
    DateTime today = DateTime.now();
    return List.generate(7, (index) {
      DateTime day = today.subtract(Duration(days: index));
      return _getDateKey(day);
    });
  }

  // Parse a date from the generated key
  DateTime _parseDateFromKey(String key) {
    List<String> parts = key.split('_')[0].split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Last 7 Days Earned Points",
              style: TextStyle(
                color: AppColors.darkGray2,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            _pointsData.isNotEmpty
                ? SizedBox(
                  height: 260, // Set the height for the chart
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toInt()} points',
                                  TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                            getTooltipColor:
                                (LineBarSpot spot) => AppColors.darkGray,
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval:
                                  (_pointsData.isNotEmpty
                                      ? ((_pointsData.values.reduce(
                                                (a, b) => a > b ? a : b,
                                              ) /
                                              5)
                                          .ceilToDouble()
                                          .clamp(
                                            1,
                                            double.infinity,
                                          )) // Ensure interval is at least 1
                                      : 10), // Dynamically calculate interval
                              getTitlesWidget:
                                  (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mediumGray,
                                    ),
                                  ),
                              reservedSize: 30, // Space for y-axis titles
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots:
                                _pointsData.entries.map((entry) {
                                  DateTime date = entry.key;
                                  int points = entry.value;
                                  return FlSpot(
                                    date.day.toDouble(),
                                    points.toDouble(),
                                  );
                                }).toList(),
                            isCurved: true,
                            color: AppColors.darkGray2,
                            barWidth: 2,
                            belowBarData: BarAreaData(
                              show: false,
                              color: const Color.fromARGB(255, 170, 170, 170),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
