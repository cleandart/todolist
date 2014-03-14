library item;

import 'package:react/react.dart';
import 'package:clean_data/clean_data.dart';
import 'todolist.dart';
import 'dart:html';

var itemList = registerComponent(() => new TodoListComponent());

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  DataMap get item => props['item'];
  get text => item.ref('text');
  get done => item.ref('done');
  get addItem => props['add'];
  get removeItem => props['remove'];
  TodoListModel get todoList => props['todoList'];
  var _listener;

  ItemComponent();

  componentWillMount() {
    _listener = item.onChange.listen((_) => redraw());
  }

  componentWillUnmount() {
    _listener.cancel();
  }

  render() {
    return div({'draggable': 'true',
                'onDragStart': drag,
                'onDrop': drop,
                'onDragOver': allowDrop},
                [
                   input({'type': 'checkbox',
                          'checked': done.value,
                          'onChange': onBoxChange}),
                   span({'className': 'dnd'}, 'DND'),
                   input({'id': item['_id'],
                          'value': text.value,
                          'onChange': onTextChange,
                          'onFocus': onFocus,
                          'onKeyDown': onKeyPress}),
                   img({'onClick': (_) => todoList.remove(item),
                        'src': 'Remove-icon.png',
                        'vertical-align': 'middle',
                        'height': 25,
                        'width': 25})
                ]);
  }

  onTextChange (e) {
    text.value = e.target.value;
    redraw();
  }

  onKeyPress (e) {
    // enter keyCode = 13
    var keyCode = e.nativeEvent.keyCode;
    if (keyCode == 13) {
      todoList.add(createItem(), afterItem: item);
      todoList.selectNext(item);
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
    todoList.order.insert(position, other['_id']);
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
    todoList.focused.value = item['_id'];
  }
}


class TodoListComponent extends Component {

  TodoListModel get todoList => props['todoList'];
  var _listener;

  List _renderItems() {
    shouldVisible(item) => !todoList.showUncompleted.value || !item['done'];
    return todoList.sortedItems
        .map((DataMap item) => shouldVisible(item) ?
            itemComponent({'item': item,'todoList': todoList,})
            : null
         )
        .toList();
  }

  List _menu() {
    return [];
  }

  componentDidUpdate(_, __, ___) {
    var idFocused = todoList.focused.value;
    var focused = querySelector('#$idFocused');
    if (focused != null){
      focused.focus();
      (focused as InputElement).setSelectionRange(focused.value.length, focused.value.length);
    }
  }

  componentWillMount() {
    todoList.items.onChange.listen((_) => redraw());
    todoList.order.onChange.listen((_) => redraw());
    todoList.focused.onChange.listen((_) => redraw());
  }

  onBoxChange(e) {
    todoList.showUncompleted.value = !todoList.showUncompleted.value;
    redraw();
  }

  render() {
    var checkbox = div({}, [
       label({'htmlFor': 'showUncompleted'}, 'Show uncompleted only'),
       input({
        'id': 'showUncompleted',
        'type': 'checkbox',
        'checked': todoList.showUncompleted.value,
        'onChange': onBoxChange}, [])
    ]);
    var items = _renderItems();
    var body = [checkbox]..addAll(items);
    return div({}, body);
  }
}
