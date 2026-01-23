import 'package:flutter/material.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

    @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if(!mounted) return;
      context.read<JournalProvider>().loadEntries();
    });
  }

  final TextEditingController _entryController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _showCalendar = false;

  Set<DateTime> get _entryDates {
    return context.watch<JournalProvider>().entryDates;
  }

  List<JournalEntry> get _filteredEntries {
    return context.watch<JournalProvider>().entriesForDate(_selectedDate);
  }

  void _newEntry() {
    final text = _entryController.text.trim();
    if (text.isEmpty) return;

    context.read<JournalProvider>().addEntry(text);

    _entryController.clear();
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 7.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.teal,
                // decoration: BoxDecoration(
                //   color: Colors.teal[400]
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Journal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime.now();
                                _showCalendar = false;
                              });
                            },
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showCalendar = !_showCalendar;
                              });
                            },
                            icon: Icon(
                              _showCalendar
                                  ? Icons.close
                                  : Icons.calendar_today,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.blueGrey[800],
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom:
                                          MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom +
                                          20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'New Entry',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        TextField(
                                          controller: _entryController,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            hintText: 'Write your thoughts...',
                                            hintStyle: TextStyle(
                                              color: Colors.white54,
                                            ),
                                            filled: true,
                                            fillColor: Colors.blueGrey[700],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: _newEntry,
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },

                            icon: Icon(
                              Icons.add,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showCalendar)
              TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime.now(),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) {
                  return isSameDay(day, _selectedDate);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _showCalendar = false;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );

                    if (_entryDates.contains(normalizedDay)) {
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
              ),

            SizedBox(height: 20),
            Expanded(
              child: _filteredEntries.isEmpty
                  ? Center(
                      child: Text(
                        'No entries for this day.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _filteredEntries[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.content,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(entry.createdAt),
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white54,
                                    ),
                                    onPressed: () {
                                      _editEntry(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white54,
                                    ),
                                    onPressed: () {
      context.read<JournalProvider>().deleteEntry(index);
                                      
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // void _deleteEntry(int index) {
  //   setState(() {
  //     entries.removeAt(index);
  //   });
  //   _saveEntries();
  // }

  void _editEntry(int index) {
    final entries = context.watch<JournalProvider>().entries;
    final TextEditingController editController = TextEditingController(
      text: entries[index].content,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: const Text(
            'Edit Entry',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: editController,
            maxLines: 6,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = editController.text.trim();
                if (text.isEmpty) return;

                context.read<JournalProvider>().editEntry(index, text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
