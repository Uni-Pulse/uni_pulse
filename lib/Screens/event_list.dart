import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uni_pulse/Screens/event_details.dart';

class BinLocatorScreen extends ConsumerWidget {
  const BinLocatorScreen({super.key});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsSomething = ref.watch(eventsProvider); //will listen to data chanages

    if (eventsSomething.isEmpty) {
      return const Center(child: Text('No Events currently present'));
    }

    return ListView.builder(
        itemBuilder: (ctx, index) => ListTile(
          leading: CircleAvatar( radius: 25,backgroundImage: FileImage(eventsSomething[index].image),),
              title: Text(
                'event'
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EventDetailsScreen(
                      event: eventsSomething[index],
                    ),
                  ),
                );
              },
            ),
        itemCount: eventsSomething.length);




    // return Scaffold(
    //     body: Padding(
    //       padding: const EdgeInsets.all(8),
    //       child: BinList(
    //         bins: binPlaces,
    //       ),
    //     ));
  }
}
