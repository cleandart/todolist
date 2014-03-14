library TodoListModel;

import "package:clean_data/clean_data.dart";

createItem({text: '', done: false}) =>
    new DataMap.from({'text': text, 'done': done});

class TodoListModel {
  DataSet items;
  DataList order;
  DataReference focused;
  DataReference showUncompleted;

  TodoListModel(DataSet this.items, DataSet orderSet) {
    order = orderSet.first['order'];
    focused = new DataReference(this.items.first['_id']);
    showUncompleted = new DataReference(false);
  }

  /**
   * set focus to item next to [[item]]
   */
  selectNext(DataMap item) {
    int i = order.indexOf(item['_id']) + 1;
    if (i < order.length) focused.value = order[i];

  }

  /**
   * set focus to item previous to [[item]]
   */
  selectPrevious(DataMap item) {
    int i = order.indexOf(item['_id']) - 1;
    if (i >= 0) focused.value = order[i];
  }

  /**
   * adds item to the list; the position is either beginning of the list, or after
   * afterItem, if present.
   */
  add(DataMap item, {DataMap afterItem: null}) {
    var _order;
    if (afterItem == null) {
      _order = 0;
    } else {
      _order = order.indexOf(afterItem['_id']);
    }
    items.add(item);
    order.insert(_order + 1, item['_id']);
  }

  /**
   * remove [[item]] from list; handle sellection correctly
   */
  remove(DataMap item) {
    if (items.length == 1) return;
    if (item['_id'] == focused.value) selectPrevious(item);
    items.remove(item);
    order.remove(item['_id']);
  }

  /**
   * helper for obtaining items in the given order
   */
  List<DataMap> get sortedItems {
    List res = [];
    for (String id in order) {
      try{
        res.add(items.findBy('_id', id).first);
      } catch (e){};
    }
    return res;
  }
}
