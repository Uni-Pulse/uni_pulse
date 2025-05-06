import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/organizations/add_event.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, String>> events = [
    {'title': 'Tech Networking Event', 'image': 'assets/tech_event.jpg', 'location': 'Building A', 'date': 'March 25, 2025'},
    {'title': 'Startup Workshop', 'image': 'assets/startup.jpg', 'location': 'Innovation Hub', 'date': 'April 10, 2025'},
    {'title': 'AI & ML Seminar', 'image': 'assets/ai_ml.jpg', 'location': 'Library Hall', 'date': 'May 5, 2025'},
    {'title': 'Coding Bootcamp', 'image': 'assets/coding.jpg', 'location': 'Room 101', 'date': 'June 15, 2025'},
    {'title': 'Career Fair', 'image': 'assets/career_fair.jpg', 'location': 'Main Auditorium', 'date': 'July 20, 2025'},
  ];

  List<Map<String, String>> filteredEvents = [];
  String searchQuery = "";

  @override 
  void initState() {
    super.initState();
    filteredEvents = List.from(events); // Initially show all events
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // You can add navigation here based on the selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UniPulse Events', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF660099), // Portsmouth Purple
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // showSearch(context: context, delegate: EventSearchDelegate());
              Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AddEventScreen(),
                    ),
                  );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.asset(filteredEvents[index]['image']!, fit: BoxFit.cover, height: 150, width: double.infinity),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(filteredEvents[index]['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF660099))),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Color(0xFF0091DA)),
                            SizedBox(width: 5),
                            Text(filteredEvents[index]['location']!, style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF0091DA)),
                            SizedBox(width: 5),
                            Text(filteredEvents[index]['date']!, style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF0091DA), // Portsmouth Blue
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class EventSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> events = [
    {'title': 'Tech Networking Event', 'image': 'assets/tech_event.jpg', 'location': 'Building A', 'date': 'March 25, 2025'},
    {'title': 'Startup Workshop', 'image': 'assets/startup.jpg', 'location': 'Innovation Hub', 'date': 'April 10, 2025'},
    {'title': 'AI & ML Seminar', 'image': 'assets/ai_ml.jpg', 'location': 'Library Hall', 'date': 'May 5, 2025'},
    {'title': 'Coding Bootcamp', 'image': 'assets/coding.jpg', 'location': 'Room 101', 'date': 'June 15, 2025'},
    {'title': 'Career Fair', 'image': 'assets/career_fair.jpg', 'location': 'Main Auditorium', 'date': 'July 20, 2025'},
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = events.where((event) {
      return event['title']!.toLowerCase().contains(query.toLowerCase()) ||
          event['location']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['title']!),
          subtitle: Text(results[index]['location']!),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = events.where((event) {
      return event['title']!.toLowerCase().contains(query.toLowerCase()) ||
          event['location']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['title']!),
          subtitle: Text(suggestions[index]['location']!),
        );
      },
    );
  }
}
