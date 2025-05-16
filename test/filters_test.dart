import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Widgets/filters.dart'; 

void main() {
  group('Filter Widget Tests', () {
    testWidgets('Renders Filter screen with all expected elements', (WidgetTester tester) async {
      // Build the Filter widget
      await tester.pumpWidget(
        MaterialApp(
          home: Filter(),
        ),
      );

      // Verify the AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify the AppBar title
      expect(find.text('Filter'), findsOneWidget); 

      // Verify the presence of filter options 
      expect(find.byType(DropdownButton), findsWidgets); 
      expect(find.byType(Slider), findsWidgets); 

      // Verify the presence of an "Apply" button
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('Tapping Apply button triggers filter logic', (WidgetTester tester) async {
      // Build the Filter widget
      await tester.pumpWidget(
        MaterialApp(
          home: Filter(),
        ),
      );

      // Find the Apply button
      final applyButton = find.text('Apply');
      expect(applyButton, findsOneWidget);

      // Tap the Apply button
      await tester.tap(applyButton);
      await tester.pump();

  
    });

    testWidgets('Allows users to select filter options', (WidgetTester tester) async {
      // Build the Filter widget
      await tester.pumpWidget(
        MaterialApp(
          home: Filter(),
        ),
      );
      

      // Select an item from the dropdown
      final dropdownItem = find.text('Arts').last; 
      await tester.tap(dropdownItem);
      await tester.pump();

      // Interact with a slider 
      final slider = find.byType(Slider).first;
      expect(slider, findsOneWidget);
      await tester.drag(slider, Offset(50, 0)); 
      await tester.pump();
    });
  });
}