import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:flutter/services.dart'; // used to only allow numeric inputs in the ticket price

import 'package:uni_pulse/Providers/events_provider.dart';



// Formatter to display dates in MM/DD/YYYY format
final formatter = DateFormat.yMd();

/// Screen for adding a new event. Supports title, date, type, description, and ticket price.
class AddEventScreen extends ConsumerStatefulWidget {
  //Consumer stateful widget gives access to riverpod
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() {
    return _AddEventState();
  }
}

class _AddEventState extends ConsumerState<AddEventScreen> {


// Uint8List? _image; // Uncomment this line to use image picker
// void selectImage() async{
//   Uint8List img = await pickImage(ImageSource.gallery);
//   setState(() {
//     _image = img;
//   });
// }
  
    // Controllers for input fields

  final _titleController = TextEditingController();
  // selected values
  DateTime? _selectedDate;
  final _descriptionController = TextEditingController();
  EventType _eventType = EventType.other;
  final _ticketPriceController = TextEditingController();
  // Info about current user/organisation
  late final _currentUser;
  late final _organisationName; // this should be dynamic, but for now it is hardcoded

  /// Initializes user-related variables when screen is first loaded
  @override
  void initState() {
    super.initState();
    _currentUser = ref.read(accountsProvider.notifier).currentUser;
    // If user is not found, fallback to placeholder
    if (_currentUser == null) {
      // Handle the case where the user is not logged in
      debugPrint('Error: No user is currently logged in.');
      _organisationName = 'Unknown Organisation'; // Fallback value
    } else {
      _organisationName = _currentUser.firstName;
    }
  }
  /// Function to handle saving of the event.
  /// Validates input, then passes data to Riverpod provider to store it.
  void _eventSave() {
    // Validate required fields
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _ticketPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }
    // Debug logs for dev
    debugPrint('Saving event...');
    debugPrint('Title: ${_titleController.text}');
    debugPrint('Organisation: $_organisationName');
    debugPrint('Date: $_selectedDate');
    debugPrint('Ticket Price: ${_ticketPriceController.text}');
    debugPrint('Event Type: $_eventType');
    debugPrint('Description: ${_descriptionController.text}');
    debugPrint('Current User Email: ${_currentUser?.email}');

    // Save event using provider
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

  /// Opens a date picker and updates the selected date
  _eventdatepicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: lastDate,
    );
    // Update the UI with the selected date
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  /// Builds the UI for the event creation form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Add a new Event',
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: InputDecoration(
                      label: Text('Event Title',
                          style: Theme.of(context).textTheme.bodySmall)),
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    controller: _descriptionController,
                    maxLength: 500,
                    decoration: InputDecoration(
                        label: Text('Event Description',
                            style: Theme.of(context).textTheme.bodySmall),
                        hintText: 'Description',
                        border: OutlineInputBorder()),
                  ),
                ),
                // Row for Date picker, Event type dropdown, and Ticket price
                Row(
                  children: [
                    IconButton(
                      onPressed: _eventdatepicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                    const Text('Event Date: '),
                    // Display selected date or fallback
                    Text(_selectedDate == null
                        ? 'No date selected'
                        : formatter.format(_selectedDate!)),
                    const SizedBox(width: 20),
                    // Dropdown for selecting event type
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
                     // Ticket price input, only allows numeric values
                    Expanded(
                      child: TextField(
                        controller: _ticketPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration:
                            const InputDecoration(labelText: 'Ticket Price'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                 // Save button to trigger event saving
                ElevatedButton.icon(
                  onPressed: _eventSave,
                  label: Text('Add Event',
                      style: Theme.of(context).textTheme.bodyLarge),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(height: 20),

                // Stack( // Uncomment this section to add an image picker, couldnt save image to current database without setting up billing
                //   children: [
                //     Container(
                //       width: double.infinity,
                //       height: 200,
                //       decoration: BoxDecoration(
                //         color: Colors.grey[300],
                //         image: _image != null
                //             ? DecorationImage(
                //                 image: MemoryImage(_image!),
                //                 fit: BoxFit.cover,
                //               )
                //             : const DecorationImage(
                //                 image: AssetImage('assets/logo.png'),
                //                 fit: BoxFit.cover,
                //               ),
                //       ),
                //     ),
                //     Positioned(
                //       child: IconButton(
                //         onPressed: selectImage,
                //         icon: const Icon(Icons.add_a_photo),
                //       ),
                //     ),
                //   ],
                // ),

                ]),
        ),
                );
  }
}
