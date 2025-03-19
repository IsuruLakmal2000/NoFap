import 'package:flutter/material.dart';
import 'package:nofap/theme/colors.dart';

class RelapseChart extends StatelessWidget {
  // Example data: true = relapse (red), false = no relapse (green)
  final Map<DateTime, bool> relapseData;

  const RelapseChart({required this.relapseData});

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
    int startWeekday =
        days.first.weekday % 7; // Convert Monday (1) - Sunday (7) to 0-6
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
                    bool? hasRelapsed =
                        relapseData[DateTime(day.year, day.month, day.day)];

                    bool isToday =
                        day.year == today.year &&
                        day.month == today.month &&
                        day.day == today.day;

                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            hasRelapsed == null
                                ? Colors.grey[300] // Default color for no data
                                : hasRelapsed
                                ? Colors
                                    .red // Relapsed
                                : Colors.green, // No relapse
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child:
                          isToday
                              ? Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: Text(
                                    "today",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                              )
                              : null,
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
