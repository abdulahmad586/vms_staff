import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/sip_communication/sip_communication.dart';
import 'package:sip_ua/sip_ua.dart';

class DialPadWidget extends KFDrawerContent {
  @override
  State<DialPadWidget> createState() => _MyDialPadWidget();
}

class _MyDialPadWidget extends State<DialPadWidget>
    implements SipUaHelperListener {
  String? _dest;
  SIPUAHelper? helper;
  TextEditingController? _textController;
  late AppStorage _preferences;

  String? receivedMsg;

  @override
  initState() {
    super.initState();
    helper = context.read<AppCubit>().state.sipUaHelper;
    receivedMsg = "";
    _bindEventListeners();
    _loadSettings();
  }

  void _loadSettings() async {
    _preferences = await AppStorage();
    _dest = _preferences.sipDest ?? '';
    _textController = TextEditingController(text: _dest);
    _textController!.text = _dest!;

    setState(() {});
  }

  void _bindEventListeners() {
    helper!.addSipUaHelperListener(this);
  }

  Future<Widget?> _handleCall(BuildContext context,
      [bool voiceOnly = false]) async {
    final dest = _textController?.text;
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Permission.microphone.request();
      await Permission.camera.request();
    }
    if (dest == null || dest.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }

    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'width': '1280',
        'height': '720',
        'facingMode': 'user',
      }
    };

    MediaStream mediaStream;

    if (kIsWeb && !voiceOnly) {
      mediaStream =
          await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = false;
      MediaStream userStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final audioTracks = userStream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        mediaStream.addTrack(audioTracks.first, addToNative: true);
      }
    } else {
      if (voiceOnly) {
        mediaConstraints['video'] = !voiceOnly;
      }
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    helper!.call(dest, voiceOnly: voiceOnly, mediaStream: mediaStream);
    _preferences.sipDest = dest;
    return null;
  }

  void _handleBackSpace([bool deleteAll = false]) {
    var text = _textController!.text;
    if (text.isNotEmpty) {
      setState(() {
        text = deleteAll ? '' : text.substring(0, text.length - 1);
        _textController!.text = text;
      });
    }
  }

  void _handleNum(String number) {
    setState(() {
      _textController!.text += number;
    });
  }

  List<Widget> _buildNumPad() {
    final labels = [
      [
        {'1': ''},
        {'2': 'abc'},
        {'3': 'def'}
      ],
      [
        {'4': 'ghi'},
        {'5': 'jkl'},
        {'6': 'mno'}
      ],
      [
        {'7': 'pqrs'},
        {'8': 'tuv'},
        {'9': 'wxyz'}
      ],
      [
        {'*': ''},
        {'0': '+'},
        {'#': ''}
      ],
    ];

    return labels
        .map((row) => Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((label) => ActionButton(
                          title: label.keys.first,
                          subTitle: label.values.first,
                          onPressed: () => _handleNum(label.keys.first),
                          number: true,
                        ))
                    .toList())))
        .toList();
  }

  List<Widget> _buildDialPad() {
    return [
      Container(
        width: 380,
        child: TextField(
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black54),
          maxLines: 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textController,
        ),
      ),
      Container(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildNumPad(),
        ),
      ),
      Container(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ActionButton(
                icon: Icons.videocam,
                onPressed: () => _handleCall(context),
              ),
              ActionButton(
                icon: Icons.dialer_sip,
                fillColor: Colors.green,
                onPressed: () => _handleCall(context, true),
              ),
              ActionButton(
                icon: Icons.keyboard_arrow_left,
                onPressed: () => _handleBackSpace(),
                onLongPress: () => _handleBackSpace(true),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COMMUNICATION CENTER',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'account':
                    NavUtils.navTo(context, const RegisterWidget());
                    break;
                  case 'about':
                    NavUtils.navTo(context, AboutWidget());
                    break;
                  default:
                    break;
                }
              },
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 12),
                          Text('Account'),
                        ],
                      ),
                      value: 'account',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 12),
                          Text('About'),
                        ],
                      ),
                      value: 'about',
                    )
                  ]),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildDialPad(),
          ),
        ],
      ),
    );
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {});
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void callStateChanged(Call call, CallState callState) {
    if (callState.state == CallStateEnum.CALL_INITIATION) {
      NavUtils.navTo(context, CallScreenWidget(call));
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    //Save the incoming message to DB
    String? msgBody = msg.request.body as String?;
    setState(() {
      receivedMsg = msgBody;
    });
  }

  @override
  void onNewNotify(Notify ntf) {}

  @override
  void onNewReinvite(ReInvite event) {
    // TODO: implement onNewReinvite
  }
}
