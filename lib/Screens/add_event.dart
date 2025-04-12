import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  File? _eventImage;
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _descriptionController = TextEditingController();

  void _saveBin() {
    ref.read(eventsProvider.notifier).addEvent(_eventImage!);

    Navigator.of(context)
        .pop(); //Leaves creen once button is pressed, takes the screen off of the stack
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
        appBar: AppBar(
          title: const Text('Add a new Event'),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ImageCamera(
                  onEventImage: (image) {
                    _eventImage = image;
                  },
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: InputDecoration(label: Text('Event Title')),
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    controller: _descriptionController,
                    maxLength: 500,
                    decoration: InputDecoration(
                        label: Text('Event Description'),
                        border: OutlineInputBorder()),
                  ),
                ),
                Row(
                  children: [
          
                    IconButton(
                        onPressed: _eventdatepicker,
                        icon: const Icon(Icons.calendar_month)),
                    Text('Event Date : '),
                    Text(_selectedDate == null
                        ? 'No date selected'
                        : formatter.format(_selectedDate!)),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _saveBin,
                  label: const Text('Add Event'),
                  icon: const Icon(Icons.add),
                )
              ],
            )));
  }
}
