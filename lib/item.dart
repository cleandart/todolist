library item;

import 'package:react/react.dart';

var itemComponent = registerComponent(() => new ItemComponent());

class ItemComponent extends Component {
  get item => props['item'];
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
    return div({}, [input({'type': 'checkbox', 'onChange': onBoxChange}),
                    input({'value': text.value, 'onChange': onTextChange})]);
  }

  onTextChange (e) {
    text.value = e.target.value;
    redraw();

  }

  onBoxChange(e) {
    done.value = !done.value;
    redraw();
  }
}

var itemList = registerComponent(() => new ItemList());

class ItemList extends Component {
  get items => props['items'];

  List _renderItems() {
    return items.map((item) => itemComponent({'item': item})).toList();
  }

  render() {
    print(items);
    return div({}, _renderItems());
  }
}
