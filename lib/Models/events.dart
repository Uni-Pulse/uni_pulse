// import 'package:uuid/uuid.dart';

enum EventType {arts, sports, careers, social, other } // figyure out a way to make this more dynamic
//enum Organisations {unipulse, careersOffice, example } // figyure out a way to make this more dynamic

class EventData {
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

  //final File image;
  final String eventName;
  final String organisation;
  final DateTime date;
  final String ticketPrice;
  final EventType eventType;
  final String description;
  final String eventId;
}


