/*import 'package:frideos/frideos.dart';
import 'package:frideos_core/frideos_core.dart';


class UserDataBloc {

  static final UserDataBloc _userDataBloc = UserDataBloc._internal();

  var firstName = StreamedValue<String>();
  var lastName = StreamedValue<String>();

  factory UserDataBloc() {
    return _userDataBloc;
  }

  UserDataBloc._internal() {
    firstName.value = '';
    lastName.value = '';
  }

  dispose() {
    print('Disposing bloc');
    firstName.dispose();
    lastName.dispose();
  }
}

final userDataBloc = UserDataBloc();

*/