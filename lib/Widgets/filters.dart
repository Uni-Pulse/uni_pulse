import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

Future<List<String>> fetchOrganisations() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('organisations').get();
  return querySnapshot.docs.map((doc) => doc['orgName'] as String).toList();
}

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

  List<String> organisations = [];
  bool isLoadingOrgs = false;

  @override
  void initState() {
    super.initState();
    _loadOrganisations();
  }

  Future<void> _loadOrganisations() async {
    setState(() {
      isLoadingOrgs = true;
    });
    try {
      final orgs = await fetchOrganisations();
      setState(() {
        organisations = orgs;
      });
    } catch (e) {
      debugPrint('Failed to fetch organisations: $e');
    } finally {
      setState(() {
        isLoadingOrgs = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Map<String, dynamic> filters = {
                'date': selectedDate,
                'organisation': selectedOrganisation != null && selectedOrganisation!.isNotEmpty ? selectedOrganisation : null,
                'price': {'min': minPrice, 'max': maxPrice},
                'category': selectedCategory,
              };
              debugPrint('Applied filters: $filters');
              Navigator.pop(context, filters);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
                });
              },
              items: EventType.values.map((EventType value) {
                final label = value.toString().split('.').last;
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(label),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text('Price Range'),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0.0,
              max: 50.0,
              divisions: 50,
              labels: RangeLabels(
                minPrice.round().toString(),
                maxPrice.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            const SizedBox(height: 16),

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

            TextButton(
              onPressed: () {
                setState(() {
                  selectedDate = null;
                  selectedOrganisation = null;
                  minPrice = 0.0;
                  maxPrice = 50.0;
                  selectedCategory = null;
                });
              },
              child: const Text('Clear Filters'),
            ),
            const SizedBox(height: 16),

            const Text('Organisation'),
            Row(
              children: [
                IconButton(
                  onPressed: isLoadingOrgs ? null : _loadOrganisations,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Organisations',
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: isLoadingOrgs
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButton<String>(
                          isExpanded: true,
                          value: organisations.contains(selectedOrganisation)
                              ? selectedOrganisation
                              : null,
                          hint: const Text('Select Organisation'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOrganisation = newValue;
                            });
                          },
                          items: organisations
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

