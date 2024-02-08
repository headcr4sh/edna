import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path;

Directory journalPath() {
  final String edJournalPath;
  final ednaJournalDirEnv = Platform.environment['EDNA_JOURNAL_DIR'];
  final edJournalDirEnv = Platform.environment['ED_JOURNAL_DIR'];
  if (ednaJournalDirEnv != null) {
    edJournalPath = ednaJournalDirEnv;
  } else if (edJournalDirEnv != null) {
    edJournalPath = edJournalDirEnv;
  } else if (Platform.isWindows) {
    final userHomePath = Platform.environment['USERPROFILE'];
    if (userHomePath == null || userHomePath.isEmpty) {
      throw Exception('Variable %USERPROFILE% has not been set');
    }
    edJournalPath = path.join(userHomePath, 'Saved Games', 'Frontier Developments', 'Elite Dangerous');
  } else if (Platform.isLinux) {
    final userHomePath = Platform.environment['HOME'];
    if (userHomePath == null || userHomePath.isEmpty) {
      throw Exception('Variable \$HOME has not been set');
    }
    edJournalPath = path.joinAll([userHomePath, '.local', 'share', 'Steam', 'steamapps', 'compatdata', '359320', 'pfx', 'drive_c', 'users', 'steamuser' ,'Saved Games', 'Frontier Developments', 'Elite Dangerous']);
  } else {
    throw Exception('Player journal default path cannot be determined');
  }
  return Directory(edJournalPath);
}
