library item;

import 'package:react/react.dart';
import 'package:clean_data/clean_data.dart';

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  DataSet get items => props['items'];
  DataMap get item => props['item'];
  get text => item.ref('text');
  get done => item.ref('done');
  var _listener;

  componentWillMount() {
    _listener = item.onChange.listen((_) => redraw());
  }

  componentWillUnmount() {
    _listener.cancel();
  }

  render() {
    return div({'draggable': 'true', 'onDragStart': drag, 'onDrop': drop, 'onDragOver': allowDrop },
                    [input({'type': 'checkbox', 'checked': done.value, 'onChange': onBoxChange}),
                    span({'className': 'dnd'}, 'DND'),
                    input({'value': text.value, 'onChange': onTextChange})]);
  }

  onTextChange (e) {
    text.value = e.target.value;
    redraw();
  }

  allowDrop(ev) {
    ev.nativeEvent.preventDefault();
  }

  drop(ev){
    ev.nativeEvent.preventDefault();
    print('drop: ${ev.nativeEvent}');
    var id = ev.nativeEvent.dataTransfer.getData("id");
    DataMap other = items.findBy('_id', id).first;
    other['order'] = item['order']-0.1;
    print('item: $item');
    print('other: $other');
  }

  drag(ev){
    ev.nativeEvent.dataTransfer.setData("id",item['_id']);
    print('drag: ${ev.nativeEvent}');
  }

  onBoxChange(e) {
    done.value = !done.value;
    redraw();
  }
}

var itemList = registerComponent(() => new ItemList());

class ItemList extends Component {
  DataSet get items => props['items'];

  var _listener;


  List _renderItems() {
    num order = 0;
    for (DataMap d in items){
      if (!d.containsKey('order')){
        print('adding order');
        d['order'] = order++;
      }
    }
    var sorted = items.liveSortByKey((d) => d['order']);
    return sorted.map((item) => itemComponent({'item': item, 'items': items})).toList();
  }

  componentWillMount() {
    items.onChange.listen((_) => redraw());
  }

  render() {
    print('rendering intems');
    return div({}, _renderItems());
  }

}
