// utils/app_localizations.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  Map<String, String> _localizedStrings = {};
  
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    
    return true;
  }
  
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
  
  // Helper method untuk akses yang lebih mudah
  String get profile => translate('profile');
  String get userProfile => translate('user_profile');
  String get appointment => translate('appointment');
  String get jecPoints => translate('jec_points');
  String get patientList => translate('patient_list');
  String get deleteAccount => translate('delete_account');
  String get logout => translate('logout');
  String get confirmLogout => translate('confirm_logout');
  String get logoutMessage => translate('logout_message');
  String get cancel => translate('cancel');
  String get exit => translate('exit');
  String get memberStatus => translate('member_status');
  String get silver => translate('silver');
  String get points => translate('points');
  String get joinedDate => translate('joined_date');
  String get managePersonalInfo => translate('manage_personal_info');
  String get scheduleConsultation => translate('schedule_consultation');
  String get viewPointsAndRewards => translate('view_points_and_rewards');
  String get managePatientData => translate('manage_patient_data');
  String get deletePermanentAccount => translate('delete_permanent_account');
  String get exitFromApp => translate('exit_from_app');
  String get termsConditions => translate('terms_conditions');
  String get appVersion => translate('app_version');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['id', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}