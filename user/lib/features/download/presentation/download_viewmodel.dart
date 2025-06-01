import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/features/download/domain/download_repository.dart';
import 'package:video_player/video_player.dart';

class DownloadViewModel extends ChangeNotifier {
  DownloadViewModel(this._repository);

  final DownloadRepository _repository;

  var _loading = false;

  bool get loading => _loading;

  double _progress = 0;

  double get progress => _progress;

  VideoPlayerController? _videoController;

  VideoPlayerController? get videoController => _videoController;

  String? _error;

  String? get error => _error;

  Future<void> getDownloadedVideo() async {
    final result = await _repository.getDownloadPath();

    await result.when(
      onSuccess: (data) async {
        if (data == null) return;

        final file = File(data);
        if (await file.exists() && (await file.length()) > 0) {
          debugPrint('Downloaded video exists in path: ${file.path}');

          _setState(() => _videoController = VideoPlayerController.file(file));
        }
      },
    );
  }

  Future<void> downloadVideo() async {
    _setState(() {
      _error = null;
      _loading = true;
    });

    final dir = await getExternalStorageDirectory();
    final filePath = '${dir?.path}/video_sample.mp4';
    final file = File(filePath);

    await _repository.saveDownloadPath(file.path);

    final result = await _repository.downloadWithResume(file);

    await result.when(
      onSuccess: (data) {
        final total = data.contentLength ?? 0;
        int received = 0;

        final sink = file.openWrite();

        data.stream.listen(
          (chunk) {
            received += chunk.length;
            sink.add(chunk);

            _progress = total > 0 ? (received / total) * 100 : 0;
            notifyListeners();
          },
          onDone: () async {
            await sink.close();
            _videoController = VideoPlayerController.file(file);
            _progress = 100;
            _loading = false;
            notifyListeners();
          },
          onError: (e) {
            _setState(() {
              _error = e.toString();
              _loading = false;
            });
            notifyListeners();
          },
          cancelOnError: true,
        );
      },
      onError: (error) {
        _setState(() {
          _error = error;
          _loading = false;
        });
        notifyListeners();
      },
    );
  }

  Future<void> deleteVideo() async {
    final result = await _repository.getDownloadPath();

    await result.when(
      onSuccess: (data) async {
        if (data == null || data.isEmpty) return;

        await File(data).delete();
        await _videoController?.dispose();
        _videoController = null;
        _progress = 0;
        _loading = false;

        notifyListeners();
      },
    );
  }

  void clearError() {
    _setState(() => _error = null);
  }

  void _setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
