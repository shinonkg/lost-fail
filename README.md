# Kayıp Dosyalar

JSON driven, text-based dedektif hikâye oyunu MVP'si.

## Yapı

- `data/episode_index.json`: Uygulamanın bildiği dosya listesi.
- `data/episodes/dosya_01/manifest.json`: Dosya 01 metadata ve delil kataloğu.
- `data/episodes/dosya_01/story.json`: Tüm hikâye node'ları, seçimler, koşullar ve etkiler.
- `assets/episodes/dosya_01/cover.webp`: Dosya kapak görseli.
- `lib/services/story_engine.dart`: Generic story engine.
- `lib/services/save_service.dart`: Local save/load sistemi.

## Yeni Dosya Eklemek

1. `data/episodes/dosya_02/manifest.json` oluştur.
2. `data/episodes/dosya_02/story.json` oluştur.
3. WEBP assetleri `assets/episodes/dosya_02/` altına koy.
4. `data/episode_index.json` içine yeni episode kaydı ekle.
5. `pubspec.yaml` asset listesini güncelle.

Hikâye Dart koduna yazılmaz. Node, choice, requires ve effects kuralları JSON'dan okunur.

## Build

Flutter kurulu ortamda:

```bash
flutter pub get
flutter run
flutter build appbundle --release
flutter build apk --release --split-per-abi
```

MVP bilerek hafif tutuldu: ağır font, video, Lottie veya gereksiz servis paketi yok.
