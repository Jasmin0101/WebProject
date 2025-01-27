import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/features/application/messages.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as img;

class ImageAddButton extends StatefulWidget {
  final String applicationId;

  const ImageAddButton({
    super.key,
    required this.applicationId,
  });

  @override
  State<ImageAddButton> createState() => _ImageAddButtonState();
}

class _ImageAddButtonState extends State<ImageAddButton> {
  bool _isUploading = false;

  Future<void> _uploadFile() async {
    setState(() => _isUploading = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      final service = api.getService<ApplicationService>();

      if (image == null) {
        setState(() => _isUploading = false);
        return;
      }

      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка обработки изображения')),
        );
        return;
      }

      final webpBytes = img.encodeJpg(decodedImage, quality: 10);
      final file = MultipartFile.fromBytes(
        'file',
        webpBytes,
        filename: image.name,
      );

      await service.uploadFile(
        int.tryParse(widget.applicationId) ?? -1,
        file,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Изображение успешно загружено')),
      );
      messagesStreamController.add({});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка загрузки изображения')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isUploading
          ? const SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : IconButton(
              onPressed: _uploadFile,
              icon: const Icon(Icons.attach_file),
            ),
    );
  }
}
