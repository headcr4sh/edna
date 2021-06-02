import 'package:args/args.dart';

import './app_mode.dart';

/// Arguments (usually passed via command line args ore environments variables)
/// to alter the behavior of E.D.N.A.
class EdnaAppInitArguments {
  final EdnaAppMode _mode;
  final bool _showGui;

  EdnaAppMode get mode => _mode == EdnaAppMode.auto ? defaultAppMode : _mode;

  bool get showGui => _showGui;

  EdnaAppInitArguments({required EdnaAppMode mode, required bool showGui})
      : _mode = mode,
        _showGui = showGui;

  factory EdnaAppInitArguments.assemble(final Iterable<String> args) =>
      EdnaAppInitArguments.fromCommandLineArguments(args,
          base: EdnaAppInitArguments.fromEnv());

  factory EdnaAppInitArguments.defaults() =>
      EdnaAppInitArguments(mode: EdnaAppMode.auto, showGui: true);

  factory EdnaAppInitArguments.fromCommandLineArguments(
      final Iterable<String> args,
      {EdnaAppInitArguments? base}) {
    final baseOrDefault = base ?? EdnaAppInitArguments.defaults();
    final parser = ArgParser(allowTrailingOptions: false);
    parser.addFlag('no-gui', abbr: 'n', defaultsTo: !baseOrDefault.showGui);
    parser.addOption('mode',
        abbr: 'm',
        allowed: EdnaAppMode.values.map((e) => e.toString()),
        defaultsTo: baseOrDefault.mode.toString());

    final result = parser.parse(args);

    final showGui = !result['no-gui'];
    final mode = EdnaAppMode.values.firstWhere(
            (e) => e.toString() == result['mode'],
        orElse: () => EdnaAppMode.auto);

    return EdnaAppInitArguments(mode: mode, showGui: showGui);
  }

  factory EdnaAppInitArguments.fromEnv({EdnaAppInitArguments? base}) {
    final baseOrDefault = base ?? EdnaAppInitArguments.defaults();
    return EdnaAppInitArguments(
        mode: bool.hasEnvironment('EDNA_MODE')
            ? EdnaAppMode.values.firstWhere(
                (e) => e.toString() == String.fromEnvironment('EDNA_MODE'),
            orElse: () => baseOrDefault.mode)
            : baseOrDefault.mode,
        showGui: bool.hasEnvironment('EDNA_NO_GUI')
            ? !bool.fromEnvironment('EDNA_NO_GUI')
            : baseOrDefault.showGui);
  }
}
