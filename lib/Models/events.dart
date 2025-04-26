import 'package:uuid/uuid.dart';
import 'dart:io';


class EventData {
  const EventData({
   // required this.id,
    required this.eventName,
    required this.ticketPrice,
    required this.organisation,
    required this.date,
  });

  final String eventName;
  final double ticketPrice;
  final String organisation;
  final DateTime date;
}

//temporary replace with above when can
final uuid = Uuid();


class Event {
  Event({
    required this.image,
    String? id,
  }) : id = id?? uuid.v4();

  final String id;
  final File image;

  //final List<String> type;
}

