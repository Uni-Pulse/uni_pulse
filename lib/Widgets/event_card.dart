import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventname;
  final double ticketPrice;
  //final File image;
  final Color backgroundColor;
  final DateTime date;
  final VoidCallback onDelete;
  const EventCard({
    super.key,
    required this.eventname,
    required this.ticketPrice,
    //required this.image,
    required this.backgroundColor,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yMMMd');

    return Stack(
      children: [
        Container(
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
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, 
                      color: Theme.of(context).colorScheme.primary,
                      size: 10),
                  const SizedBox(width: 5),
                  Text(formatter.format(date), 
                    style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.currency_pound_outlined, 
                    color: Theme.of(context).colorScheme.primary,
                    size: 10),
                  const SizedBox(height: 5),
                  Text('Ticket Price: \£${ticketPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  
              const SizedBox(height: 5),
              // Center(child: Image.file(image)),
            ],

          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: IconButton(
            icon:  Icon(Icons.delete, 
              color: Theme.of(context).colorScheme.error),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
