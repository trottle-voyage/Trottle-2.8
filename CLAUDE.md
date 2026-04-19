# Trottle 2.8 — Notes projet pour Claude

## Stack & environnement
- **Flutter** (Dart), branche git : `PH`
- **Chemin projet** : `D:\Trottle\Trottle-2.8`
- **Firebase** : Auth anonyme + Storage + AppCheck
- **Packages clés** : flutter_map, geolocator, geocoding, battery_plus, connectivity_plus, image_picker, intl

---

## Architecture

```
lib/
├── app.dart                        # MaterialApp, thème, locale fr
├── main.dart                       # Entrée, Firebase init, SystemChrome blanc
├── core/
│   ├── constants/app_constants.dart   # appName, appVersion, infoVersion
│   ├── services/                      # GpsService, StorageService
│   ├── theme/
│   │   ├── app_colors.dart            # Toutes les couleurs (trottleMain, trottleBgDark, etc.)
│   │   ├── app_decorations.dart       # bgBlur, trottleCadre, dropShadow
│   │   └── app_text_styles.dart       # title, subTitleBig, subTitleMedium, text, textBold, hashtag, info
│   └── widgets/                       # Modules partagés (voir ci-dessous)
├── features/
│   ├── splash/splash_screen.dart      # Page connexion/inscription + transitions
│   ├── main/main_screen.dart          # Carte + menu circulaire
│   ├── profile/                       # Pages profil
│   ├── nav/                           # Pages navigation (parcours, photos, etc.)
│   └── infos/version_screen.dart      # Notes de version
└── l10n/                              # Localisation FR
```

---

## Modules partagés (`lib/core/widgets/`)

| Widget | Rôle | Paramètres clés |
|--------|------|-----------------|
| `BackArrowBar` | Barre retour haut de page | `onTap`, `trailing` (slot droite optionnel) |
| `MenuRow` | Ligne icône + label + chevron | `expandable`, `expanded`, `divider`, `labelStyle`, `labelWidth`, `onTap` |
| `FieldRow` | Ligne icône + label + TextField éditable | `initialValue`, `divider`, `readOnly`, `onTap`, `onChanged` |
| `DropdownFieldRow` | Ligne avec menu déroulant en Overlay popup | `options`, `value`, `divider`, `onChanged` |
| `LocationFieldRow` | Champ localisation + recherche OSM inline | `initialValue`, `divider`, `onChanged` |

---

## Couleurs (`AppColors`)
- `trottleMain` = `#0095FF` (bleu principal)
- `trottleBgDark` = `#051B2C` (fond sombre — toutes les pages)
- `trottleWhite` = `#FFFFFF`
- `trottleDark` = (séparateurs)
- `trottleMidGray` = (icônes, hints)
- `trottleGray` = (textes secondaires)

---

## Décorations (`AppDecorations`)
- `bgBlur` = `ImageFilter.blur(sigmaX: 10, sigmaY: 10)`
- `trottleCadre` = `color: trottleMain.withOpacity(0.4)`, `borderRadius: 24`
- `dropShadow` = `BoxShadow(color: #80000000, blurRadius: 24, offset: Offset(0, 8))`

---

## Pages existantes

### `features/splash/`
- `SplashScreen` — connexion / mot de passe oublié / inscription / bienvenue
  - Transitions : slide horizontal X entre panneaux, slide depuis le bas vers Main

### `features/main/`
- `MainScreen` — carte flutter_map + menu circulaire glassmorphique
  - `V01` → ProfileScreen
  - `V02` → RouteScreen
  - `V03/V04` — libres

### `features/profile/`
- `ProfileScreen` — avatar + menu complet, version cliquable en bas
- `EditProfileScreen` — édition pseudo, Instagram, localisation, profil, hashtags, accessibilité, langue (dropdown overlay), date (picker natif), genre (dropdown), Devenir Guide
- `SettingsScreen` — paramètres, se déconnecter (→ Splash via pushAndRemoveUntil)
- `StatsScreen` — vide (à remplir)
- `TrophyScreen` — passeport (grille stamps 64×64 depuis `assets/stamps/`), accomplissements
- `StatsScreen` — vide
- `stats_screen.dart` — vide

### `features/nav/`
- `RouteScreen` — page Parcours (avatar + salutation + question)
- `MyPicturesScreen` — Publiées (expandable) / Brouillon (expandable) / Ajouter
- `MyRouteScreen` — Mes parcours créés / Créer un parcours
- `FavScreen` — Like / Favoris / Ajouter à un Dossier
- `PurchaseScreen` — Parcours / Cartes
- `TripScreen` — À venir / Passés
- `TrophyScreen` → déplacé dans `features/profile/`

### `features/infos/`
- `VersionScreen` — titre version + notes `txtVersionDetails` (scrollable)
  - Accessible depuis : Splash (bas de page) + Profile (bas de page)

---

## Navigation
- **Pattern standard** : `Navigator.push` + `PageRouteBuilder` + `SlideTransition`
  - Droite → gauche : `Offset(1, 0) → Offset.zero`, 400 ms, `Curves.easeInOut`
  - Retour automatique via `BackArrowBar` (`Navigator.pop`)
- **Splash → Main** : slide bas → haut (`Offset(0, 1) → Offset.zero`), 500 ms
- **Déconnexion** : slide haut → bas (`Offset(0, -1) → Offset.zero`), `pushAndRemoveUntil`

---

## Localisation
- Fichiers : `lib/l10n/app_fr.arb` (source) + `app_localizations.dart` + `app_localizations_fr.dart` (générés **manuellement**)
- **Règle** : aucun texte en dur dans l'appli — tout passe par `AppLocalizations.of(context)!`
- Quand on ajoute une clé dans `app_fr.arb`, propager dans les 2 fichiers `.dart`

---

## Assets
```
assets/
├── images/        # pp.webp, logos, main_logo
├── stamps/        # Australie.png, France.png, Japon.png, Nouvelle-Zélande.png, USA.png
├── animations/
├── icones/
├── logos/
└── fonts/         # LeagueSpartan, Montserrat, LeagueGothic
```

---

## Conventions
- Background toutes les pages : `AppColors.trottleBgDark`
- `SafeArea(top: false)` + `BackArrowBar` qui gère le `padding.top` lui-même
- Marges horizontales : **20 px** partout
- Stroke séparateur : `height: 0.5` ou `1`, couleur `trottleDark`
- Status bar native : blanche (`SystemChrome` dans `main.dart`)
