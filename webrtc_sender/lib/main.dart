import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(SenderApp());
}

class SenderApp extends StatefulWidget {
  @override
  _SenderAppState createState() => _SenderAppState();
}

class _SenderAppState extends State<SenderApp> {
  final ScreenshotController _screenshotController = ScreenshotController();
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeWebRTC();
  }

  Future<void> _initializeWebRTC() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _dataChannel = await _peerConnection!.createDataChannel(
      "screenshot",
      RTCDataChannelInit(),
    );

    _dataChannel!.onDataChannelState = (RTCDataChannelState state) {
      print("Data channel state: $state");
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _startSendingScreenshots();
      }
    };

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      print("Sender ICE: ${candidate.toMap()}");
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    print("\n----------------------------------------------------------------------------------\n",);
    print("\nSender SDP offer:\n${offer.sdp}");
    print("\n----------------------------------------------------------------------------------\n");
    

    String remoteSdp = """.....""";
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(remoteSdp, "answer"),
    );
  }

  Future<void> addIceCandidate(
    String sdpMid,
    int sdpMLineIndex,
    String candidate,
  ) async {
    RTCIceCandidate iceCandidate = RTCIceCandidate(
      candidate,
      sdpMid,
      sdpMLineIndex,
    );
    await _peerConnection!.addCandidate(iceCandidate);
  }

  void _startSendingScreenshots() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Uint8List? image = await _captureScreenshot();
      if (image != null && _dataChannel != null) {
        _dataChannel!.send(RTCDataChannelMessage.fromBinary(image));
        print("Screenshot sent");
      }
    });
  }

  Future<Uint8List?> _captureScreenshot() async {
    try {
      Uint8List? image = await _screenshotController.capture();
      if (image != null) await _saveScreenshot(image);
      return image;
    } catch (e) {
      print('Screenshot exception: $e');
      return null;
    }
  }

  Future<void> _saveScreenshot(Uint8List image) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/test_screenshot.png',
    );
    await file.writeAsBytes(image);
    print('Screenshot saved at: ${file.path}');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dataChannel?.close();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Sender App")),
        body: Screenshot(
          controller: _screenshotController,
          child: Center(child: Text("Streaming screenshots...")),
        ),
      ),
    );
  }
}
