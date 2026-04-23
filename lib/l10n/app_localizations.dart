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
  /// **'utilisateur@mail.com'**
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

  /// No description provided for @txtSearch.
  ///
  /// In fr, this message translates to:
  /// **'Recherche par mot clé'**
  String get txtSearch;

  /// No description provided for @txtSearchReco.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations'**
  String get txtSearchReco;

  /// No description provided for @txtSearchOptions.
  ///
  /// In fr, this message translates to:
  /// **'+ Plus d’options'**
  String get txtSearchOptions;

  /// No description provided for @txtSearchLast.
  ///
  /// In fr, this message translates to:
  /// **'⏱️ Ajoutés récemment'**
  String get txtSearchLast;

  /// No description provided for @txtSearchRoute.
  ///
  /// In fr, this message translates to:
  /// **'Parcours'**
  String get txtSearchRoute;

  /// No description provided for @txtSearchAroundMe.
  ///
  /// In fr, this message translates to:
  /// **'Autour de moi'**
  String get txtSearchAroundMe;

  /// No description provided for @txtSearchCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get txtSearchCity;

  /// No description provided for @txtSearchWorld.
  ///
  /// In fr, this message translates to:
  /// **'Monde entier'**
  String get txtSearchWorld;

  /// No description provided for @txtProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get txtProfile;

  /// No description provided for @txtProfileUser.
  ///
  /// In fr, this message translates to:
  /// **'P.H.'**
  String get txtProfileUser;

  /// No description provided for @txtProfileMenu.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get txtProfileMenu;

  /// No description provided for @txtProfilePictures.
  ///
  /// In fr, this message translates to:
  /// **'Mes photos'**
  String get txtProfilePictures;

  /// No description provided for @txtProfileFavorite.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrés'**
  String get txtProfileFavorite;

  /// No description provided for @txtProfileRoute.
  ///
  /// In fr, this message translates to:
  /// **'Mes parcours'**
  String get txtProfileRoute;

  /// No description provided for @txtProfilePurchase.
  ///
  /// In fr, this message translates to:
  /// **'Achats'**
  String get txtProfilePurchase;

  /// No description provided for @txtProfileTrip.
  ///
  /// In fr, this message translates to:
  /// **'Voyages'**
  String get txtProfileTrip;

  /// No description provided for @txtProfileTrophy.
  ///
  /// In fr, this message translates to:
  /// **'Trophées'**
  String get txtProfileTrophy;

  /// No description provided for @txtProfileStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get txtProfileStats;

  /// No description provided for @txtProfileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages et confidentialité'**
  String get txtProfileSettings;

  /// No description provided for @txtVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get txtVersion;

  /// No description provided for @txtMyPictures.
  ///
  /// In fr, this message translates to:
  /// **'Mes photos'**
  String get txtMyPictures;

  /// No description provided for @txtMyPicturesPublished.
  ///
  /// In fr, this message translates to:
  /// **'Publiées'**
  String get txtMyPicturesPublished;

  /// No description provided for @txtMyPicturesDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get txtMyPicturesDraft;

  /// No description provided for @txtMyPicturesAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter mes photos'**
  String get txtMyPicturesAdd;

  /// No description provided for @txtMyRoutes.
  ///
  /// In fr, this message translates to:
  /// **'Mes parcours'**
  String get txtMyRoutes;

  /// No description provided for @txtMyRoutesCreated.
  ///
  /// In fr, this message translates to:
  /// **'Mes parcours créés'**
  String get txtMyRoutesCreated;

  /// No description provided for @txtMyRoutesAdd.
  ///
  /// In fr, this message translates to:
  /// **'Créer un parcours'**
  String get txtMyRoutesAdd;

  /// No description provided for @txtNewRoute.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau parcours'**
  String get txtNewRoute;

  /// No description provided for @txtNewRouteImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer photos'**
  String get txtNewRouteImport;

  /// No description provided for @txtNewRouteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter photos'**
  String get txtNewRouteAdd;

  /// No description provided for @txtNewRouteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get txtNewRouteTitle;

  /// No description provided for @txtNewRouteTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Titre du parcours'**
  String get txtNewRouteTitleHint;

  /// No description provided for @txtNewRouteHashtag.
  ///
  /// In fr, this message translates to:
  /// **'Mots clés'**
  String get txtNewRouteHashtag;

  /// No description provided for @txtNewRouteCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get txtNewRouteCategory;

  /// No description provided for @txtNewRouteDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get txtNewRouteDescription;

  /// No description provided for @txtNewRouteDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get txtNewRouteDescriptionHint;

  /// No description provided for @txtNewRouteDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get txtNewRouteDistance;

  /// No description provided for @txtNewRouteDistanceHint.
  ///
  /// In fr, this message translates to:
  /// **'10 km'**
  String get txtNewRouteDistanceHint;

  /// No description provided for @txtNewRouteDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get txtNewRouteDuration;

  /// No description provided for @txtNewRouteDurationHint.
  ///
  /// In fr, this message translates to:
  /// **'2h'**
  String get txtNewRouteDurationHint;

  /// No description provided for @txtNewRouteAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité'**
  String get txtNewRouteAccess;

  /// No description provided for @txtNewRoutePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get txtNewRoutePrice;

  /// No description provided for @txtNewRoutePriceHint.
  ///
  /// In fr, this message translates to:
  /// **'prix'**
  String get txtNewRoutePriceHint;

  /// No description provided for @txtNewRouteDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get txtNewRouteDraft;

  /// No description provided for @txtNewRoutePublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get txtNewRoutePublish;

  /// No description provided for @txtFav.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrés'**
  String get txtFav;

  /// No description provided for @txtFavLike.
  ///
  /// In fr, this message translates to:
  /// **'Like'**
  String get txtFavLike;

  /// No description provided for @txtFavFav.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get txtFavFav;

  /// No description provided for @txtFavAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à un Dossier'**
  String get txtFavAdd;

  /// No description provided for @txtPurchase.
  ///
  /// In fr, this message translates to:
  /// **'Achats'**
  String get txtPurchase;

  /// No description provided for @txtPurchaseRoute.
  ///
  /// In fr, this message translates to:
  /// **'Parcours'**
  String get txtPurchaseRoute;

  /// No description provided for @txtPurchaseMap.
  ///
  /// In fr, this message translates to:
  /// **'Cartes'**
  String get txtPurchaseMap;

  /// No description provided for @txtTrip.
  ///
  /// In fr, this message translates to:
  /// **'Voyage'**
  String get txtTrip;

  /// No description provided for @txtTripUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get txtTripUpcoming;

  /// No description provided for @txtTripPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get txtTripPast;

  /// No description provided for @txtTrophy.
  ///
  /// In fr, this message translates to:
  /// **'Trophées'**
  String get txtTrophy;

  /// No description provided for @txtTrophyPassport.
  ///
  /// In fr, this message translates to:
  /// **'Passeport'**
  String get txtTrophyPassport;

  /// No description provided for @txtTrophyPassportCount.
  ///
  /// In fr, this message translates to:
  /// **'/194'**
  String get txtTrophyPassportCount;

  /// No description provided for @txtTrophyRewards.
  ///
  /// In fr, this message translates to:
  /// **'Accomplissements'**
  String get txtTrophyRewards;

  /// No description provided for @txtStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get txtStats;

  /// No description provided for @txtEditProfileSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le profil'**
  String get txtEditProfileSave;

  /// No description provided for @txtEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Éditer le profil'**
  String get txtEditProfile;

  /// No description provided for @txtEditProfilePseudo.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get txtEditProfilePseudo;

  /// No description provided for @txtEditProfilePseudoHint.
  ///
  /// In fr, this message translates to:
  /// **'P.H.'**
  String get txtEditProfilePseudoHint;

  /// No description provided for @txtEditProfileInsta.
  ///
  /// In fr, this message translates to:
  /// **'Instagram'**
  String get txtEditProfileInsta;

  /// No description provided for @txtEditProfileInstaHint.
  ///
  /// In fr, this message translates to:
  /// **'LePointGenius'**
  String get txtEditProfileInstaHint;

  /// No description provided for @txtEditProfileLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get txtEditProfileLocation;

  /// No description provided for @txtEditProfileLocationHint.
  ///
  /// In fr, this message translates to:
  /// **'Paris, France'**
  String get txtEditProfileLocationHint;

  /// No description provided for @txtEditProfileProfil.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get txtEditProfileProfil;

  /// No description provided for @txtEditProfileHashtag.
  ///
  /// In fr, this message translates to:
  /// **'Mots clés'**
  String get txtEditProfileHashtag;

  /// No description provided for @txtEditProfileAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité'**
  String get txtEditProfileAccess;

  /// No description provided for @txtEditProfileLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get txtEditProfileLanguage;

  /// No description provided for @txtEditProfileLanguageHint.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get txtEditProfileLanguageHint;

  /// No description provided for @txtEditProfileBirth.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get txtEditProfileBirth;

  /// No description provided for @txtEditProfileBirthHint.
  ///
  /// In fr, this message translates to:
  /// **'01 janvier 1980'**
  String get txtEditProfileBirthHint;

  /// No description provided for @txtEditProfileGender.
  ///
  /// In fr, this message translates to:
  /// **'Genre'**
  String get txtEditProfileGender;

  /// No description provided for @txtEditProfileGenderHint.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get txtEditProfileGenderHint;

  /// No description provided for @txtEditProfileGuide.
  ///
  /// In fr, this message translates to:
  /// **'Devenir Guide'**
  String get txtEditProfileGuide;

  /// No description provided for @txtRoute.
  ///
  /// In fr, this message translates to:
  /// **'Parcours'**
  String get txtRoute;

  /// No description provided for @txtRouteSalute.
  ///
  /// In fr, this message translates to:
  /// **'Salut '**
  String get txtRouteSalute;

  /// No description provided for @txtRouteQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Où est-ce qu\'on part aujourd\'hui ?'**
  String get txtRouteQuestion;

  /// No description provided for @txtSettingsMailPassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer e-mail et Mot de passe'**
  String get txtSettingsMailPassword;

  /// No description provided for @txtSettingsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get txtSettingsHelp;

  /// No description provided for @txtSettingsStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut du compte'**
  String get txtSettingsStatus;

  /// No description provided for @txtSettingsSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get txtSettingsSubscription;

  /// No description provided for @txtSettingsAuth.
  ///
  /// In fr, this message translates to:
  /// **'Autorisations'**
  String get txtSettingsAuth;

  /// No description provided for @txtSettingsNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get txtSettingsNotifications;

  /// No description provided for @txtSettingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get txtSettingsAbout;

  /// No description provided for @txtSettingsLogOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get txtSettingsLogOut;

  /// No description provided for @txtSettingsLegal.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales'**
  String get txtSettingsLegal;

  /// No description provided for @txtSettingsGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Conditions générales'**
  String get txtSettingsGeneral;

  /// No description provided for @txtMailPwdEmailSection.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get txtMailPwdEmailSection;

  /// No description provided for @txtMailPwdNewEmail.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel e-mail'**
  String get txtMailPwdNewEmail;

  /// No description provided for @txtMailPwdNewEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'nouveau@email.com'**
  String get txtMailPwdNewEmailHint;

  /// No description provided for @txtMailPwdConfirmEmail.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l\'e-mail'**
  String get txtMailPwdConfirmEmail;

  /// No description provided for @txtMailPwdInfoEmail.
  ///
  /// In fr, this message translates to:
  /// **'Un e-mail de confirmation sera envoyé à votre nouvelle adresse.'**
  String get txtMailPwdInfoEmail;

  /// No description provided for @txtMailPwdPasswordSection.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get txtMailPwdPasswordSection;

  /// No description provided for @txtMailPwdCurrent.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get txtMailPwdCurrent;

  /// No description provided for @txtMailPwdNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get txtMailPwdNew;

  /// No description provided for @txtMailPwdConfirmNew.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get txtMailPwdConfirmNew;

  /// No description provided for @txtMailPwdHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••••'**
  String get txtMailPwdHint;

  /// No description provided for @txtMailPwdInfoPassword.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 8 caractères. Combinez lettres, chiffres et symboles.'**
  String get txtMailPwdInfoPassword;

  /// No description provided for @txtMailPwdSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications'**
  String get txtMailPwdSave;

  /// No description provided for @txtAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get txtAbout;

  /// No description provided for @txtAboutBeta.
  ///
  /// In fr, this message translates to:
  /// **'BETA'**
  String get txtAboutBeta;

  /// No description provided for @txtAboutBrand1.
  ///
  /// In fr, this message translates to:
  /// **'TROT'**
  String get txtAboutBrand1;

  /// No description provided for @txtAboutBrand2.
  ///
  /// In fr, this message translates to:
  /// **'TLE'**
  String get txtAboutBrand2;

  /// No description provided for @txtAboutTagline.
  ///
  /// In fr, this message translates to:
  /// **'L\'appli qui fait bouger les aventuriers'**
  String get txtAboutTagline;

  /// No description provided for @txtAboutTag1.
  ///
  /// In fr, this message translates to:
  /// **'Randonnée'**
  String get txtAboutTag1;

  /// No description provided for @txtAboutTag2.
  ///
  /// In fr, this message translates to:
  /// **'Cyclisme'**
  String get txtAboutTag2;

  /// No description provided for @txtAboutTag3.
  ///
  /// In fr, this message translates to:
  /// **'Moto'**
  String get txtAboutTag3;

  /// No description provided for @txtAboutTag4.
  ///
  /// In fr, this message translates to:
  /// **'Point de vue'**
  String get txtAboutTag4;

  /// No description provided for @txtAboutTag5.
  ///
  /// In fr, this message translates to:
  /// **'Street Art'**
  String get txtAboutTag5;

  /// No description provided for @txtAboutTag6.
  ///
  /// In fr, this message translates to:
  /// **'Lieu de tournage'**
  String get txtAboutTag6;

  /// No description provided for @txtAboutStat1Value.
  ///
  /// In fr, this message translates to:
  /// **'1'**
  String get txtAboutStat1Value;

  /// No description provided for @txtAboutStat1Label.
  ///
  /// In fr, this message translates to:
  /// **'application'**
  String get txtAboutStat1Label;

  /// No description provided for @txtAboutStat2Value.
  ///
  /// In fr, this message translates to:
  /// **'6'**
  String get txtAboutStat2Value;

  /// No description provided for @txtAboutStat2Label.
  ///
  /// In fr, this message translates to:
  /// **'univers'**
  String get txtAboutStat2Label;

  /// No description provided for @txtAboutStat3Value.
  ///
  /// In fr, this message translates to:
  /// **'∞'**
  String get txtAboutStat3Value;

  /// No description provided for @txtAboutStat3Label.
  ///
  /// In fr, this message translates to:
  /// **'aventures'**
  String get txtAboutStat3Label;

  /// No description provided for @txtAboutVisionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notre Vision'**
  String get txtAboutVisionTitle;

  /// No description provided for @txtAboutVisionQuote.
  ///
  /// In fr, this message translates to:
  /// **'« Chaque lieu mérite d\'être découvert, chaque chemin mérite d\'être partagé. »'**
  String get txtAboutVisionQuote;

  /// No description provided for @txtAboutVisionBody.
  ///
  /// In fr, this message translates to:
  /// **'Trottle est née d\'une passion pour l\'exploration et le partage. Nous croyons que les meilleures aventures sont celles que l\'on vit ensemble, guidés par une communauté de passionnés.'**
  String get txtAboutVisionBody;

  /// No description provided for @txtAboutUniversTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les 6 principaux univers'**
  String get txtAboutUniversTitle;

  /// No description provided for @txtAboutUnivers1.
  ///
  /// In fr, this message translates to:
  /// **'Randonnée'**
  String get txtAboutUnivers1;

  /// No description provided for @txtAboutUnivers1Sub.
  ///
  /// In fr, this message translates to:
  /// **'Sentiers & nature'**
  String get txtAboutUnivers1Sub;

  /// No description provided for @txtAboutUnivers2.
  ///
  /// In fr, this message translates to:
  /// **'Cyclisme'**
  String get txtAboutUnivers2;

  /// No description provided for @txtAboutUnivers2Sub.
  ///
  /// In fr, this message translates to:
  /// **'Routes & pistes'**
  String get txtAboutUnivers2Sub;

  /// No description provided for @txtAboutUnivers3.
  ///
  /// In fr, this message translates to:
  /// **'Moto'**
  String get txtAboutUnivers3;

  /// No description provided for @txtAboutUnivers3Sub.
  ///
  /// In fr, this message translates to:
  /// **'Liberté & grand air'**
  String get txtAboutUnivers3Sub;

  /// No description provided for @txtAboutUnivers4.
  ///
  /// In fr, this message translates to:
  /// **'Street Art'**
  String get txtAboutUnivers4;

  /// No description provided for @txtAboutUnivers4Sub.
  ///
  /// In fr, this message translates to:
  /// **'Graffitis & fresques'**
  String get txtAboutUnivers4Sub;

  /// No description provided for @txtAboutUnivers5.
  ///
  /// In fr, this message translates to:
  /// **'Lieux de tournage'**
  String get txtAboutUnivers5;

  /// No description provided for @txtAboutUnivers5Sub.
  ///
  /// In fr, this message translates to:
  /// **'Cinéma & séries'**
  String get txtAboutUnivers5Sub;

  /// No description provided for @txtAboutUnivers6.
  ///
  /// In fr, this message translates to:
  /// **'Patrimoine'**
  String get txtAboutUnivers6;

  /// No description provided for @txtAboutUnivers6Sub.
  ///
  /// In fr, this message translates to:
  /// **'Histoire & monuments'**
  String get txtAboutUnivers6Sub;

  /// No description provided for @txtAboutWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi Trottle ?'**
  String get txtAboutWhyTitle;

  /// No description provided for @txtAboutWhy1Icon.
  ///
  /// In fr, this message translates to:
  /// **'👥'**
  String get txtAboutWhy1Icon;

  /// No description provided for @txtAboutWhy1Title.
  ///
  /// In fr, this message translates to:
  /// **'Communauté'**
  String get txtAboutWhy1Title;

  /// No description provided for @txtAboutWhy1Body.
  ///
  /// In fr, this message translates to:
  /// **'Des milliers de trottlers partagent leurs parcours et leurs découvertes au quotidien.'**
  String get txtAboutWhy1Body;

  /// No description provided for @txtAboutWhy2Icon.
  ///
  /// In fr, this message translates to:
  /// **'✅'**
  String get txtAboutWhy2Icon;

  /// No description provided for @txtAboutWhy2Title.
  ///
  /// In fr, this message translates to:
  /// **'Authenticité'**
  String get txtAboutWhy2Title;

  /// No description provided for @txtAboutWhy2Body.
  ///
  /// In fr, this message translates to:
  /// **'Des lieux vérifiés, des parcours testés, une communauté de confiance.'**
  String get txtAboutWhy2Body;

  /// No description provided for @txtAboutWhy3Icon.
  ///
  /// In fr, this message translates to:
  /// **'🧭'**
  String get txtAboutWhy3Icon;

  /// No description provided for @txtAboutWhy3Title.
  ///
  /// In fr, this message translates to:
  /// **'Liberté'**
  String get txtAboutWhy3Title;

  /// No description provided for @txtAboutWhy3Body.
  ///
  /// In fr, this message translates to:
  /// **'Explorez à votre rythme, sans contraintes. Trottle s\'adapte à chaque aventurier.'**
  String get txtAboutWhy3Body;

  /// No description provided for @txtAboutCta.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à Trottler ?'**
  String get txtAboutCta;

  /// No description provided for @txtVersionDetails.
  ///
  /// In fr, this message translates to:
  /// **'🎨 Design & UI\n• Transitions splash panel : slide horizontal complet X-axis uniquement, cadres entiers hors écran\n• Navigation Splash → Main : slide depuis le bas, ease in/out\n• Glassmorphisme carrousel et boutons Main : BackdropFilter + trottleBgDark 90%\n• Module BackArrowBar partagé : flèche retour identique sur toutes les pages (slot trailing optionnel)\n• Module MenuRow partagé : icône + label + chevron >, paramètres expandable/divider/labelStyle/labelWidth\n• Module FieldRow partagé : champ éditable inline, readOnly + onTap\n• Module DropdownFieldRow : menu déroulant en popup Overlay, aligné sous le hint\n• Module LocationFieldRow : recherche OSM Nominatim inline avec debounce 350 ms\n\n📱 Nouvelles pages\n• Main → Profile (slide droite)\n• Profile : avatar, menu complet, version cliquable\n• EditProfile : photo, pseudo, Instagram, localisation OSM, profil, hashtags, accessibilité, langue, date (picker natif), genre, Devenir Guide\n• Settings : menu, Se déconnecter (retour splash), mentions légales\n• Stats, Trophées (grille stamps Passeport 64×64), Version\n• Parcours (route_screen) accessible depuis MenuButtV02\n• 6 pages nav : MyPictures, MyRoutes, Fav, Purchase, Trip, Trophy\n\n🔗 Navigation\n• Toutes les pages Profile branchées avec slide droite→gauche 400 ms\n• Se déconnecter : pushAndRemoveUntil → Splash, slide depuis le haut\n• Version accessible depuis la page de connexion ET depuis Profile\n\n🐛 Corrections\n• ClipOval → ClipRRect pour BackdropFilter fiable sur boutons circulaires\n• Slide Y verrouillé (Alignment.bottomCenter sur Stack)\n• Dropdown langue : passage inline → Overlay pour éviter conflits de layout\n• txtVersion dupliqué dans app_fr.arb : nettoyé'**
  String get txtVersionDetails;
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
