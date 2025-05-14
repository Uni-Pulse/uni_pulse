// import 'package:uuid/uuid.dart';

enum EventType {arts, sports, careers, social, other } // figyure out a way to make this more dynamic
//enum Organisations {unipulse, careersOffice, example } // figyure out a way to make this more dynamic

class EventData {

  //final File image;
  final String eventName;
  final String organisation;
  final DateTime date;
  final String ticketPrice;
  final EventType eventType;
  final String description;
  final String eventId;

  const EventData({
    // required this.id, 
    //required this.image,
    required this.eventName,
    required this.organisation,
    required this.date, 
    required this.ticketPrice,
    required this.eventType,
    required this.description,
    required this.eventId,
  });
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'organisation': organisation,
      'date': date.toIso8601String(),
      'ticketPrice': ticketPrice,
      'eventType': eventType.toString(),
      'description': description,
      'eventId': eventId,
    };
  }

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      eventName: map['eventName'],
      organisation: map['organisation'],
      date: DateTime.parse(map['date']),
      ticketPrice: map['ticketPrice'],
      eventType: EventType.values.firstWhere((e) => e.toString() == map['eventType']),
      description: map['description'],
      eventId: map['eventId'],
    );
  }
}


