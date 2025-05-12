import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:uni_pulse/Widgets/image_controller.dart';

final formatter = DateFormat.yMd();

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventState();
}

class _AddEventState extends ConsumerState<AddEventScreen> {
  File? _eventImage;
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _descriptionController = TextEditingController();
  Organisations _selectedOrganisation = Organisations.unipulse;
  double ticketPrice = 0.0;

  void _eventSave() {
    ref.read(eventsProvider.notifier).addEvent(
      _titleController.text,
      _selectedOrganisation,
      _selectedDate!,
      ticketPrice,
    );

    Navigator.of(context).pop();
  }

  _eventdatepicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1);
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: _eventdatepicker,
                  icon: const Icon(Icons.calendar_month),
                ),
                Text(
                  'Event Date:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : formatter.format(_selectedDate!),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
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
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _eventSave,
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
