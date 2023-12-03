// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class UploadPdfScreen extends StatefulWidget {
  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _docTitle;
  String? _docDate;
  String? _pageNum;
  File? _selectedFile;
  String? _uploadedFileURL;
  int selectedNumber = 0;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> _startUpload() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save(); // Save the form fields
      if (_selectedFile == null) {
        // No file selected
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: SizedBox(
              width: 150,
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 10,
                      color: Colors.amber,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('pdfs/${_selectedFile!.path.split('/').last}');

      firebase_storage.UploadTask uploadTask =
          storageReference.putFile(_selectedFile!);
      await uploadTask.whenComplete(() async {
        _docDate = DateFormat.MMMMd().format(
          selectedDate,
        );
        try {
          _uploadedFileURL = await storageReference.getDownloadURL();

          String formattedDate = DateFormat.yMMMM().format(selectedDate);
          // Upload additional fields to Firestore
          await FirebaseFirestore.instance.collection('DOCUMENTS').add({
            'doc_title': _docTitle,
            'doc_url': _uploadedFileURL,
            'doc_date': _docDate,
            'page_num': _pageNum,
            'month_year': formattedDate
          });
          // Reset fields after successful upload
          setState(() {
            _docTitle = null;
            _docDate = null;
            _pageNum = null;
            _selectedFile = null;
          });
          Navigator.of(context).pop(); // Close the AlertDialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File Uploaded'),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text('Uploade Devotional PDF By Date'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey,
              Colors.white,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Show selected file path if file is selected
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Devotion day title',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _docTitle = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.picture_as_pdf,
                        color: Colors.red, size: 50),
                    ElevatedButton(
                      onPressed: () async {
                        await _uploadFile();
                      },
                      child: const Text('Select PDF'),
                    ),
                  ],
                ),
                _selectedFile != null
                    ? Text(_selectedFile!.path)
                    : const SizedBox(),

                const SizedBox(
                  height: 15,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.calendar_month,
                              color: Colors.deepPurple, size: 50),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Select Date'),
                          ),
                          Text(
                            DateFormat.MMMMd().format(selectedDate),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Page Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'How many pages';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _pageNum = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
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
