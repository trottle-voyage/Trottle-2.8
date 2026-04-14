import 'package:firebase_storage/firebase_storage.dart';

/// Service Firebase Storage — accès centralisé aux images du bucket.
/// Bucket : trottle-2eaf6.appspot.com
class StorageService {
  // ── Singleton ─────────────────────────────────────────────────────────────
  static final StorageService instance = StorageService._();
  StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── Lister les images d'un dossier ────────────────────────────────────────

  /// Retourne les URLs des [count] dernières images de [folderPath],
  /// triées par date d'upload décroissante (la plus récente en premier).
  Future<List<String>> listLastImages(String folderPath,
      {int count = 10}) async {
    final ref    = _storage.ref(folderPath);
    final result = await ref.listAll();

    // Récupère les métadonnées de tous les fichiers en parallèle
    final metas = await Future.wait(
      result.items.map((item) => item.getMetadata()),
    );

    // Associe chaque référence à sa date d'upload
    final itemsWithDate = List.generate(result.items.length, (i) => (
      ref:  result.items[i],
      date: metas[i].timeCreated ?? DateTime(0),
    ));

    // Tri décroissant par date réelle
    itemsWithDate.sort((a, b) => b.date.compareTo(a.date));

    // Prend les [count] plus récents et récupère leurs URLs
    final last = itemsWithDate.take(count).toList();
    final urls = await Future.wait(last.map((e) => e.ref.getDownloadURL()));
    return urls;
  }

  // ── URL d'une image précise ───────────────────────────────────────────────

  /// Retourne l'URL de téléchargement d'un fichier précis.
  /// Ex: getImageUrl('photos/sunset.jpg')
  Future<String> getImageUrl(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}
