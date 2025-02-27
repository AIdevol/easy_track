import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Data model to track routine completion
class RoutineData extends ChangeNotifier {
  // Map to store completion status: {month: {day: isCompleted}}
  final Map<String, Map<int, bool>> _completionData = {};

  // Initialize with empty data for all months
  RoutineData() {
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October',
      'November', 'December'
    ];

    for (var month in months) {
      _completionData[month] = {};
    }
  }

  // Get completion status for a specific day
  bool isDayCompleted(String month, int day) {
    return _completionData[month]?[day] ?? false;
  }

  // Toggle completion status for a day
  void toggleDay(String month, int day) {
    if (_completionData.containsKey(month)) {
      _completionData[month]![day] = !(_completionData[month]![day] ?? false);
      notifyListeners();
    }
  }

  // Get completion percentage for a month
  double getMonthCompletionPercentage(String month, int totalDays) {
    if (!_completionData.containsKey(month)) return 0.0;

    int completedDays = 0;
    _completionData[month]!.forEach((day, isCompleted) {
      if (isCompleted) completedDays++;
    });

    return completedDays / totalDays;
  }

  // Get streak count (consecutive completed days)
  int getCurrentStreak(List<String> months, Map<String, int> daysInMonth) {
    int streak = 0;
    bool broken = false;

    // Start from today and go backwards
    DateTime now = DateTime.now();
    String currentMonth = months[now.month - 1];
    int currentDay = now.day;

    while (!broken) {
      // Check if current day is completed
      if (isDayCompleted(currentMonth, currentDay)) {
        streak++;
      } else {
        broken = true;
        break;
      }

      // Move to previous day
      currentDay--;
      if (currentDay < 1) {
        // Move to previous month
        int currentMonthIndex = months.indexOf(currentMonth);
        if (currentMonthIndex <= 0) break;

        currentMonth = months[currentMonthIndex - 1];
        currentDay = daysInMonth[currentMonth] ?? 30;
      }
    }

    return streak;
  }
}

class MonthsCalendarView extends StatelessWidget {
  const MonthsCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of months to display
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October',
      'November', 'December'
    ];

    // Number of days to show for each month
    final Map<String, int> daysInMonth = {
      'January': 31,
      'February': 29, // 2024 is a leap year
      'March': 31,
      'April': 30,
      'May': 31,
      'June': 30,
      'July': 31,
      'August': 31,
      'September': 30,
      'October': 31,
      'November': 30,
      'December': 31,
    };

    // Get current month
    final DateTime now = DateTime.now();
    final String currentMonth = months[now.month - 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showStatsDialog(context, months, daysInMonth);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStatsBar(context, currentMonth, daysInMonth[currentMonth] ?? 30, months, daysInMonth),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: months.map((month) {
                    return _buildMonthColumn(context, month, daysInMonth[month] ?? 30);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(BuildContext context, String currentMonth, int days, List<String> months, Map<String, int> daysInMonth) {
    final routineData = Provider.of<RoutineData>(context);
    final streak = routineData.getCurrentStreak(months, daysInMonth);
    final monthPercentage = routineData.getMonthCompletionPercentage(currentMonth, days);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Current Streak', '$streak days', Icons.whatshot),
          _buildStatItem(
              'Month Progress',
              '${(monthPercentage * 100).toStringAsFixed(0)}%',
              Icons.calendar_today
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  void _showStatsDialog(BuildContext context, List<String> months, Map<String, int> daysInMonth) {
    final routineData = Provider.of<RoutineData>(context, listen: false);
    final streak = routineData.getCurrentStreak(months, daysInMonth);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Routine Stats'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.whatshot, color: Colors.orange),
              title: Text('Current Streak: $streak days'),
            ),
            const Divider(),
            ...months.map((month) {
              final days = daysInMonth[month] ?? 30;
              final percentage = routineData.getMonthCompletionPercentage(month, days);
              return ListTile(
                title: Text(month),
                trailing: Text('${(percentage * 100).toStringAsFixed(0)}%'),
                subtitle: LinearProgressIndicator(value: percentage),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthColumn(BuildContext context, String month, int days) {
    // Calculate rows needed (showing 7 squares per row)
    final int rows = (days / 7).ceil();
    final routineData = Provider.of<RoutineData>(context);

    // Highlight current month
    final DateTime now = DateTime.now();
    final bool isCurrentMonth = month == [
      'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October',
      'November', 'December'
    ][now.month - 1];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      decoration: isCurrentMonth ? BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ) : null,
      padding: isCurrentMonth ? const EdgeInsets.all(4) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month name at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              month,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isCurrentMonth ? Colors.blue : Colors.black,
              ),
            ),
          ),
          for (int row = 0; row < rows; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  7,
                      (index) {
                    final dayNumber = row * 7 + index + 1;
                    if (dayNumber <= days) {
                      return _buildDaySquare(context, month, dayNumber);
                    } else {
                      return const SizedBox(width: 12, height: 12);
                    }
                  },
                ),
              ),
            ),
          // Display completion percentage
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${(routineData.getMonthCompletionPercentage(month, days) * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySquare(BuildContext context, String month, int day) {
    final routineData = Provider.of<RoutineData>(context);
    final isCompleted = routineData.isDayCompleted(month, day);

    // Highlight current day
    final DateTime now = DateTime.now();
    final bool isCurrentDay = day == now.day &&
        month == [
          'January', 'February', 'March', 'April', 'May',
          'June', 'July', 'August', 'September', 'October',
          'November', 'December'
        ][now.month - 1];

    return GestureDetector(
      onTap: () {
        routineData.toggleDay(month, day);
      },
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(2),
          border: isCurrentDay ? Border.all(color: Colors.blue, width: 1) : null,
        ),
        child: isCompleted ? const Center(
          child: Icon(
            Icons.check,
            size: 8,
            color: Colors.white,
          ),
        ) : null,
      ),
    );
  }
}