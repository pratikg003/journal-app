import 'package:flutter/material.dart';
import 'package:journal_app/pages/journal_detail_screen.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:journal_app/routes/route_animation.dart';
import 'package:journal_app/widgets/app_drawer_widget.dart';
import 'package:journal_app/widgets/journal_calendar.dart';
import 'package:journal_app/widgets/journal_entry_card.dart';
import 'package:provider/provider.dart';

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
      if (!mounted) return;
      context.read<JournalProvider>().loadEntries();
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _showCalendar = false;

  void _newEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    context.read<JournalProvider>().addEntry(
      title: title,
      content: content,
      date: _selectedDate,
    );

    _titleController.clear();
    _contentController.clear();

    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _showCalendar = false;
    });
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<JournalProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      drawer: AppDrawerWidget(),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Builder(
                          builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(Icons.menu, color: Colors.black),
                          ),
                        ),
                      ),
                      Text(
                        'Journal',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _goToToday,
                        icon: Icon(Icons.replay, color: Colors.black),
                      ),
                      IconButton(
                        onPressed: _toggleCalendar,
                        icon: Icon(
                          _showCalendar ? Icons.close : Icons.calendar_today,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_showCalendar)
              JournalCalendar(
                selectedDate: _selectedDate,
                entryDates: context.watch<JournalProvider>().entryDates,
                onDaySelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    _showCalendar = false;
                  });
                },
              ),

            // SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Consumer<JournalProvider>(
                  builder: (context, provider, child) {
                    return _buildBody(provider);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_entry_fab'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Entry',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      key: const Key("title_field"),
                      controller: _titleController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      key: const Key("content_field"),
                      controller: _contentController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts...',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      key: const Key('save_button'),
                      onPressed: _newEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildBody(JournalProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    final entries = provider.entriesForDate(_selectedDate);

    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'No entries for this day.',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return JournalEntryCard(
          entry: entry,
          onTap: () {
            Navigator.push(
              context,
              createSlideRoute(JournalDetailScreen(entryId: entry.id)),
            );
          },
        );
      },
    );
  }
}
