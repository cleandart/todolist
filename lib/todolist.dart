library todolist;

import "package:clean_data/clean_data.dart";
import 'dart:html';


createItem({text: '', done: false}) =>
    new DataMap.from({'text': text, 'done': done});

class TodoList {
  DataSet items;
  DataList order;
  DataReference focused;

  TodoList(DataSet this.items, DataSet orderSet) {
    if (orderSet.isEmpty) {
      order = new DataList();
      orderSet.add({'order': order});
    } else {
      order = orderSet.first['order'];
    }
    if (items.isEmpty) {
      //items.add(createItem);
      var _order = 0;
      var _item = createItem();
      items.add(_item);
      insert(_order, _item, after: true);
    }
    // order.clear();
    for(DataMap item in items){
      if (!order.contains(item['_id'])){
        order.add(item['_id']);
      }
    }
    focused = new DataReference(this.items.first['_id']);
  }



  selectNext(item) {
    int i = sortedItems.indexOf(item) + 1;
    print('i: $i');
    if (i < sortedItems.length) focused.value = sortedItems[i]['_id'];

  }

  selectPrevious(item) {
    int i = sortedItems.indexOf(item) - 1;
    if (i >= 0) focused.value = sortedItems[i]['_id'];
  }

  add(item) {
    var _order = order.indexOf(item['_id']);
    var _item = createItem();
    items.add(_item);
    insert(_order, _item, after: true);
    focused.value = _item['_id'];
  }

  remove(item) {
    if (items.length == 1) return;
    if (item['_id'] == focused.value) selectPrevious(item);
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
