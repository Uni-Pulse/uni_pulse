// import 'package:uuid/uuid.dart';
import 'dart:io';


enum Organisations {unipulse, careersOffice, example } // figyure out a way to make this more dynamic

class EventData {
  const EventData({
    // required this.id, 
    //required this.image,
    required this.eventName,
    required this.organisation,
    required this.date, 
     required this.ticketPrice,
  });

  //final File image;
  final String eventName;
  final Organisations organisation;
  final DateTime date;
  final double ticketPrice;
}


