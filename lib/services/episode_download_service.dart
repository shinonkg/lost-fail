import '../models/episode.dart';

class EpisodeDownloadService {
  Future<bool> canDownload(EpisodeSummary episode) async {
    return episode.remoteManifestUrl != null && episode.remoteManifestUrl!.isNotEmpty;
  }

  Future<void> download(EpisodeSummary episode) async {
    if (!await canDownload(episode)) {
      throw UnsupportedError('Remote episode source is not configured yet.');
    }
    // Future hook: fetch remote manifest, story JSON, and compact WEBP assets.
  }
}
