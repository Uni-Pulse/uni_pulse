// import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
final ImagePicker imagePicker = ImagePicker();
XFile? file = await imagePicker.pickImage(source: source);
if(file != null){
  return await file.readAsBytes();
}
print('No Image Selected');
}

// couldnt save images in databse without adding billing so images are currently unused