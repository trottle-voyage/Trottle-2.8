/// Modèle de données d'une photo Trottle.
///
/// [imageAsset]  : chemin asset local (tests) ou URL Firebase Storage (prod)
/// [hashtag]     : catégorie principale liée à la DB de la photo
/// [city]        : nom de ville déterminé par géocodage inverse
/// [flag]        : drapeau emoji du pays (ex. '🇯🇵'), dérivé du géocodage
/// [liked]       : état du like local (synchro Firebase côté service)
class PhotoItem {
  PhotoItem({
    required this.imageAsset,
    required this.hashtag,
    required this.city,
    this.flag = '',
    this.liked = false,
  });

  final String imageAsset;
  final String hashtag;
  final String city;
  final String flag;
  bool liked;
}
