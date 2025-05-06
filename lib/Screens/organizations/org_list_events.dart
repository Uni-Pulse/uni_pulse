import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/event_details.dart';
import 'package:uni_pulse/Screens/organizations/add_event.dart';
import 'package:uni_pulse/Widgets/event_card.dart';
import 'package:uni_pulse/Providers/events_provider.dart'; // Import the events provider
import 'package:uni_pulse/Models/events.dart';

class OrgListEvents extends ConsumerWidget {
  OrgListEvents({super.key});
  // Use a StateProvider to hold the applied filters
  final appliedFiltersProvider =
      StateProvider<Map<String, dynamic>>((ref) => {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsInfo = ref.watch(eventsProvider);
    // Use the provider to get events

    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final filtersApplied = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddEventScreen()),
                );

                if (filtersApplied != null) {
                  ref.read(appliedFiltersProvider.notifier).state =
                      filtersApplied;
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            
            Expanded(
              child: ListView.builder(
                itemCount: eventsInfo.length, // Using global products here
                itemBuilder: (context, index) {
                  //final product = eventsInfo[index];
                  if (_shouldDisplayProduct(eventsInfo[index], ref)) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EventDetailsScreen(
                                  event: eventsInfo[index]);
                            },
                          ),
                        );
                      },
                      child: EventCard(
                        eventname: eventsInfo[index].eventName,
                        ticketPrice: eventsInfo[index].ticketPrice,
                        //image: eventsInfo[index].image,
                        date: eventsInfo[index].date, // Pass the DateTime directly
                        backgroundColor: index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldDisplayProduct(EventData product, WidgetRef ref) {
    final appliedFilters = ref.watch(appliedFiltersProvider);

    if (appliedFilters.isEmpty) {
      return true;
    }

    if (appliedFilters['category'] != null &&
        appliedFilters['category'] != product) {
      return false;
    }

    if (appliedFilters['price'] != null) {
      var priceRange = appliedFilters['price'];

      if (priceRange is Map &&
          priceRange['min'] != null &&
          priceRange['max'] != null) {
        double productPrice = product.ticketPrice;

        // Use default values if priceRange is incomplete
        double minPrice = priceRange['min'] ?? 0.0;
        double maxPrice = priceRange['max'] ?? 50.0;

        if (productPrice < minPrice || productPrice > maxPrice) {
          return false; // Filter by price range
        }
      }
    }

    return true; // Ensure a return value in all code paths
  }
}
