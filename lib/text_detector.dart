import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class TextDetector{
  detectText(String imagePath) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String detectedText = '';
    for (TextBlock block in visionText.blocks) {
      detectedText = block.text + '\n';
    }
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    screenText.text = detectedText;
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    screenText = await screenTextDb.insert(screenText);
    return screenText;
  }
}