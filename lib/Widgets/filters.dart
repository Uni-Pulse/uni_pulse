import 'package:flutter/material.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:uni_pulse/Screens/organizations/add_event.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  DateTime? selectedDate;
  String? selectedOrganisation;
  double minPrice = 0.0;
  double maxPrice = 50.0;
  String? selectedCategory;

  // Sample locations and organisations for dropdowns

  List<String> organisations = [
    'Tech Corp',
    'Creative Studio',
    'Health Group',
    'Education Ltd',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Events'),
        actions: [
          // Apply Button to pass the filters back
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // Create a map of the selected filters
              Map<String, dynamic> filters = {
                'date': selectedDate,
                'organisation': selectedOrganisation,
                'price': {'min': minPrice, 'max': maxPrice},
                'category': selectedCategory,
              };
              debugPrint('Apllied filters: $filters');
              // Return the filters back to the ListEvents page
              Navigator.pop(context, filters);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            const Text('Category'),
            DropdownButton<String>(
              value: EventType.values
                      .map((e) => e.toString().split('.').last)
                      .contains(selectedCategory)
                  ? selectedCategory
                  : null,
              hint: const Text('Select Category'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                  debugPrint('Selected Category: $selectedCategory');
                });
              },
              items: EventType.values
                  .map<DropdownMenuItem<String>>((EventType value) {
                return DropdownMenuItem<String>(
                  value: value.toString().split('.').last,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Price Range Slider
            const Text('Price Range'),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0.0,
              max: 50.0,
              divisions: 50,
              labels: RangeLabels(
                minPrice.round().toString(),
                maxPrice.round().toString(),
              ), // Rounds the value to a whole number
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            const SizedBox(height: 16),

            // Date Picker
            const Text('Select Date'),
            ListTile(
              title: Text(
                selectedDate == null
                    ? 'No date selected'
                    : formatter.format(selectedDate!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),

            //  TextButton(
            //      onPressed: () {
            //     setState(() {
            //     selectedDate = null;
            //     selectedOrganisation = null;
            //     minPrice = 0.0;
            //     maxPrice = 50.0;
            //     selectedCategory = null;
            //   });
            // },
            // child: const Text('Clear Filters'),
            // ),
            // Organisation Dropdown
            const Text('Organisation'),
            DropdownButton<String>(
              value: organisations.contains(selectedOrganisation)
                  ? selectedOrganisation
                  : null,
              hint: const Text('Select Organisation'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOrganisation = newValue;
                });
              },
              items:
                  organisations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

// Future<List<String>> fetchOrganisations() async {
//   // Fetch organisations from Firestore or another source
//   final querySnapshot = await FirebaseFirestore.instance.collection('organisations').get();
//   return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
// }
