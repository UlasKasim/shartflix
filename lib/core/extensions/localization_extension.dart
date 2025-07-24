import 'package:flutter/material.dart';
import 'package:shartflix/l10n/l10n.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
