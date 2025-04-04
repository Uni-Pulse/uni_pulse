import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventname;
  final double ticketPrice;
  final String image;
  final Color backgroundColor;
  final String date;
  const EventCard({
    super.key,
    required this.eventname,
    required this.ticketPrice,
    required this.image,
    required this.backgroundColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eventname, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text('\$$ticketPrice', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          Text(date, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          Center(child: Image.asset(image)),
        ],
      ),
    );
  }
}
