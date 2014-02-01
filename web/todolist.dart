import 'dart:html';
import 'dart:async';
import "package:clean_data/clean_data.dart";
import "package:clean_sync/client.dart";
import "package:clean_ajax/client_browser.dart";
import 'package:logging/logging.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:todolist/item.dart';

/**
 * Do not run this using DartEditor Launcher! It will not work due to same
 * origin policy. What to do: run dartium and follow this link:
 * http://0.0.0.0:8080/static/todolist.html
 */


void main() {
  setClientConfiguration();
  DataSet items;

  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.message}');
  });

  // initialization of these Subscriptions
  Connection connection = createHttpConnection("http://0.0.0.0:8080/resources/",
      new Duration(milliseconds: 100));

  Subscriber subscriber = new Subscriber(connection);
  subscriber.init().then((_) {
    items = subscriber.subscribe("item").collection;
    items.add({'text': 'ahoj', 'done': true});
    items.add({'text': 'cau', 'done': false});
    renderComponent(itemList({'items': items}), querySelector('body'));
    items.onChange.listen((_){

    });
  });
}
