import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // used to gain access to the File type

class ImageCamera extends StatefulWidget {
  const ImageCamera({super.key, required this.onEventImage});

  final void Function (File image) onEventImage;
  @override
  State<ImageCamera> createState() {
    return _ImageCameraState();
  }
}

class _ImageCameraState extends State<ImageCamera> {
  File? _eventImage;

  void _pickFromGallery() async {
    final pickImage = ImagePicker();
    final eventImage = await pickImage.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500); //limiting image size so the file isnt too big

    if (eventImage == null) {
      return;
    }
    setState(() {
      _eventImage = File(eventImage.path);
    });
    // .path gets the path to the image file on the device
    widget.onEventImage(_eventImage!); //used to forward image to add_event
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = TextButton.icon(
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('Click to add a photo for the event'),
      onPressed: _pickFromGallery,
    );

    if (_eventImage != null) {
      preview = GestureDetector(
        onTap: _pickFromGallery,
        child: Image.file(
          _eventImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      height: 300,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(width: 2)),
      child: preview,
    );
  }
}

//using image_picker plugin, will need extra configuration if app was used for ios device
