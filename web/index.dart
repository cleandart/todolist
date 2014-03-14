import 'dart:html';
import 'dart:async';
import "package:clean_sync/client.dart";
import "package:clean_ajax/client_browser.dart";
import 'package:logging/logging.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:todolist/components.dart';
import 'package:todolist/todolist.dart';
import 'package:useful/useful.dart';
import 'package:clean_data/clean_data.dart';

/**
 * Do not run this using DartEditor Launcher! It will not work due to same
 * origin policy. What to do: run dartium and follow this link:
 * http://0.0.0.0:8080/static/index.html
 */


void main() {
  setClientConfiguration();
  Subscription items;
  Subscription order;
  DataSet itemsCol, orderCol;

  hierarchicalLoggingEnabled = true;
  setupDefaultLogHandler();

  // initialization of these Subscriptions
  Connection connection = createHttpConnection("http://0.0.0.0:8080/resources/",
      new Duration(milliseconds: 200));

  Subscriber subscriber = new Subscriber(connection);
  subscriber.init().then((_) {
    items = subscriber.subscribe("item");
    itemsCol = items.collection;
    order = subscriber.subscribe("order");
    orderCol = order.collection;

    Subscription.wait([items, order]).then((_){
      if (orderCol.isEmpty) {
        DataMap item = createItem();
        itemsCol.add(item);
        print(item);
        orderCol.add({'order': [item['_id']]});
        print(itemsCol);
        print(orderCol);
      }

      var todoList = new TodoListModel(items.collection, order.collection);
      renderComponent(itemList({'todoList': todoList}), querySelector('body'));
    });
  });
}
