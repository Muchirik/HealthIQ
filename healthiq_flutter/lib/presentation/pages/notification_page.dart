import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    // Example notifications:
    // '⚠️ Your last checkup was 30 days ago. Consider doing another symptoms check.',
    // '🧠 New AI update: Faster and more accurate predictions!',
    // Leave this empty to test the "no notifications" message
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_chat_read_rounded, size: 60, color: Colors.grey[500]),
            const SizedBox(height: 12),
            Text(
              'No notifications right now.\nLet us know your thoughts!',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.teal[700]),
              title: Text(
                notifications[index],
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
