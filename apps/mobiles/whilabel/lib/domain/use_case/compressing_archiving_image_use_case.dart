import 'dart:io';
import 'package:image/image.dart' as img;

class CompressingArchivingImageUseCase {
  Future<File> call(File imageFile) async {
    img.Image originalImageSize = img.decodeImage(imageFile.readAsBytesSync())!;

    int targetWidth;
    int targetHeight;
    int maxLength = 1024;

    // todo camera 설정을 찾아 봐야 할거 같다.이미지 기본 카메라와 찍히는 이미지가 다르다
    if (originalImageSize.width < originalImageSize.height) {
      targetHeight = maxLength;
      // targetWidth = (originalImageSize.width / originalImageSize.height * 1024).round();
      targetWidth = (3 / 4 * maxLength).round();
    } else {
      targetWidth = maxLength;
      // targetHeight = (originalImageSize.height / originalImageSize.width * 1024).round();
      targetHeight = (3 / 4 * maxLength).round();
    }

    img.Image resizedImage = img.copyResize(originalImageSize,
        width: targetWidth, height: targetHeight);

    List<int> compressedBytes =
        img.encodeJpg(resizedImage, quality: 100); // Adjust quality as needed

    File compressedFile =
        File(imageFile.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);

    return compressedFile;
  }
}
