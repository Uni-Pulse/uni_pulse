// import 'package:uuid/uuid.dart';

enum EventType {
  arts,
  sports,
  careers,
  social,
  other
} // figyure out a way to make this more dynamic
//enum Organisations {unipulse, careersOffice, example } // figyure out a way to make this more dynamic

// Assuming your EventData model looks something like this (add these methods if not present)
class EventData {
  final String eventName;
  final String organisation;
  final DateTime date;
  final String ticketPrice;
  final EventType eventType;
  final String description;
  final String eventId; // Assuming you added this based on your addEvent method

  EventData({
    required this.eventName,
    required this.organisation,
    required this.date,
    required this.ticketPrice,
    required this.eventType,
    required this.description,
    required this.eventId,
  });

  // Method to convert EventData to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'organisation': organisation,
      'date': date.toIso8601String(), // Store date as string
      'ticketPrice': ticketPrice,
      'eventType': eventType.name, // Store enum as string
      'description': description,
      'eventId': eventId,
    };
  }

  // Factory method to create EventData from a Map from Firestore
  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      eventName: map['eventName'] as String? ?? '',
      organisation: map['organisation'] as String? ?? '',
      date: map['date'] != null ? DateTime.tryParse(map['date']) ?? DateTime.now() : DateTime.now(),
      ticketPrice: map['ticketPrice'] as String? ?? '', // Assuming ticketPrice is a String
      eventType: (map['eventType'] as String?) != null
          ? EventType.values.firstWhere(
              (e) => e.name == map['eventType'],
              orElse: () => EventType.careers, // Provide a default if not found
            )
          : EventType.careers, // Provide a default if null
      description: map['description'] as String? ?? '',
      eventId: map['eventId'] as String? ?? '', // Read eventId from map
    );
  }

  // You might also want an equality check if you compare EventData objects
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventData &&
          runtimeType == other.runtimeType &&
          eventId == other.eventId; // Use eventId for comparison

  @override
  int get hashCode => eventId.hashCode;
}

