library todolist;

import "package:clean_data/clean_data.dart";


class TodoList {
  DataSet items;
  TodoList(this.items);

  add(position) {
    print('adding item to position $position');
    var _item = new DataMap.from({'text': '', 'done': false});
  }

  remove(item) {
    print('removing item $item');
    items.remove(item);
  }
}
