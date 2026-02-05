import 'dart:io';

abstract class CameraDevice {
  Future<File?> takePhoto();
}
