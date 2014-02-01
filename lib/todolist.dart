library todolist;

import "package:clean_data/clean_data.dart";


class TodoList {
  DataSet items;
  TodoList(this.items) {
    int order = 0;
    for (DataMap i in items){
      if (!i.containsKey('order') || true){
        print('adding order');
        i['order'] = order++;
      }
    }
    print(items);
  }

  add(position) {
    print('adding item to position $position');
    var _item = new DataMap.from({'text': '', 'done': false});
    items.add(_item);
    insert(position, _item);
  }

  remove(item) {
    print('removing item $item');
    items.remove(item);
  }

  insert(order, item, {after: false}) {
    if (after) {
      order++;
    }
    DataMap next;
    try {
      next = items.findBy('order', order).first;
    } catch (e){
    }
    item['order'] = order;
    if (next!=null){
      insert(order+1, next);
    }
  }

  get sortedItems => items.liveSortByKey((d) => d['order']);
}
