library todolist;

import "package:clean_data/clean_data.dart";


class TodoList {
  DataSet items;
  TodoList(this.items) {
    num order = 0;
    for (DataMap d in items){
      if (!d.containsKey('order')){
        print('adding order');
        d['order'] = order++;
      }
    }
  }

  add(position) {
    print('adding item to position $position');
    var _item = new DataMap.from({'text': '', 'done': false});
  }

  remove(item) {
    print('removing item $item');
    items.remove(item);
  }

  get sortedItems => items.liveSortByKey((d) => d['order']);
}
