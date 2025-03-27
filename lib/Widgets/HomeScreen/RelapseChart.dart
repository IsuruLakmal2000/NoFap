import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nofap/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelapseChart extends StatefulWidget {
  const RelapseChart({Key? key}) : super(key: key);

  static Future<void> saveRelapseDate(DateTime relapseDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? relapseDateStrings =
        prefs.getStringList('relapseDates') ?? [];
    relapseDateStrings.add(relapseDate.toIso8601String());
    // if (prefs.getString('streakStartDate') != null) {
    //   relapseDateStrings.add(prefs.getString('streakStartDate')!);
    // }
    await prefs.setStringList('relapseDates', relapseDateStrings);
  }

  @override
  State<RelapseChart> createState() => _RelapseChartState();
}

class _RelapseChartState extends State<RelapseChart> {
  Map<DateTime, bool> _relapseData = {};
  DateTime? _streakStartDate;
  DateTime? _oldestRelapseDate;

  @override
  void initState() {
    super.initState();
    _loadData();
    getOldestRelapsedDate();
    // RelapseChart.saveRelapseDate(DateTime(2025, 3, 10));
    // RelapseChart.saveRelapseDate(DateTime(2025, 3, 5));
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startDateString = prefs.getString('streakStartDate');
    //await prefs.remove('relapseDates');

    if (startDateString != null) {
      // Parse the start date string and normalize it
      DateTime startDate = DateTime.parse(startDateString);
      DateTime normalizedStartDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      setState(() {
        _streakStartDate = normalizedStartDate;
        _relapseData[normalizedStartDate] =
            true; // Add normalized start date as a relapse date
      });
    }

    List<String>? relapseDateStrings = prefs.getStringList('relapseDates');
    if (relapseDateStrings != null) {
      setState(() {
        _relapseData.addAll({
          for (var date in relapseDateStrings)
            DateTime.parse(date).toLocal(): true, // Normalize relapse dates
        });
      });
    }
  }

  Future<void> getOldestRelapsedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? relapseDateStrings = prefs.getStringList('relapseDates');

    if (relapseDateStrings != null) {
      print('relapse adt');
      // Parse the dates and find the oldest one
      List<DateTime> relapseDates =
          relapseDateStrings
              .map((dateString) => DateTime.parse(dateString))
              .toList();
      relapseDates.sort(); // Sort dates in ascending order
      DateTime oldestRelapseDate = relapseDates.first;
      _oldestRelapseDate = oldestRelapseDate;
      // Store the oldest relapse date in a variable
    } else {
      String? startDateString = prefs.getString('streakStartDate');
      DateTime startDate = DateTime.parse(startDateString!);
      DateTime normalizedStartDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      RelapseChart.saveRelapseDate(normalizedStartDate);
      _loadData();
      print("No relapse dates found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    double screenWidth = MediaQuery.of(context).size.width * 0.9;

    // Generate last 30 days and normalize to remove time
    List<DateTime> days =
        List.generate(
          30,
          (index) => DateTime(
            today.year,
            today.month,
            today.day,
          ).subtract(Duration(days: index)),
        ).reversed.toList();

    // Get the first day's weekday (0 = Monday, 6 = Sunday)
    int startWeekday = days.first.weekday % 7;

    // Weekday labels
    List<String> weekLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Your Consistency Chart",
                style: TextStyle(
                  color: AppColors.darkGray2,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),

              // Day Labels (Sun, Mon, ...)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      weekLabels
                          .map(
                            (day) => Expanded(
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mediumGray,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 columns for a weekly structure
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: days.length + startWeekday,
                  itemBuilder: (context, index) {
                    if (index < startWeekday) {
                      // Empty space before first day
                      return Container();
                    }

                    DateTime day = days[index - startWeekday];
                    DateTime normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    bool isRelapseDay = _relapseData[normalizedDay] ?? false;

                    bool isToday =
                        day.year == today.year &&
                        day.month == today.month &&
                        day.day == today.day;

                    bool isBeforeStreakStart =
                        _streakStartDate != null &&
                        day.isBefore(_streakStartDate!);
                    bool isBeforeOldestRelapse =
                        _oldestRelapseDate != null &&
                        day.isBefore(_oldestRelapseDate!);
                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            isToday
                                ? Colors.grey[300] // Default color for today
                                : isRelapseDay
                                ? Colors
                                    .red // Relapsed
                                : isBeforeOldestRelapse
                                ? Colors.grey[300]
                                : isBeforeStreakStart
                                ? Colors
                                    .green // No relapse
                                : Colors.green, // No relapse

                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          "${day.day}", // Display the day number
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color:
                                isToday || isBeforeOldestRelapse
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
