import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Set<DateTime> entryDates;
  final ValueChanged<DateTime> onDaySelected;

  const JournalCalendar({
    super.key,
    required this.selectedDate,
    required this.entryDates,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime.now(),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) {
        return isSameDay(day, selectedDate);
      },
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final normalizedDay = DateTime(
            day.year,
            day.month,
            day.day,
          );

          if (entryDates.contains(normalizedDay)) {
            return Positioned(
              bottom: 6,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
