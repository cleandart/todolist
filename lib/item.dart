library item;

import 'package:react/react.dart';
import 'package:clean_data/clean_data.dart';
import 'todolist.dart';
import 'dart:html';

var itemList = registerComponent(() => new ItemList());

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  DataMap get item => props['item'];
  get text => item.ref('text');
  get done => item.ref('done');
  get addItem => props['add'];
  get removeItem => props['remove'];
  TodoList get todoList => props['todoList'];
  var _listener;

  ItemComponent();

  componentWillMount() {
    _listener = item.onChange.listen((_) => redraw());
  }

  componentWillUnmount() {
    _listener.cancel();
  }

  render() {
    var _input = input({'id': item['_id'], 'value': text.value,
                        'onChange': onTextChange, 'onFocus': onFocus,
                        'onKeyDown': onKeyPress});
    return div({'draggable': 'true', 'onDragStart': drag, 'onDrop': drop,
                'onDragOver': allowDrop},
               [input({'type': 'checkbox', 'checked': done.value,
                       'onChange': onBoxChange}),
                span({'className': 'dnd'}, 'DND'),
                _input,
                img({'onClick': (_) => todoList.remove(item),
                     'src': 'Remove-icon.png',
                     'vertical-align': 'middle', 'height': 25, 'width': 25})]);
  }

  onTextChange (e) {
    text.value = e.target.value;
    redraw();
  }

  onKeyPress (e) {
    // enter keyCode = 13
    var keyCode = e.nativeEvent.keyCode;
    if (keyCode == 13) {
      todoList.add(item);
    }
    // backspace keyCode = 8
    if (keyCode == 8 && text.value == '') {
      todoList.remove(item);
    }
    // arrow down keyCode = 40
    if (keyCode == 40) {
      todoList.selectNext(item);
    }
    // arrow up keyCode = 38
    if (keyCode == 38) {
      todoList.selectPrevious(item);
    }
  }

  allowDrop(ev) {
    ev.nativeEvent.preventDefault();
  }

  drop(ev){
    ev.nativeEvent.preventDefault();
    var id = ev.nativeEvent.dataTransfer.getData("id");
    DataMap other = todoList.items.findBy('_id', id).first;
    num position = todoList.order.indexOf(item['_id']);
    todoList.order.remove(other['_id']);
    todoList.insert(position, other);
  }

  drag(ev){
    ev.nativeEvent.dataTransfer.setData("id", item['_id']);
    print('drag: ${ev.nativeEvent}');
  }

  onBoxChange(e) {
    done.value = !done.value;
    redraw();
  }

  onFocus(e) {
    todoList.focused['focused'] = item;
  }
}


class ItemList extends Component {

  TodoList get todoList => props['todoList'];
  var _listener;

  List _renderItems() {
    return todoList.sortedItems
        .map((DataMap item) => itemComponent({'item': item,
                                      'todoList': todoList,
                                     }))
        .toList();
  }

  componentDidUpdate(_, __, ___) {
    var idFocused = todoList.focused['focused']['_id'];
    var focused = querySelector('#$idFocused');
    if (focused != null) focused.focus();
  }

  componentWillMount() {
    todoList.items.onChange.listen((_) => redraw());
    todoList.order.onChange.listen((_) => redraw());
    todoList.focused.onChange.listen((_) => redraw());
  }

  render() {
    return div({}, _renderItems());
  }
}
