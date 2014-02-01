library todolist;

import "package:clean_data/clean_data.dart";


class TodoList {
  DataSet items;
  TodoList(this.items) {
    num order = 0;
    for (DataMap i in items){
      if (!i.containsKey('order')){
        print('adding order');
        i['order'] = order++;
      }
    }
    print(items);
  }

  add(position) {
    print('adding item to position $position');
    var _item = new DataMap.from({'text': '', 'done': false});
  }

  remove(item) {
    print('removing item $item');
    items.remove(item);
  }

  //TODO
  reorder(dragId, dropId) {

  }

  get sortedItems => items.liveSortByKey((d) => d['order']);
}
