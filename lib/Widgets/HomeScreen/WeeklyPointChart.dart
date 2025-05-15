import 'package:flutter/material.dart';
import 'package:FapFree/Theme/colors.dart';
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
    double screenWidth = MediaQuery.of(context).size.width * 0.95;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(height: 16),
            ),
            _pointsData.isNotEmpty
                ? SizedBox(
                  height: 260, // Set the height for the chart
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
                          getTooltipColor: (LineBarSpot spot) => AppColors.red,
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1, // Ensure labels are shown for each day
                            reservedSize:
                                20, // Increase reserved size for bottom titles
                            getTitlesWidget: (value, meta) {
                              // Map the x-axis value to the corresponding date
                              int index = value.toInt();
                              if (index >= 0 && index < _pointsData.length) {
                                DateTime date = _pointsData.keys.elementAt(
                                  index,
                                );
                                return Text(
                                  "${date.day}/${date.month}", // Format as "day/month"
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mediumGray,
                                  ),
                                );
                              }
                              return const SizedBox.shrink(); // Return empty widget for invalid indices
                            },
                          ),
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
                                        .clamp(1, double.infinity))
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
                      minY: 0, // Ensure the chart starts from 0
                      maxY:
                          (_pointsData.isNotEmpty
                              ? _pointsData.values.reduce(
                                    (a, b) => a > b ? a : b,
                                  ) +
                                  5
                              : 10), // Add padding to the top for better spacing
                      lineBarsData: [
                        LineChartBarData(
                          spots:
                              _pointsData.entries.toList().asMap().entries.map((
                                entry,
                              ) {
                                int index =
                                    entry
                                        .key; // Normalize index for x-axis (0 to 6)
                                int points = entry.value.value;
                                return FlSpot(
                                  index.toDouble(),
                                  points.toDouble(),
                                );
                              }).toList(),
                          isCurved: false,

                          color: const Color.fromARGB(255, 0, 153, 25),
                          barWidth: 2,
                          belowBarData: BarAreaData(
                            show: false,
                            color: const Color.fromARGB(255, 170, 170, 170),
                          ),
                        ),
                      ],
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
