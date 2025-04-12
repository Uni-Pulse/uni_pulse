import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:uni_pulse/Models/acconts.dart';

import 'package:uni_pulse/Models/events.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super(const []);
  

  void addEvent(File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newEvent = Event(image: copiedImage);

    state = [newEvent, ...state];
  }
}

// <> used to add extra type annotation, knows what type it will be expecting
final eventsProvider =
    StateNotifierProvider<EventNotifier, List<Event>>(
  (ref) => EventNotifier(),
);


class AccountNotifier extends StateNotifier<List<AccountData>> {
  AccountNotifier() : super(const []);

  void addAccount(AccountData account) {
    state = [account, ...state];
  }
}
 final accountsProvider = 
    StateNotifierProvider<AccountNotifier, List<AccountData>>(
  (ref) => AccountNotifier(),
);