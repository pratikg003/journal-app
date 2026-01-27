import 'package:flutter/material.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:journal_app/pages/journal_detail_screen.dart';
import 'package:journal_app/providers/auth_provider.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:journal_app/widgets/journal_calendar.dart';
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

    context.read<JournalProvider>().addEntry(title: title, content: content);

    _titleController.clear();
    _contentController.clear();
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JournalProvider>();

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'L O G O U T',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pop(context);
              },
            ),
            Text(
              'Entries: ${provider.totalEntries}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'This week: ${provider.entriesThisWeek()}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
                            onPressed: _goToToday,
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleCalendar,
                            icon: Icon(
                              _showCalendar
                                  ? Icons.close
                                  : Icons.calendar_today,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          // SizedBox(width: 10),
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
                                        TextField(
                                          controller: _titleController,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            hintText: 'Title',
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
                                        TextField(
                                          controller: _contentController,
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
                          Builder(
                            builder: (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(Icons.menu, color: Colors.white),
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

            SizedBox(height: 20),
            Expanded(child: _buildBody(provider)),
          ],
        ),
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
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildEntryTile(entry, index);
      },
    );
  }

  Widget _buildEntryTile(JournalEntry entry, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (_) => JournalDetailScreen(entryId: entry.id,)),
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                JournalDetailScreen(entryId: entry.id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatDate(entry.createdAt),
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Column(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.edit, color: Colors.white54),
            //       onPressed: () {
            //         _editEntry(index);
            //       },
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.delete, color: Colors.white54),
            //       onPressed: () {
            //         context.read<JournalProvider>().deleteEntry(index);
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // void _editEntryById(String id) {
  //   final index = context.read<JournalProvider>().entries.indexWhere(
  //     (e) => e.id == id,
  //   );

  //   if (index != -1) {
  //     _editEntry(index);
  //   }
  // }

  // void _editEntry(int index) {
  //   final entries = context.read<JournalProvider>().entries;
  //   final TextEditingController editController = TextEditingController(
  //     text: entries[index].content,
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.blueGrey[800],
  //         title: const Text(
  //           'Edit Entry',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: TextField(
  //           controller: editController,
  //           maxLines: 6,
  //           style: TextStyle(color: Colors.white),
  //           decoration: InputDecoration(border: OutlineInputBorder()),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               final text = editController.text.trim();
  //               if (text.isEmpty) return;

  //               context.read<JournalProvider>().editEntry(index, text);
  //               Navigator.pop(context);
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
