import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/event_details.dart';
import 'package:uni_pulse/Widgets/event_card.dart';
import 'package:uni_pulse/Widgets/filters.dart';
import 'package:uni_pulse/Providers/events_provider.dart'; // Import the events provider
import 'package:uni_pulse/Models/events.dart';

final appliedFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final searchQueryProvider = StateProvider<String>((ref) => '');

class ListEvents extends ConsumerWidget {
  const ListEvents({super.key});
  // Use a StateProvider to hold the applied filters

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title:  Text('Events', style: Theme.of(context).textTheme.titleLarge,),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final filtersApplied = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
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
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                  ),
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
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
                        ticketPrice:
                            double.parse(eventsInfo[index].ticketPrice),
                        //image: eventsInfo[index].image,
                        date: eventsInfo[index].date,
                        backgroundColor: index.isEven
                            ? const Color.fromARGB(255, 175, 126, 180)
                            : const Color.fromARGB(255, 130, 78, 143),
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
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    // Search filter
    if (searchQuery.isNotEmpty &&
        !product.eventName.toLowerCase().contains(searchQuery)) {
      return false;
    }

    // Category filter
    if (appliedFilters['category'] != null &&
        appliedFilters['category'] !=
            product.eventType.toString().split('.').last) {
      return false;
    }

    // Price filter
    if (appliedFilters['price'] != null) {
      var priceRange = appliedFilters['price'];

      if (priceRange is Map &&
          priceRange['min'] != null &&
          priceRange['max'] != null) {
        double productPrice = double.parse(product.ticketPrice);

        double minPrice = priceRange['min'] ?? 0.0;
        double maxPrice = priceRange['max'] ?? 50.0;

        if (productPrice < minPrice || productPrice > maxPrice) {
          return false;
        }
      }
    }

    return true;
  }
}
