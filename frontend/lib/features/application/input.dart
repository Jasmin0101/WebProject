import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/features/application/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;

import '../../core/api/chopper.dart';

class ApplicationInputField extends StatefulWidget {
  final String applicationId;

  ApplicationInputField({
    super.key,
    required this.applicationId,
  });

  @override
  State<ApplicationInputField> createState() => _ApplicationInputFieldState();
}

class _ApplicationInputFieldState extends State<ApplicationInputField> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = true;
  bool _isComplited = false;

  Future<void> _fetchApplicationInfo() async {
    final service = api.getService<ApplicationService>();

    try {
      final response = await service.view(
        int.tryParse(widget.applicationId) ?? -1,
      );

      final data = Map<String, dynamic>.from(response.body);
      _isComplited = data["status"] == "CO";

      _isLoading = false;
      setState(() {});
    } catch (error) {}
  }

  Future<void> _uploadFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final service = api.getService<ApplicationService>();

    if (image == null) {
      return;
    }
    final imageBytes = await image.readAsBytes();

    // Decode image bytes
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) return;

    // Encode to WebP
    final webpBytes = img.encodeJpg(decodedImage, quality: 10);

    try {
      final file = MultipartFile.fromBytes(
        'file',
        webpBytes,
        filename: image.name,
      );
      service.uploadFile(
        int.tryParse(widget.applicationId) ?? -1,
        file,
      );
    } catch (e) {}
  }

  @override
  void initState() {
    _fetchApplicationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: _isLoading || _isComplited
          ? SizedBox(
              width: MediaQuery.sizeOf(context).width,
            )
          : Container(
              padding: EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 12,
              ),
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primaryContainer.withValues(
                            alpha: 0.6,
                          ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Введите сообщение',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onSubmitted: (value) async {
                        final service = api.getService<ApplicationService>();
                        final text = _controller.text;
                        if (text.isEmpty) {
                          return;
                        }

                        _controller.clear();

                        try {
                          final response = await service.addText(
                            int.tryParse(widget.applicationId) ?? -1,
                            text,
                          );
                          final data = Map<String, dynamic>.from(response.body);

                          messagesStreamController.add(data);
                        } catch (error) {}
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final service = api.getService<ApplicationService>();
                      final text = _controller.text;
                      if (text.isEmpty) {
                        return;
                      }

                      _controller.clear();

                      try {
                        final response = await service.addText(
                          int.tryParse(widget.applicationId) ?? -1,
                          text,
                        );
                        final data = Map<String, dynamic>.from(response.body);

                        messagesStreamController.add(data);
                      } catch (error) {}
                    },
                    icon: Icon(Icons.send),
                  ),
                  IconButton(
                    onPressed: () async {
                      _uploadFile();
                    },
                    icon: Icon(Icons.attach_file),
                  )
                ],
              ),
            ),
    );
  }
}
