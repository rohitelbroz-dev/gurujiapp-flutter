import 'package:guruji/core/localization/app_strings.dart';
void main() {
  final hiKeys = AppStrings.localizedValues['hi']?.keys.toSet() ?? {};
  final enKeys = AppStrings.localizedValues['en']?.keys.toSet() ?? {};
  final mrKeys = AppStrings.localizedValues['mr']?.keys.toSet() ?? {};
  final guKeys = AppStrings.localizedValues['gu']?.keys.toSet() ?? {};
  final taKeys = AppStrings.localizedValues['ta']?.keys.toSet() ?? {};
  final teKeys = AppStrings.localizedValues['te']?.keys.toSet() ?? {};

  print('Total keys in hi: ');
  print('Total keys in en: ');
  print('Total keys in mr: ');
  print('Total keys in gu: ');
  print('Total keys in ta: ');
  print('Total keys in te: ');

  final allKeys = {...hiKeys, ...enKeys};
  print('Missing in MR: ');
  print('Missing in GU: ');
  print('Missing in TA: ');
  print('Missing in TE: ');
}
