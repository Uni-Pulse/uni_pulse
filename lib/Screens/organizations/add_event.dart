import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:flutter/services.dart';// used to only allow numeric inputs in the ticket price

import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:uni_pulse/Widgets/image_controller.dart';

final formatter = DateFormat.yMd();

class AddEventScreen extends ConsumerStatefulWidget {
  //Consumer stateful widget gives access to riverpod
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() {
    return _AddEventState();
  }
}

class _AddEventState extends ConsumerState<AddEventScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _descriptionController = TextEditingController();
  EventType _eventType = EventType.other;
  final _ticketPriceController = TextEditingController();
  late final _currentUser;
  late final _organisationName; // this should be dynamic, but for now it is hardcoded

  @override
  void initState() {
    super.initState();
    _currentUser = ref.read(accountsProvider.notifier).currentUser;
    if (_currentUser == null) {
    // Handle the case where the user is not logged in
    debugPrint('Error: No user is currently logged in.');
    _organisationName = 'Unknown Organisation'; // Fallback value
  } else {
    _organisationName = _currentUser.firstName;
  }
  }


void _eventSave() {
  if (_titleController.text.isEmpty ||
      _selectedDate == null ||
      _ticketPriceController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all required fields.')),
    );
    return;
  }

    debugPrint('Saving event...');
  debugPrint('Title: ${_titleController.text}');
  debugPrint('Organisation: $_organisationName');
  debugPrint('Date: $_selectedDate');
  debugPrint('Ticket Price: ${_ticketPriceController.text}');
  debugPrint('Event Type: $_eventType');
  debugPrint('Description: ${_descriptionController.text}');
  debugPrint('Current User Email: ${_currentUser?.email}');


  ref.read(eventsProvider.notifier).addEvent(
        _titleController.text,
        _organisationName,
        _selectedDate!,
        _ticketPriceController.text,
        _eventType,
        _descriptionController.text,
      );

  Navigator.of(context).pop(); // Close the screen after saving
}

  _eventdatepicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title:  Text('Add a new Event',style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: InputDecoration(label: Text('Event Title', style: Theme.of(context).textTheme.bodySmall)),
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    controller: _descriptionController,
                    maxLength: 500,
                    decoration: InputDecoration(
                        label: Text('Event Description', style: Theme.of(context).textTheme.bodySmall),
                        hintText: 'Description',
                        border: OutlineInputBorder()),
                  ),
                ),
                Row(
  children: [
    IconButton(
      onPressed: _eventdatepicker,
      icon: const Icon(Icons.calendar_month),
    ),
    const Text('Event Date: '),
    Text(_selectedDate == null
        ? 'No date selected'
        : formatter.format(_selectedDate!)),
    const SizedBox(width: 20),
    Expanded(
      child: DropdownButton<EventType>(
        value: _eventType,
        items: EventType.values.map((eventType) {
          return DropdownMenuItem<EventType>(
            value: eventType,
            child: Text(eventType.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _eventType = value!;
          });
        },
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: TextField(
        controller: _ticketPriceController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(labelText: 'Ticket Price'),
      ),
    ),
  ],
),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _eventSave,
                  label: Text('Add Event', style: Theme.of(context).textTheme.bodyLarge),
                  icon: const Icon(Icons.add),
                )
              ],
            )));
  }
}
