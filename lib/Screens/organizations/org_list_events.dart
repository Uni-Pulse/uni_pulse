import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/event_details.dart';
import 'package:uni_pulse/Screens/organizations/add_event.dart';
import 'package:uni_pulse/Widgets/event_card.dart';
import 'package:uni_pulse/Providers/events_provider.dart'; // Import the events provider
import 'package:uni_pulse/Models/events.dart';


  final appliedFiltersProvider =
      StateProvider<Map<String, dynamic>>((ref) => {});

  final searchQueryProvider = StateProvider<String>((ref) => '');


class OrgListEvents extends ConsumerWidget {
  const OrgListEvents({super.key});
  // Use a StateProvider to hold the applied filters

@override
Widget build(BuildContext context, WidgetRef ref) {
  // Get the logged-in user's email
  final currentUser = ref.watch(accountsProvider.notifier).currentUser;
  final eventsInfo = ref.watch(eventsProvider);

  // Filter events to show only those created by the logged-in organization
  final filteredEvents = eventsInfo.where((event) {
    return currentUser != null && event.organisation == currentUser.firstName;
  }).toList();

  const border = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
    borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
  );

  return SafeArea(
    child: Scaffold(
      background. Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final filtersApplied = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEventScreen(),
                ),
              );

              if (filtersApplied != null) {
                ref.read(appliedFiltersProvider.notifier).state = filtersApplied;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
          ),
          Expanded(
  child: ListView.builder(
    itemCount: filteredEvents.length, // Use filtered events here
    itemBuilder: (context, index) {
      if (_shouldDisplayProduct(filteredEvents[index], ref)) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return EventDetailsScreen(
                    event: filteredEvents[index],
                  );
                },
              ),
            );
          },
          child: Card(
            child: ListTile(
              title: Text(filteredEvents[index].eventName),
              subtitle: Text(
                'Date: ${filteredEvents[index].date.toLocal().toString().split(' ')[0]}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Event'),
                      content: const Text(
                          'Are you sure you want to delete this event?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(eventsProvider.notifier)
                        .deleteEvent(filteredEvents[index]); // Implement deleteEvent
                  }
                },
              ),
            ),
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
      appliedFilters['category'] != product) {
    return false;
  }

  // Price filter
  if (appliedFilters['price'] != null) {
    var priceRange = appliedFilters['price'];

    if (priceRange is Map &&
        priceRange['min'] != null &&
        priceRange['max'] != null) {
      double productPrice = double.tryParse(product.ticketPrice) ?? 0.0;

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
