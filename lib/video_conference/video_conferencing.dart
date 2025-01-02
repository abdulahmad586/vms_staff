import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../shared/shared.dart';

class VideoConferenceScreen extends KFDrawerContent {
  @override
  State<VideoConferenceScreen> createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen> {
  late InAppWebViewController webViewController;
  Uri url = Uri.parse("https://meetings.zsgov.ng/meetings");
  double progress = 0;
  bool isWebLoaded = false;
  Future getPermissions() async {
    PermissionService().requestPermission();
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    isWebLoaded = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        title: Text('VIDEO CONFERENCE',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url.toString())),
            onPermissionRequest: (controller, resources) async {
              return PermissionResponse(
                resources: resources.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useHybridComposition: true,
              useWideViewPort: false,
              supportMultipleWindows: true,
              allowContentAccess: true,
              allowBackgroundAudioPlaying: true,
              javaScriptCanOpenWindowsAutomatically: true,
              allowsInlineMediaPlayback: true,
              allowFileAccess: true,
              mediaPlaybackRequiresUserGesture: false,
              userAgent:
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
              preferredContentMode: UserPreferredContentMode.DESKTOP,
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
            onLoadStart: (InAppWebViewController controller, Uri? url) {
              setState(() {
                this.url = url!;
                debugPrint('loaded!');
              });
            },
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              setState(() {
                this.url = url!;
                debugPrint('Stopped! ');
                isWebLoaded = true;
              });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          (isWebLoaded == false)
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 7),
                )
              : Container(),
        ],
      ),
    );
  }
}
