/// Modèle de données d'une photo Trottle.
///
/// [imageAsset]  : chemin asset local (tests) ou URL Firebase Storage (prod)
/// [hashtag]     : catégorie principale (chip principal)
/// [city]        : nom de ville déterminé par géocodage inverse
/// [flag]        : drapeau emoji du pays (ex. '🇯🇵'), dérivé du géocodage
/// [liked]       : état du like local (synchro Firebase côté service)
/// [title]       : titre affiché dans la fiche détail (défaut → hashtag)
/// [keywords]    : liste de mots-clés (défaut → [hashtag])
/// [dateLabel]   : date pré-formatée ex. "Le 28 octobre 2025"
/// [user]        : nom d'utilisateur auteur de la photo
/// [description] : texte descriptif affiché dans la fiche détail
class PhotoItem {
  PhotoItem({
    required this.imageAsset,
    required this.hashtag,
    required this.city,
    this.flag        = '',
    this.liked       = false,
    this.title       = '',
    this.keywords    = const [],
    this.dateLabel   = '',
    this.user        = '',
    this.description = '',
  });

  final String       imageAsset;
  final String       hashtag;
  final String       city;
  final String       flag;
  bool               liked;

  // ── Fiche détail ──────────────────────────────────────────────────────────
  final String       title;
  final List<String> keywords;
  final String       dateLabel;
  final String       user;
  final String       description;

  /// Titre résolu : [title] si non vide, sinon [hashtag].
  String get resolvedTitle => title.isEmpty ? hashtag : title;

  /// Mots-clés résolus : [keywords] si non vide, sinon [[hashtag]].
  List<String> get resolvedKeywords =>
      keywords.isEmpty ? [hashtag] : keywords;
}
