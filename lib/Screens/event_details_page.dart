import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, Object> product;
  const EventDetailsPage({super.key, required this.product});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int wantedSize = 0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
