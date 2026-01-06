import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

Future<void> initCameras() async {
  _cameras = await availableCameras();
}

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(_controller!)),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf_outlined,color: Colors.white,size: 35,),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 7),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Icon(Icons.emoji_emotions_outlined,color: Colors.white,size: 35,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
