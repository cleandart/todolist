import 'dart:html';
import 'dart:async';
import "package:clean_data/clean_data.dart";
import "package:clean_sync/client.dart";
import "package:clean_ajax/client_browser.dart";
import 'package:logging/logging.dart';

/**
 * Do not run this using DartEditor Launcher! It will not work due to same
 * origin policy. What to do: run dartium and follow this link:
 * http://0.0.0.0:8080/static/simple_example_client.html
 */

LIElement createListElement(person, persons) {
  LIElement li = new LIElement()
  ..className = "_id-${person["_id"]}"
  ..text = "#${person["_id"]} ${person["name"]} (${person["age"]})"
  ..dataset["_id"] = person["_id"]
  ..onClick.listen((MouseEvent event) {
    LIElement e = event.toElement;
    String _id = e.dataset["_id"];
    DataMap pers = persons.collection.firstWhere((d) => d["_id"] == _id);

    if (pers != null) {
      persons.collection.remove(pers);
    }
  });
  return li;
}

draw(DataSet todos){
  var s=[];
  s.add("<div> hello world</div>");
  s.add('<div class = "todolist">');
  todos.forEach((todo){
    s.add('<div> ${todo["text"]} </div>');
  });
  s.add("</div>");
  s.add('<input type="button" id="send"> send </input>');
  s.add('<input type="text" id="text"> </input>');
  return s.join();
}

render(DataSet todos){
  var s = draw(todos);
  DivElement elem = querySelector('#main');
  elem.innerHtml = s;

  querySelector('#send').onClick.listen((_) {
    InputElement text = querySelector("#text");
    todos.add({'text': text.value, 'completed': 'false'});
    print('adding ${text.value}');
  });

}

void main() {
  DataSet todos, completed;

  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.message}');
  });

  // initialization of these Subscriptions
  Connection connection = createHttpConnection("http://0.0.0.0:8080/resources/",
      new Duration(milliseconds: 100));
  print('tututu');

  Subscriber subscriber = new Subscriber(connection);
  subscriber.init().then((_) {
    todos = subscriber.subscribe("todos").collection;
    completed = subscriber.subscribe("completed").collection;
    render(todos);
    todos.onChange.listen((_){
      render(todos);
    });
  });
}
