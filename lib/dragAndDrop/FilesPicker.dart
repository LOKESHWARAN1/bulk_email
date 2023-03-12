import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulk_email/utils/font_style.dart';
import 'package:bulk_email/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DropZoneWidget.dart';
import 'DroppedFile.dart';
import 'File_Data_Model.dart';

class FilesPicker extends StatefulWidget {
  @override
  _FilesPickerState createState() => _FilesPickerState();
}

class _FilesPickerState extends State<FilesPicker> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File_Data_Model? file;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation $e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'files removed with success.'
              : 'Failed to clean files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation $e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            // height: Responsive.setHeight(value: 700),
            width: Responsive.setWidth(value: 205),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Responsive.setHeight(value: 30),
                ),
                DroppedFileWidget(file: file),
                SizedBox(
                  height: Responsive.setHeight(value: 300),
                  // width: Responsive.setWidth(value: 200),
                  child: DropZoneWidget(
                    onDroppedFile: (file) => setState(() {
                      this.file = file;
                    }),
                  ),
                )
              ],
            )),
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(width: Responsive.setWidth(value: 150),),
              DropdownButtonHideUnderline(
                child: Container(
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.0,
                            color: Colors.black26,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 2),
                      child: DropdownButton<FileType>(
                          hint: const Text('LOAD PATH FROM'),
                          value: _pickingType,
                          items: FileType.values
                              .map((fileType) => DropdownMenuItem<FileType>(
                                    value: fileType,
                                    child: Text(fileType.name),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                                _pickingType = value!;
                                if (_pickingType != FileType.custom) {
                                  _controller.text = _extension = '';
                                }
                              })),
                    )),
              ),
              SizedBox(
                width: Responsive.setWidth(value: 2),
              ),
              _pickingType == FileType.custom
                  ? ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: Responsive.setWidth(value: 25),
                          height: Responsive.setHeight(value: 38)),
                      child: TextFormField(
                        // maxLength: 15,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'File extension',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 5.0),
                            )),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                      ))
                  : const SizedBox(),
              SizedBox(
                height: Responsive.setHeight(value: 40),
                width: Responsive.setWidth(value: 40),
                // constraints: const BoxConstraints.tightFor(width: 200.0),
                child: SwitchListTile.adaptive(
                  title: const AutoSizeText(
                    'Pick multiple files',
                    textAlign: TextAlign.right,
                    maxLines: 4,
                    minFontSize: 5,
                  ),
                  onChanged: (bool value) => setState(() => _multiPick = value),
                  value: _multiPick,
                ),
              ),
              ElevatedButton(
                onPressed: () => _pickFiles(),
                child: getTextStyle(_multiPick ? 'Upload files' : 'Upload file',
                    FontWeight.normal, Colors.white, 15),
              ),

              SizedBox(
                width: Responsive.setWidth(value: 2),
              ),
              ElevatedButton(
                onPressed: () => _clearCachedFiles(),
                child: getTextStyle(
                    'Clear files', FontWeight.normal, Colors.white, 15),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              //   child: Column(
              //     children: <Widget>[
              //       ElevatedButton(
              //         onPressed: () => _pickFiles(),
              //         child: Text(_multiPick ? 'Pick files' : 'Pick file'),
              //       ),
              //       SizedBox(height: Responsive.setHeight(value: 5)),
              //       ElevatedButton(
              //         onPressed: () => _clearCachedFiles(),
              //         child: const Text('Clear files'),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        Builder(
          builder: (BuildContext context) => _isLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: CircularProgressIndicator(),
                )
              : _userAborted
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'User not selected the files.',
                      ),
                    )
                  : _directoryPath != null
                      ? ListTile(
                          title: const Text('Directory path'),
                          subtitle: Text(_directoryPath!),
                        )
                      : _paths != null
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: Scrollbar(
                                  child: ListView.separated(
                                itemCount: _paths != null && _paths!.isNotEmpty
                                    ? _paths!.length
                                    : 1,
                                itemBuilder: (BuildContext context, int index) {
                                  final bool isMultiPath =
                                      _paths != null && _paths!.isNotEmpty;
                                  final String name =
                                      'File ${index + 1}: ${isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
                                  final path = kIsWeb
                                      ? null
                                      : _paths!
                                          .map((e) => e.path)
                                          .toList()[index]
                                          .toString();

                                  return ListTile(
                                    title: Text(
                                      name,
                                    ),
                                    subtitle: Text(path ?? ''),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              )),
                            )
                          : const SizedBox(),
        ),
      ],
    );
  }
}
