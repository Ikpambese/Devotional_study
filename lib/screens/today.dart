// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DevotionalData {
  final String imgurl;
  final String title;
  final String scriptureReference;
  final String scriptureText;
  final String longText;
  final String confession;
  final String furtherReading;
  final DateTime docDate;

  DevotionalData({
    required this.imgurl,
    required this.title,
    required this.scriptureReference,
    required this.scriptureText,
    required this.longText,
    required this.confession,
    required this.furtherReading,
    required this.docDate,
  });
}

class UploadDevotionalDataPage extends StatefulWidget {
  const UploadDevotionalDataPage({super.key});

  @override
  _UploadDevotionalDataPageState createState() =>
      _UploadDevotionalDataPageState();
}

class _UploadDevotionalDataPageState extends State<UploadDevotionalDataPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _uploadedImageURL;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _scriptureRefController = TextEditingController();
  final TextEditingController _scriptureText = TextEditingController();
  final TextEditingController _longTextController = TextEditingController();
  final TextEditingController _confessionController = TextEditingController();
  final TextEditingController _confessionHeadController =
      TextEditingController();
  final TextEditingController _furtherReadingController =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _startUpload() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Uploading Todays Devotional...'),
            content: Center(child: CircularProgressIndicator()),
          );
        },
      );
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('devotional_images/${_selectedImage!.path.split('/').last}');

      firebase_storage.UploadTask uploadTask =
          storageReference.putFile(_selectedImage!);
      await uploadTask.whenComplete(() async {
        String formattedDate = DateFormat('E MMM d y').format(_selectedDate);
        try {
          _uploadedImageURL = await storageReference.getDownloadURL();
          print(formattedDate);
          await FirebaseFirestore.instance.collection('devotionalToday').add({
            'imgurl': _uploadedImageURL,
            'title': _titleController.text,
            'docDate': formattedDate,
            'scriptureReference': _scriptureRefController.text,
            'scriptureText': _scriptureText.text.trim(),
            'longText': _longTextController.text,
            'confessionHead': _confessionHeadController.text,
            'confession': _confessionController.text,
            'furtherReading': _furtherReadingController.text,
          });

          setState(() {
            _selectedImage = null;
            _titleController.clear();
            _scriptureRefController.clear();
            _longTextController.clear();
            _confessionController.clear();
            _furtherReadingController.clear();
            _selectedDate = DateTime.now();
            _confessionHeadController.clear();
            _scriptureText.clear();
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data Uploaded'),
            ),
          );
        } catch (e) {
          print('Error uploading data: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Devotional Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await _selectAndUploadImage();
                  },
                  child: const Text('Select Image'),
                ),
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 150,
                      )
                    : const SizedBox(),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Topic'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a topic';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _scriptureRefController,
                  decoration: const InputDecoration(labelText: 'Scripture'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a scripture reference';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _scriptureText,
                  decoration:
                      const InputDecoration(labelText: 'Scripture text'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a scripture text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _longTextController,
                  decoration: const InputDecoration(labelText: 'Message body'),
                  maxLines: null, // Allow multiline input
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter long text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confessionHeadController,
                  decoration:
                      const InputDecoration(labelText: 'Confession topic'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confession head';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confessionController,
                  decoration: const InputDecoration(labelText: 'Confession'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confession ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _furtherReadingController,
                  decoration: const InputDecoration(
                      labelText: 'Further reading scriptures '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Further reading scriptures';
                    }
                    return null;
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Select Date'),
                  subtitle: Text('${_selectedDate.month}/${_selectedDate.day}'),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onLongPress: () {},
                  onPressed: _startUpload,
                  child: const Text('Upload'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
