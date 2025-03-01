import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  Uint8List? _imageData;

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

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      print("Receiver ICE: ${candidate.toMap()}");
    };

    _peerConnection!.onDataChannel = (RTCDataChannel channel) {
      _dataChannel = channel;
      _dataChannel!.onDataChannelState = (RTCDataChannelState state) {
        print("Data channel state: $state");
      };

      _dataChannel!.onMessage = (RTCDataChannelMessage message) {
        if (message.isBinary) {
          setState(() {
            _imageData = message.binary;
          });
        }
      };
    };

    String remoteSdp = """v=0

      o=- 6849785542437846826 2 IN IP4 127.0.0.1

      s=-

      t=0 0

      a=group:BUNDLE 0 1 2

      a=extmap-allow-mixed

      a=msid-semantic: WMS

      m=audio 9 UDP/TLS/RTP/SAVPF 111 63 9 102 0 8 13 110 126

      c=IN IP4 192.168.56.1

      a=rtcp:9 IN IP4 0.0.0.0

      a=ice-ufrag:onk9

      a=ice-pwd:32zhilNVD7R3URZGhZlLzl4x

      a=ice-options:trickle

      a=fingerprint:sha-256 E2:D3:4C:C0:9A:4B:0C:DD:F3:B1:E1:54:5B:A7:AE:E9:1C:59:EC:DF:CB:F1:A0:85:F8:30:FC:0F:25:F7:0B:B1

      a=setup:actpass

      a=mid:0

      a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level

      a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time

      a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01

      a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid

      a=sendrecv

      a=rtcp-mux

      a=rtpmap:111 opus/48000/2

      a=rtcp-fb:111 transport-cc

      a=fmtp:111 minptime=10;useinbandfec=1

      a=rtpmap:63 red/48000/2

      a=fmtp:63 111/111

      a=rtpmap:9 G722/8000

      a=rtpmap:102 ILBC/8000

      a=rtpmap:0 PCMU/8000

      a=rtpmap:8 PCMA/8000

      a=rtpmap:13 CN/8000

      a=rtpmap:110 telephone-event/48000

      a=rtpmap:126 telephone-event/8000

      m=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 35 36 37 38 127 103 104 105 106 107 108 109 125 124 39 40 41 42 43 44 45 46 47 48 112 113 114 49

      c=IN IP4 192.168.1.3

      a=rtcp:9 IN IP4 0.0.0.0

      a=ice-ufrag:onk9

      a=ice-pwd:32zhilNVD7R3URZGhZlLzl4x

      a=ice-options:trickle

      a=fingerprint:sha-256 E2:D3:4C:C0:9A:4B:0C:DD:F3:B1:E1:54:5B:A7:AE:E9:1C:59:EC:DF:CB:F1:A0:85:F8:30:FC:0F:25:F7:0B:B1

      a=setup:actpass

      a=mid:1

      a=extmap:14 urn:ietf:params:rtp-hdrext:toffset

      a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time

      a=extmap:13 urn:3gpp:video-orientation

      a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01

      a=extmap:5 http://www.webrtc.org/experiments/rtp-hdrext/playout-delay

      a=extmap:6 http://www.webrtc.org/experiments/rtp-hdrext/video-content-type

      a=extmap:7 http://www.webrtc.org/experiments/rtp-hdrext/video-timing

      a=extmap:8 http://www.webrtc.org/experiments/rtp-hdrext/color-space

      a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid

      a=extmap:10 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id

      a=extmap:11 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id

      a=sendrecv

      a=rtcp-mux

      a=rtcp-rsize

      a=rtpmap:96 VP8/90000

      a=rtcp-fb:96 goog-remb

      a=rtcp-fb:96 transport-cc

      a=rtcp-fb:96 ccm fir

      a=rtcp-fb:96 nack

      a=rtcp-fb:96 nack pli

      a=rtpmap:97 rtx/90000

      a=fmtp:97 apt=96

      a=rtpmap:98 VP9/90000

      a=rtcp-fb:98 goog-remb

      a=rtcp-fb:98 transport-cc

      a=rtcp-fb:98 ccm fir

      a=rtcp-fb:98 nack

      a=rtcp-fb:98 nack pli

      a=fmtp:98 profile-id=0

      a=rtpmap:99 rtx/90000

      a=fmtp:99 apt=98

      a=rtpmap:100 VP9/90000

      a=rtcp-fb:100 goog-remb

      a=rtcp-fb:100 transport-cc

      a=rtcp-fb:100 ccm fir

      a=rtcp-fb:100 nack

      a=rtcp-fb:100 nack pli

      a=fmtp:100 profile-id=2

      a=rtpmap:101 rtx/90000

      a=fmtp:101 apt=100

      a=rtpmap:35 VP9/90000

      a=rtcp-fb:35 goog-remb

      a=rtcp-fb:35 transport-cc

      a=rtcp-fb:35 ccm fir

      a=rtcp-fb:35 nack

      a=rtcp-fb:35 nack pli

      a=fmtp:35 profile-id=1

      a=rtpmap:36 rtx/90000

      a=fmtp:36 apt=35

      a=rtpmap:37 VP9/90000

      a=rtcp-fb:37 goog-remb

      a=rtcp-fb:37 transport-cc

      a=rtcp-fb:37 ccm fir

      a=rtcp-fb:37 nack

      a=rtcp-fb:37 nack pli

      a=fmtp:37 profile-id=3

      a=rtpmap:38 rtx/90000

      a=fmtp:38 apt=37

      a=rtpmap:127 H264/90000

      a=rtcp-fb:127 goog-remb

      a=rtcp-fb:127 transport-cc

      a=rtcp-fb:127 ccm fir

      a=rtcp-fb:127 nack

      a=rtcp-fb:127 nack pli

      a=fmtp:127 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42001f

      a=rtpmap:103 rtx/90000

      a=fmtp:103 apt=127

      a=rtpmap:104 H264/90000

      a=rtcp-fb:104 goog-remb

      a=rtcp-fb:104 transport-cc

      a=rtcp-fb:104 ccm fir

      a=rtcp-fb:104 nack

      a=rtcp-fb:104 nack pli

      a=fmtp:104 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=42001f

      a=rtpmap:105 rtx/90000

      a=fmtp:105 apt=104

      a=rtpmap:106 H264/90000

      a=rtcp-fb:106 goog-remb

      a=rtcp-fb:106 transport-cc

      a=rtcp-fb:106 ccm fir

      a=rtcp-fb:106 nack

      a=rtcp-fb:106 nack pli

      a=fmtp:106 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42e01f

      a=rtpmap:107 rtx/90000

      a=fmtp:107 apt=106

      a=rtpmap:108 H264/90000

      a=rtcp-fb:108 goog-remb

      a=rtcp-fb:108 transport-cc

      a=rtcp-fb:108 ccm fir

      a=rtcp-fb:108 nack

      a=rtcp-fb:108 nack pli

      a=fmtp:108 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=42e01f

      a=rtpmap:109 rtx/90000

      a=fmtp:109 apt=108

      a=rtpmap:125 H264/90000

      a=rtcp-fb:125 goog-remb

      a=rtcp-fb:125 transport-cc

      a=rtcp-fb:125 ccm fir

      a=rtcp-fb:125 nack

      a=rtcp-fb:125 nack pli

      a=fmtp:125 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=4d001f

      a=rtpmap:124 rtx/90000

      a=fmtp:124 apt=125

      a=rtpmap:39 H264/90000

      a=rtcp-fb:39 goog-remb

      a=rtcp-fb:39 transport-cc

      a=rtcp-fb:39 ccm fir

      a=rtcp-fb:39 nack

      a=rtcp-fb:39 nack pli

      a=fmtp:39 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=4d001f

      a=rtpmap:40 rtx/90000

      a=fmtp:40 apt=39

      a=rtpmap:41 H264/90000

      a=rtcp-fb:41 goog-remb

      a=rtcp-fb:41 transport-cc

      a=rtcp-fb:41 ccm fir

      a=rtcp-fb:41 nack

      a=rtcp-fb:41 nack pli

      a=fmtp:41 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=f4001f

      a=rtpmap:42 rtx/90000

      a=fmtp:42 apt=41

      a=rtpmap:43 H264/90000

      a=rtcp-fb:43 goog-remb

      a=rtcp-fb:43 transport-cc

      a=rtcp-fb:43 ccm fir

      a=rtcp-fb:43 nack

      a=rtcp-fb:43 nack pli

      a=fmtp:43 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=f4001f

      a=rtpmap:44 rtx/90000

      a=fmtp:44 apt=43

      a=rtpmap:45 AV1/90000

      a=rtcp-fb:45 goog-remb

      a=rtcp-fb:45 transport-cc

      a=rtcp-fb:45 ccm fir

      a=rtcp-fb:45 nack

      a=rtcp-fb:45 nack pli

      a=fmtp:45 level-idx=5;profile=0;tier=0

      a=rtpmap:46 rtx/90000

      a=fmtp:46 apt=45

      a=rtpmap:47 AV1/90000

      a=rtcp-fb:47 goog-remb

      a=rtcp-fb:47 transport-cc

      a=rtcp-fb:47 ccm fir

      a=rtcp-fb:47 nack

      a=rtcp-fb:47 nack pli

      a=fmtp:47 level-idx=5;profile=1;tier=0

      a=rtpmap:48 rtx/90000

      a=fmtp:48 apt=47

      a=rtpmap:112 red/90000

      a=rtpmap:113 rtx/90000

      a=fmtp:113 apt=112

      a=rtpmap:114 ulpfec/90000

      a=rtpmap:49 flexfec-03/90000

      a=rtcp-fb:49 goog-remb

      a=rtcp-fb:49 transport-cc

      a=fmtp:49 repair-window=10000000

      m=application 9 UDP/DTLS/SCTP webrtc-datachannel

      c=IN IP4 109.92.125.213

      a=ice-ufrag:onk9

      a=ice-pwd:32zhilNVD7R3URZGhZlLzl4x

      a=ice-options:trickle

      a=fingerprint:sha-256 E2:D3:4C:C0:9A:4B:0C:DD:F3:B1:E1:54:5B:A7:AE:E9:1C:59:EC:DF:CB:F1:A0:85:F8:30:FC:0F:25:F7:0B:B1

      a=setup:actpass

      a=mid:2

      a=sctp-port:5000

      a=max-message-size:262144""";
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(remoteSdp, "offer"),
    );

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    print("\n\n\n Receiver SDP answer:\n\n\n${answer.sdp}"); 
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Receiver App")),
        body: Center(
          child:
              _imageData != null
                  ? Image.memory(
                    _imageData!,
                    gaplessPlayback:
                        true
                  )
                  : Text("Waiting for stream..."),
        ),
      ),
    );
  }
}
