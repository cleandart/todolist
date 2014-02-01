library item;

import 'package:react/react.dart';

var itemList = registerComponent(() => new ItemList());

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  get item => props['item'];
  get text => item.ref('text');
  get done => item.ref('done');
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
    return div({}, [input({'type': 'checkbox', 'checked': done.value,
                           'onChange': onBoxChange}),
                    input({'value': text.value, 'onChange': onTextChange,
                           'onKeyDown': onKeyPress})]);
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
      addItem(1);
    }
    else if (keyCode == 8 && text.value == '') {
      removeItem(item);
    }
  }

  onBoxChange(e) {
    done.value = !done.value;
    print(e);
    redraw();
  }
}

class ItemList extends Component {
  get todoList => props['todoList'];

  List _renderItems() {
    return todoList.items
        .map((item) => itemComponent({'item': item,
                                      'add': todoList.add,
                                      'remove': todoList.remove}))
        .toList();
  }

  componentWillMount() {
    todoList.items.onChange.listen((_) => redraw());
  }

  render() {
    return div({}, _renderItems());
  }
}
