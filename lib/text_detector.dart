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
    var orderedText = {};
    for (TextBlock block in visionText.blocks) {
      final boundingBox = block.boundingBox;
      final String blockText = block.text;
      if (blockText.length > 2) {
        int position =
            int.parse(boundingBox.top.toString() + boundingBox.left.toString());
        orderedText[position] = blockText;
      }
    }
    String detectedText = '';
    var sortedKeys = orderedText.keys.toList();
    sortedKeys.sort();
    sortedKeys.forEach((key) {
      detectedText = detectedText + orderedText[key] + '\n';
    });
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    screenText.text = detectedText;
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    screenText = await screenTextDb.insert(screenText);
    return screenText;
  }
}