library todolist;

import "package:clean_data/clean_data.dart";

createItem({text: '', done: false}) =>
    new DataMap.from({'text': text, 'done': done});

class TodoList {
  DataSet items;
  DataList order;
  TodoList(DataSet this.items, DataSet orderSet) {
    if (items.isEmpty) {
      items.add(createItem);
    }
    if (orderSet.isEmpty) {
      order = new DataList();
      orderSet.add({'order': order});
    } else {
      order = orderSet.first['order'];
    }
//    order.clear();
    for(DataMap item in items){
      if (!order.contains(item['_id'])){
        order.add(item['_id']);
      }
    }
  }

  add(item) {
    var ord = order.indexOf(item['_id']);
    print('adding item to position $ord');
    var _item = createItem();
    items.add(_item);
    insert(ord, _item, after: true);
  }

  remove(item) {
    items.remove(item);
    order.remove(item['_id']);
  }

  insert(num ord, item, {after: false}) {
    if (after) {
      ord++;
    }
    order.insert(ord, item['_id']);
  }

  get sortedItems {
    print('order: $order');
    List res = [];
    for (String id in order) {
      try{
        res.add(items.findBy('_id', id).first);
      } catch (e){};
    }
    print('res: $res');
    return res;
  }

}
