library item;

import 'package:react/react.dart';
import 'package:clean_data/clean_data.dart';
import 'todolist.dart';

var itemList = registerComponent(() => new ItemList());

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  DataSet get items => props['items'];
  DataMap get item => props['item'];
  get text => item.ref('text');
  get done => item.ref('done');
  get order => item['order'];
  get addItem => props['add'];
  get removeItem => props['remove'];
  var _listener;

  ItemComponent();

  componentWillMount() {
    _listener = item.onChange.listen((_) => redraw());
  }

  componentWillUnmount() {
    _listener.cancel();
  }

  render() {
    return div({'draggable': 'true', 'onDragStart': drag, 'onDrop': drop,
                'onDragOver': allowDrop},
               [input({'type': 'checkbox', 'checked': done.value,
                       'onChange': onBoxChange}),
                span({'className': 'dnd'}, 'DND'),
                input({'value': text.value, 'onChange': onTextChange,
                       'onKeyDown': onKeyPress}),
                img({'onClick': (_) => removeItem(item),
                     'src': 'Remove-icon.png',
                     'vertical-align': 'middle', 'height': 25, 'width': 25})]);
  }

  onTextChange (e) {
    text.value = e.target.value;
    redraw();
  }

  onKeyPress (e) {
    // enter keyCode = 13
    // backspace keyCode = 9
    var keyCode = e.nativeEvent.keyCode;
    if (keyCode == 13) {
      addItem(order);
    }
    else if (keyCode == 8 && text.value == '') {
      removeItem(item);
    }
  }

  allowDrop(ev) {
    ev.nativeEvent.preventDefault();
  }

  drop(ev){
    ev.nativeEvent.preventDefault();
    var id = ev.nativeEvent.dataTransfer.getData("id");
    DataMap other = items.findBy('_id', id).first;
    other['order'] = item['order']-0.1;
  }

  drag(ev){
    ev.nativeEvent.dataTransfer.setData("id", item['_id']);
    print('drag: ${ev.nativeEvent}');
  }

  onBoxChange(e) {
    done.value = !done.value;
    print(e);
    redraw();
  }
}


class ItemList extends Component {

  TodoList get todoList => props['todoList'];
  var _listener;

  List _renderItems() {
    return todoList.sortedItems
        .map((item) => itemComponent({'item': item,
                                      'add': todoList.add,
                                      'remove': todoList.remove}))
        .toList();
  }

  componentWillMount() {
    todoList.items.onChange.listen((_) => redraw());
  }

  render() {
    print('rendering intems');
    return div({}, _renderItems());
  }
}
