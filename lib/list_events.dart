import 'package:flutter/material.dart';
import 'package:uni_pulse/global_variables.dart'; // Import global_variables.dart
import 'package:uni_pulse/event_card.dart';
import 'package:uni_pulse/event_details_page.dart';
import 'package:uni_pulse/filters.dart';

class ListEvents extends StatefulWidget {
  const ListEvents({super.key});

  @override
  State<ListEvents> createState() => _ProductListState();
}

class _ProductListState extends State<ListEvents> {
  // Declare a variable to hold the applied filters
  Map<String, dynamic> appliedFilters = {};

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final filtersApplied = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
                );

                if (filtersApplied != null) {
                  setState(() {
                    appliedFilters = filtersApplied;
                  });
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length, // Using global products here
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (_shouldDisplayProduct(product)) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EventDetailsPage(product: product);
                            },
                          ),
                        );
                      },
                      child: EventCard(
                        eventname: product['eventName'] as String,
                        ticketPrice: (product['ticketPrice'] ?? 0.0) as double,
                        image: product['imageUrl'] as String,
                        date: product['date'] as String,
                        backgroundColor:
                            index.isEven
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

  bool _shouldDisplayProduct(Map<String, dynamic> product) {
    if (appliedFilters.isEmpty) {
      return true;
    }

    if (appliedFilters['category'] != null &&
        appliedFilters['category'] != product['category']) {
      return false;
    }

    if (appliedFilters['price'] != null) {
      var priceRange = appliedFilters['price'];

      if (priceRange is Map &&
          priceRange['min'] != null &&
          priceRange['max'] != null) {
        double productPrice = product['ticketPrice'] as double;

        // Use default values if priceRange is incomplete
        double minPrice = priceRange['min'] ?? 0.0;
        double maxPrice = priceRange['max'] ?? 50.0;

        if (productPrice < minPrice || productPrice > maxPrice) {
          return false; // Filter by price range
        }
      }
    }

    return true;
  }
}
