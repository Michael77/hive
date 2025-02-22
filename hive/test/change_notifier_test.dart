import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive/src/box/change_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StreamControllerMock<T> extends Mock implements StreamController<T> {}

void main() {
  group('ChangeNotifier', () {
    test('.watch()', () async {
      var notifier = ChangeNotifier();

      var allEvents = <BoxEvent>[];
      notifier.watch().listen((e) {
        allEvents.add(e);
      });

      var filteredEvents = <BoxEvent>[];
      notifier.watch(key: 'key1').listen((e) {
        filteredEvents.add(e);
      });

      notifier.notify('key1', null);
      notifier.notify('key1', 'newVal');
      notifier.notify('key2', 'newVal2');

      await Future.delayed(Duration(milliseconds: 1));

      expect(allEvents, [
        BoxEvent('key1', null),
        BoxEvent('key1', 'newVal'),
        BoxEvent('key2', 'newVal2'),
      ]);

      expect(filteredEvents, [
        BoxEvent('key1', null),
        BoxEvent('key1', 'newVal'),
      ]);
    });

    test('close', () async {
      var controller = StreamControllerMock<BoxEvent>();
      when(controller.close()).thenAnswer((i) => Future.value());
      var notifier = ChangeNotifier.debug(controller);

      await notifier.close();
      verify(controller.close());
    });
  });
}
