import 'package:flutter/material.dart';

import 'package:uni_pulse/Models/events.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});

  final EventData event;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(title: Text('Event Details')),
        body: Column(
          children: [
            // //Image.file(
            //   event.image,
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            //   height: 300,
            // ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                

                // Text([type.name, ':', Icons.cabin_outlined].toString()),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                // Text([type.name, ':', Icons.cabin_outlined].toString()),
              ],
            ),
         

            
          ],
        ));
  }
}
