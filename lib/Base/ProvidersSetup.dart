import 'package:get_it/get_it.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [...indepenedet, ...dependent, ...ui];

List<SingleChildWidget> indepenedet = [
  ChangeNotifierProvider(create: (_) => GetIt.I<AuthService>()),
];
List<SingleChildWidget> dependent = [];
List<SingleChildWidget> ui = [];


setUpSingeltons() {
  GetIt.I.registerSingleton<AuthService>(AuthService());
}
