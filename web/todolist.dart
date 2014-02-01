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
