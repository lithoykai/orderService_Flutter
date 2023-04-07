import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;

  UserImagePicker({
    Key? key,
    required this.onImagePick,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickerImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePick(_image!);
    }
  }

  Future<void> _pickerImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _image != null
              ? Image.file(
                  _image!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text('Nenhuma imagem!'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Tirar Foto'),
              onPressed: _pickerImage,
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Escolher da galeria.'),
              onPressed: _pickerImageGallery,
            ),
          ],
        ),
      ],
    );
  }
  // Column(
  //   children: [
  //     CircleAvatar(
  //       backgroundColor: Colors.grey,
  //       radius: 35,
  //       backgroundImage: _image != null ? FileImage(_image!) : null,
  //     ),
  //     TextButton(
  //       onPressed: _pickerImage,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           Icon(Icons.image),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text('Adicionar imagem.'),
  //         ],
  //       ),
  //     )
  //   ],
  // );
}
