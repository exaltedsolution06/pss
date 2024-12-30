import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LiveStreamPage extends StatefulWidget {
  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    _initializeRenderer();
    _startLocalStream();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _localStream?.dispose();
    super.dispose();
  }

  Future<void> _initializeRenderer() async {
    await _localRenderer.initialize();
  }

  Future<void> _startLocalStream() async {
    final mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      setState(() {
        _localStream = stream;
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Video Stream'),
      ),
      body: Center(
        child: _localRenderer.srcObject != null
            ? RTCVideoView(_localRenderer)
            : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),),
      ),
    );
  }
}
