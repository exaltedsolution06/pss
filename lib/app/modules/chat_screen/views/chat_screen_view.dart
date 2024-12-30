import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:open_file/open_file.dart';

class ChatScreenView extends StatefulWidget {
  const ChatScreenView({Key? key}) : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isEmojiPickerVisible = false;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'text': _messageController.text, 'isSent': true});
        _messageController.clear();
      });
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _messages.add({'file': file, 'fileName': result.files.single.name, 'isSent': true});
      });
    }
  }

  void _pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedFile != null) {
      final file = File(pickedFile.files.single.path!);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        /*aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],*/
      );
      if (croppedFile != null) {
        setState(() {
          _messages.add({'image': File(croppedFile.path!), 'isSent': true});
        });
      }
    }
  }

  void _showReceivedMessage() {
    setState(() {
      _messages.add({'text': 'Default received message', 'isSent': false});
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });
  }

  Icon _getFileIcon(String fileName) {
    final fileExtension = fileName.split('.').last.toLowerCase();
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icon(Icons.image, color: AppColor.purple);
      case 'pdf':
        return Icon(Icons.picture_as_pdf, color: AppColor.purple);
      case 'xls':
      case 'xlsx':
        return Icon(Icons.table_chart, color: AppColor.purple);
      default:
        return Icon(Icons.insert_drive_file, color: AppColor.purple);
    }
  }

  void _openFile(File file) {
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: AppColor.white)),
        backgroundColor: Color(0xFFd10037),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 40, color: Colors.white),
            onPressed: _showReceivedMessage,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isSent = message['isSent'] ?? true;

                        return Stack(
                          children: [
                            Align(
                              alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color: isSent ? Color(0xFFd10037) : AppColor.Greyscale,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                ),
                                child: message['text'] != null
                                    ? Text(
                                        message['text'],
                                        style: TextStyle(
                                          color: isSent ? Colors.white : Colors.black87,
                                        ),
                                      )
                                    : message['image'] != null
                                        ? Image.file(message['image'])
                                        : message['file'] != null
                                            ? InkWell(
                                                onTap: () => _openFile(message['file']),
                                                child: Row(
                                                  children: [
                                                    _getFileIcon(message['fileName']),
                                                    SizedBox(width: 8.0),
                                                    Expanded(
                                                      child: Text(
                                                        message['fileName'],
                                                        style: TextStyle(
                                                          color: isSent ? Colors.white : Colors.black87,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (_isEmojiPickerVisible)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            onEmojiSelected: (Category? category, Emoji emoji) {
                              setState(() {
                                _messageController.text += emoji.emoji;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
						child: autoWidthTextField(controller: _messageController, text: 'Type a message', width: screenWidth-100, defaultValue: ''),
                    ),
                    IconButton(
						icon: Container(
							decoration: BoxDecoration(
							  shape: BoxShape.circle,
							  border: Border.all(color: Color(0xFFd10037), width: 2), // Border color and width
							),
							padding: const EdgeInsets.all(8.0), // Adjust the padding to make the circle size appropriate
							child: const Icon(Icons.emoji_emotions, color: Color(0xFFd10037)),
						),
						onPressed: _toggleEmojiPicker,
					),

                    const SizedBox(width: 4.0),
                    IconButton(
					  icon: Container(
						decoration: BoxDecoration(
						  shape: BoxShape.circle,
						  border: Border.all(color: Color(0xFFd10037), width: 2),
						),
						padding: const EdgeInsets.all(8.0), // Adjust the padding to make the circle size appropriate
						child: const Icon(Icons.attach_file, color: Color(0xFFd10037)),
					  ),
					  onPressed: () {
						showModalBottomSheet(
						  context: context,
						  builder: (context) {
							return Wrap(
							  children: [
								ListTile(
								  leading: const Icon(Icons.image, color: Color(0xFFd10037)),
								  title: const Text('Pick Image'),
								  onTap: _pickImage,
								),
								ListTile(
								  leading: const Icon(Icons.insert_drive_file, color: Color(0xFFd10037)),
								  title: const Text('Pick File'),
								  onTap: _pickFile,
								),
							  ],
							);
						  },
						);
					  },
					),

                    const SizedBox(width: 8.0),
                    FloatingActionButton(
					  onPressed: _sendMessage,
					  backgroundColor: AppColor.purple,
					  shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(100), // Adjust the value to make sure it remains circular
						side: BorderSide(color: AppColor.white, width: 2), // Border color and width
					  ),
					  child: const Icon(Icons.send, color: AppColor.white),
					),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
