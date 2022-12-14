import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;

import './my_text.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;

  const ImageInput({Key? key, required this.onSelectedImage}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicFromCameraOrGallery(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
        source: source,
        maxWidth: 600,
        imageQuality: 100); // note that : here you get an XFile not just a File

    if (photo == null) return;

    setState(() {
      _storedImage = File(photo.path); // here you convert the 'XFile' to 'File'
    });


    Directory? appDocDir;
    try {
      appDocDir = await sys_path.getApplicationDocumentsDirectory(); // path to directory that hold the image
    }on sys_path.MissingPlatformDirectoryException catch(ex) {
      debugPrint(ex.toString());
    }

    final fileName = path.basename(photo.path); // name.jpg for example

// photo is from XFile type so i need to convert it to File type to get to copy method
    final savedImage =
    await File(photo.path).copy('${appDocDir!.path}/$fileName}'); // path of dir + name.jpg

    widget.onSelectedImage(savedImage);
  }
  Future<void> _takePicture() async {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: MyText(text: 'Choose', color: Colors.blueGrey, size: 17,),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.camera, color: Colors.purple[200],), onPressed: () async{
            await _takePicFromCameraOrGallery(ImageSource.camera);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }),
          IconButton(icon: Icon(Icons.image_rounded, color: Colors.purple[200],), onPressed: () async{
            await _takePicFromCameraOrGallery(ImageSource.gallery);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(width: 1.3, color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : MyText(
                  text: 'No Image',
                  size: 15,
                  color: Colors.blueGrey,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: _takePicture,
            style: ElevatedButton.styleFrom(primary: Colors.purple[200]),
            child: MyText(
              text: 'Take a pic',
              letterSpace: 0,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}
/*

 */