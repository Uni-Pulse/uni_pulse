import 'package:flutter/material.dart';
import 'package:uni_pulse/Models/events.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  DateTime? selectedDate;
  String? selectedLocation;
  String? selectedOrganisation;
  double minPrice = 0.0;
  double maxPrice = 50.0;
  String? selectedCategory;

  // Sample locations and organisations for dropdowns
  List<String> locations = ['London', 'Birmingham', 'Glasgow', 'Portsmouth'];
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
            onPressed: () {
              // Create a map of the selected filters
              Map<String, dynamic> filters = {
                'date': selectedDate,
                'location': selectedLocation,
                'organisation': selectedOrganisation,
                'price': {'min': minPrice, 'max': maxPrice},
                'category': selectedCategory,
              };

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
              value: selectedCategory,
              hint: const Text('Select Category'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items:
                  EventType.values.map<DropdownMenuItem<String>>((EventType value) {
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
                minPrice.toStringAsFixed(
                  0,
                ), // Rounds the value to a whole number
                maxPrice.toStringAsFixed(
                  0,
                ), // Rounds the value to a whole number
              ),
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
                    : '${selectedDate?.toLocal()}'.split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),

            // Location Dropdown
            const Text('Location'),
            DropdownButton<String>(
              value: selectedLocation,
              hint: const Text('Select Location'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
              items:
                  locations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Organisation Dropdown
            const Text('Organisation'),
            DropdownButton<String>(
              value: selectedOrganisation,
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
