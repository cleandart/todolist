library todolist;

import "package:clean_data/clean_data.dart";

createItem({text: '', done: false}) =>
    new DataMap.from({'text': text, 'done': done});

class TodoList {
  DataSet items;
  DataList order;
  DataMap focused;

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
    // order.clear();
    for(DataMap item in items){
      if (!order.contains(item['_id'])){
        order.add(item['_id']);
      }
    }
    focused = new DataMap.from({'focused': sortedItems.last});
  }


  selectNext(item) {
    int i = sortedItems.indexOf(item) + 1;
    if (i <= sortedItems.length) focused['focused'] = sortedItems[i];

  }

  selectPrevious(item) {
    int i = sortedItems.indexOf(item) - 1;
    if (i >= 0) focused['focused'] = sortedItems[i];
  }

  add(item) {
    var _order = order.indexOf(item['_id']);
    var _item = createItem();
    items.add(_item);
    insert(_order, _item, after: true);
    focused['focused'] = _item;
  }

  remove(item) {
    selectPrevious(item);
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
    List res = [];
    for (String id in order) {
      try{
        res.add(items.findBy('_id', id).first);
      } catch (e){};
    }
    return res;
  }
}
