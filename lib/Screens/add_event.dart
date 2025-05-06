import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Models/events.dart';

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
  Organisations _selectedOrganisation = Organisations.unipulse;
  double ticketPrice = 0.0;

  void _eventSave() {
    // if (_eventImage == null) { // add nore logic here if things are missing
    //   return;
    // }
    ref.read(eventsProvider.notifier).addEvent(//_eventImage!,
        _titleController.text, _selectedOrganisation, _selectedDate!,ticketPrice);

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
                    const SizedBox(width: 40),
                    DropdownButton<Organisations>(
                      value: _selectedOrganisation,
                      items: Organisations.values.map((organisation) {
                        return DropdownMenuItem(
                          value: organisation,
                          child: Text(organisation.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOrganisation = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _eventSave,
                  label: const Text('Add Event'),
                  icon: const Icon(Icons.add),
                )
              ],
            )));
  }
}
