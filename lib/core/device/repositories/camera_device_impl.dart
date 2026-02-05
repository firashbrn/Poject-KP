import 'dart:io';
import 'package:image_picker/image_picker.dart' as img_picker;
import 'package:presensi_application_1/core/device/repositories/camera_device.dart';

class CameraDeviceImpl implements CameraDevice {
  final img_picker.ImagePicker _picker = img_picker.ImagePicker();

  @override
  Future<File?> takePhoto() async {
    final img_picker.XFile? photo = await _picker.pickImage(
      source: img_picker.ImageSource.camera,
      imageQuality: 50, // Optimize image size
    );

    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }
}
