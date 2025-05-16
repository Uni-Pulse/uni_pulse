import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/event_details.dart';
import 'package:uni_pulse/Widgets/event_card.dart';
import 'package:uni_pulse/Widgets/filters.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:uni_pulse/Models/events.dart';

// State provider to store applied filters (category, price range)
final appliedFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// State provider to store the search query
final searchQueryProvider = StateProvider<String>((ref) => '');

class ListEvents extends ConsumerWidget {
  const ListEvents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the list of events from the provider
    final eventsInfo = ref.watch(eventsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Events', style: Theme.of(context).textTheme.titleLarge),
          actions: [
            // Filter button in the app bar
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                // Open the FilterPage and wait for the result
                final filtersApplied = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
                );

                // If filters were applied, update the state
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
            // Search input field
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
                  // Update the search query state on change
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),
            ),

            // List of filtered events
            Expanded(
              child: ListView.builder(
                itemCount: eventsInfo.length, // Total number of events
                itemBuilder: (context, index) {
                  // Check if the current event should be displayed based on filters
                  if (_shouldDisplayProduct(eventsInfo[index], ref)) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to event details screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              event: eventsInfo[index],
                            ),
                          ),
                        );
                      },
                      // Display event card with alternating background colors
                      child: EventCard(
                        eventname: eventsInfo[index].eventName,
                        ticketPrice:
                            double.parse(eventsInfo[index].ticketPrice),
                        date: eventsInfo[index].date,
                        backgroundColor: index.isEven
                            ? const Color.fromARGB(255, 175, 126, 180)
                            : const Color.fromARGB(255, 130, 78, 143),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // Don't show filtered-out events
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine if an event passes the current filters and search
  bool _shouldDisplayProduct(EventData product, WidgetRef ref) {
    final appliedFilters = ref.watch(appliedFiltersProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    // Search filter: check if the event name contains the search query
    if (searchQuery.isNotEmpty &&
        !product.eventName.toLowerCase().contains(searchQuery)) {
      return false;
    }

    // Category filter: check if event type matches selected category
    if (appliedFilters['category'] != null &&
        appliedFilters['category'] !=
            product.eventType.toString().split('.').last) {
      return false;
    }

    // Price filter: check if the event price falls within the selected range
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

    return true; // Display event if all filters pass
  }
}
