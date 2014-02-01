library todolist;

import "package:clean_data/clean_data.dart";

createItem({text: '', done: false, order: 100}) =>
    new DataMap.from({'text': text, 'done': done, 'order': order});

class TodoList {
  DataSet items;
  var focused;

  TodoList(this.items) {
    if (items.isEmpty) {
      items.add(createItem);
    }
    focused = sortedItems.last;
//    int order = 0;
//    for (DataMap i in items){
//      if (!i.containsKey('order') || true){
//        print('adding order');
//        i['order'] = order++;
//      }
//    }
  }

  selectNext(item) {
    print('selecting next of $item');

  }

  selectPrevious(item) {
    print('selecting previous of $item');

  }

  add(order) {
    var _item = createItem();
    items.add(_item);
    insert(order, _item, after: true);
    focused = _item;
  }

  remove(item) {
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
