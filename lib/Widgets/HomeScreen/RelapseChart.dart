import 'package:flutter/material.dart';
import 'package:FapFree/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelapseChart extends StatefulWidget {
  const RelapseChart({Key? key}) : super(key: key);

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
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("RelapseChart didChangeDependencies called");
  //   _loadData();
  //   getOldestRelapsedDate();
  // }
  Future<void> saveRelapseDate(DateTime relapseDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? relapseDateStrings =
        prefs.getStringList('relapseDates') ?? [];
    relapseDateStrings.add(relapseDate.toIso8601String());
    await prefs.setStringList('relapseDates', relapseDateStrings);
    await _loadData();
    await getOldestRelapsedDate();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startDateString = prefs.getString('streakStartDate');

    if (startDateString != null) {
      DateTime startDate = DateTime.parse(startDateString);
      DateTime normalizedStartDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      setState(() {
        _streakStartDate = normalizedStartDate;
        _relapseData[normalizedStartDate] = true;
      });
    }

    List<String>? relapseDateStrings = prefs.getStringList('relapseDates');
    if (relapseDateStrings != null) {
      setState(() {
        _relapseData.addAll({
          for (var date in relapseDateStrings)
            DateTime.parse(date).toLocal(): true,
        });
      });
    }
  }

  Future<void> getOldestRelapsedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? relapseDateStrings = prefs.getStringList('relapseDates');

    if (relapseDateStrings != null) {
      List<DateTime> relapseDates =
          relapseDateStrings
              .map((dateString) => DateTime.parse(dateString))
              .toList();
      relapseDates.sort();
      if (relapseDates.isNotEmpty) {
        DateTime oldestRelapseDate = relapseDates.first;
        _oldestRelapseDate = oldestRelapseDate;
      }
    } else {
      String? startDateString = prefs.getString('streakStartDate');
      if (startDateString != null) {
        DateTime startDate = DateTime.parse(startDateString);
        DateTime normalizedStartDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        await saveRelapseDate(normalizedStartDate);
      } else {
        print("No start date found to initialize relapse chart.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    double screenWidth = MediaQuery.of(context).size.width * 0.95;

    List<DateTime> days =
        List.generate(
          30,
          (index) => DateTime(
            today.year,
            today.month,
            today.day,
          ).subtract(Duration(days: index)),
        ).reversed.toList();

    int startWeekday = days.first.weekday % 7;
    List<String> weekLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: days.length + startWeekday,
                  itemBuilder: (context, index) {
                    if (index < startWeekday) {
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

                    // print(
                    //   "Day: $day, "
                    //   "isBeforeStreakStart: $isBeforeStreakStart, "
                    //   "isBeforeOldestRelapse: $isBeforeOldestRelapse, "
                    //   "isToday: $isToday, "
                    //   "isRelapseDay: $isRelapseDay",
                    // );

                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            isToday
                                ? Colors.grey[300]
                                : isRelapseDay
                                ? Colors.red
                                : isBeforeOldestRelapse
                                ? Colors.grey[300]
                                : isBeforeStreakStart
                                ? Colors.green
                                : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          "${day.day}",
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
