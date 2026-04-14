import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Trottle'**
  String get appName;

  /// No description provided for @txtLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get txtLoginTitle;

  /// No description provided for @txtLoginEmail.
  ///
  /// In fr, this message translates to:
  /// **'e-mail ou utilisateur'**
  String get txtLoginEmail;

  /// No description provided for @txtLoginEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'utilisateur@mail.com'**
  String get txtLoginEmailHint;

  /// No description provided for @txtLoginPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get txtLoginPassword;

  /// No description provided for @txtLoginPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'mot de passe'**
  String get txtLoginPasswordHint;

  /// No description provided for @txtLoginForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get txtLoginForgotPassword;

  /// No description provided for @txtLoginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get txtLoginButton;

  /// No description provided for @txtLoginOrContinueWith.
  ///
  /// In fr, this message translates to:
  /// **'ou continuer avec'**
  String get txtLoginOrContinueWith;

  /// No description provided for @txtLoginCreateAccount1.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get txtLoginCreateAccount1;

  /// No description provided for @txtLoginCreateAccount2.
  ///
  /// In fr, this message translates to:
  /// **'Créez-le gratuitement'**
  String get txtLoginCreateAccount2;

  /// No description provided for @txtForgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get txtForgotPasswordTitle;

  /// No description provided for @txtForgotPasswordEmail.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre e-mail'**
  String get txtForgotPasswordEmail;

  /// No description provided for @txtForgotPasswordEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Adresse@email.com'**
  String get txtForgotPasswordEmailHint;

  /// No description provided for @txtForgotPasswordButton.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get txtForgotPasswordButton;

  /// No description provided for @txtRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get txtRegisterTitle;

  /// No description provided for @txtRegisterEmail.
  ///
  /// In fr, this message translates to:
  /// **'e-mail'**
  String get txtRegisterEmail;

  /// No description provided for @txtRegisterEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Adresse@email.com'**
  String get txtRegisterEmailHint;

  /// No description provided for @txtRegisterPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get txtRegisterPassword;

  /// No description provided for @txtRegisterPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get txtRegisterPasswordHint;

  /// No description provided for @txtRegisterConfirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer votre mot de passe'**
  String get txtRegisterConfirmPassword;

  /// No description provided for @txtRegisterConfirmPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get txtRegisterConfirmPasswordHint;

  /// No description provided for @txtRegisterNextButton.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get txtRegisterNextButton;

  /// No description provided for @txtRegisterConnectWith.
  ///
  /// In fr, this message translates to:
  /// **'ou se connecter avec'**
  String get txtRegisterConnectWith;

  /// No description provided for @txtWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Trottle'**
  String get txtWelcomeTitle;

  /// No description provided for @txtWelcomePP.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil'**
  String get txtWelcomePP;

  /// No description provided for @txtWelcomePPHint.
  ///
  /// In fr, this message translates to:
  /// **'Charger votre image'**
  String get txtWelcomePPHint;

  /// No description provided for @txtWelcomePseudo.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo*'**
  String get txtWelcomePseudo;

  /// No description provided for @txtWelcomePseudoHint.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get txtWelcomePseudoHint;

  /// No description provided for @txtWelcomeInstagram.
  ///
  /// In fr, this message translates to:
  /// **'Instagram'**
  String get txtWelcomeInstagram;

  /// No description provided for @txtWelcomeInstagramHint.
  ///
  /// In fr, this message translates to:
  /// **'Instagram.com/'**
  String get txtWelcomeInstagramHint;

  /// No description provided for @txtWelcomeInstagramDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'Cette information est importante pour nous permettre de vous identifier !'**
  String get txtWelcomeInstagramDisclaimer;

  /// No description provided for @txtWelcomeInstagramInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi Instagram ?'**
  String get txtWelcomeInstagramInfoTitle;

  /// No description provided for @txtWelcomeInstagramInfoBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre profil Instagram nous permet de vérifier votre identité et d\'assurer la confiance au sein de la communauté Trottle. Vos informations restent confidentielles.'**
  String get txtWelcomeInstagramInfoBody;

  /// No description provided for @txtWelcomeBirth.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get txtWelcomeBirth;

  /// No description provided for @txtWelcomeBirthHint.
  ///
  /// In fr, this message translates to:
  /// **'JJ/MM/AAAA'**
  String get txtWelcomeBirthHint;

  /// No description provided for @txtWelcomeGender.
  ///
  /// In fr, this message translates to:
  /// **'Genre'**
  String get txtWelcomeGender;

  /// No description provided for @txtWelcomeGenderHint.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get txtWelcomeGenderHint;

  /// No description provided for @txtWelcomeGenderOpt0.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get txtWelcomeGenderOpt0;

  /// No description provided for @txtWelcomeGenderOpt1.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get txtWelcomeGenderOpt1;

  /// No description provided for @txtWelcomeGenderOpt2.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get txtWelcomeGenderOpt2;

  /// No description provided for @txtWelcomeProfil.
  ///
  /// In fr, this message translates to:
  /// **'Profil de Trottler'**
  String get txtWelcomeProfil;

  /// No description provided for @txtWelcomeProfilHint.
  ///
  /// In fr, this message translates to:
  /// **'Randonneur'**
  String get txtWelcomeProfilHint;

  /// No description provided for @txtWelcomeProfilOpt0.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get txtWelcomeProfilOpt0;

  /// No description provided for @txtWelcomeProfilOpt1.
  ///
  /// In fr, this message translates to:
  /// **'Randonneur'**
  String get txtWelcomeProfilOpt1;

  /// No description provided for @txtWelcomeProfilOpt2.
  ///
  /// In fr, this message translates to:
  /// **'Cycliste'**
  String get txtWelcomeProfilOpt2;

  /// No description provided for @txtWelcomeProfilOpt3.
  ///
  /// In fr, this message translates to:
  /// **'Motard'**
  String get txtWelcomeProfilOpt3;

  /// No description provided for @txtWelcomeCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get txtWelcomeCity;

  /// No description provided for @txtWelcomeSearch.
  ///
  /// In fr, this message translates to:
  /// **'Centres d\'intéret'**
  String get txtWelcomeSearch;

  /// No description provided for @txtWelcomeCreateButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get txtWelcomeCreateButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
