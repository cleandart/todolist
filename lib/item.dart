library item;

import 'package:react/react.dart';

var item = registerComponent(() => new Item());

class Item extends Component {

  render() {
    return div({}, ['Hello world!']);
  }
}
