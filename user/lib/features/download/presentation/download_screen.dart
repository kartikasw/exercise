import 'package:flutter/material.dart';
import 'package:todo/core/di/di.dart';
import 'package:todo/core/extensions.dart';
import 'package:todo/features/download/presentation/download_viewmodel.dart';
import 'package:video_player/video_player.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late final DownloadViewModel _downloadViewModel;

  @override
  void initState() {
    _downloadViewModel = locator<DownloadViewModel>();
    _downloadViewModel.addListener(_onDownloadViewModelChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _downloadViewModel.getDownloadedVideo();
    });
    super.initState();
  }

  @override
  void dispose() {
    _downloadViewModel.addListener(_onDownloadViewModelChanged);
    _downloadViewModel.videoController?.dispose();
    super.dispose();
  }

  void _onDownloadViewModelChanged() {
    final error = _downloadViewModel.error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      _downloadViewModel.clearError();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            ListenableBuilder(
              listenable: _downloadViewModel,
              builder: (context, child) {
                final videoController = _downloadViewModel.videoController;
                if (videoController != null) {
                  return FutureBuilder(
                    future: videoController.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        videoController.play();
                        return AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(videoController),
                              VideoProgressIndicator(
                                videoController,
                                allowScrubbing: true,
                              ),
                            ],
                          ),
                        );
                      }

                      return CircularProgressIndicator();
                    },
                  );
                }

                if (_downloadViewModel.loading) {
                  return CircularProgressIndicator();
                }

                return IconButton(
                  onPressed: () => _downloadViewModel.downloadVideo(),
                  icon: Icon(Icons.file_download, size: MediaQuery.of(context).size.height * 0.1),
                );
              },
            ),
            ListenableBuilder(
              listenable: _downloadViewModel,
              builder: (context, child) {
                if (_downloadViewModel.videoController != null) {
                  return ElevatedButton(
                    onPressed: () => _downloadViewModel.deleteVideo(),
                    child: Text('Delete video'),
                  );
                }

                return Text('Progress: ${_downloadViewModel.progress.format}%');
              },
            ),
          ],
        ),
      ),
    );
  }
}
