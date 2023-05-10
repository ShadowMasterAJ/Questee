// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../utils/custom_rect_tween.dart';
import '../utils/hero_dialog_route.dart';

class UploadReceiptModalBottomSheet extends StatefulWidget {
  const UploadReceiptModalBottomSheet({
    Key? key,
    required this.jobRef,
  }) : super(key: key);
  final DocumentReference jobRef;

  @override
  State<UploadReceiptModalBottomSheet> createState() =>
      _UploadReceiptModalBottomSheetState();
}

class _UploadReceiptModalBottomSheetState
    extends State<UploadReceiptModalBottomSheet> {
  List<XFile> _chosenImages = [];
  late double maxWidth;
  bool selectedImages = false,
      filesUploaded = false,
      isUploading = false,
      pickedInExcess = false,
      alreadyUploadedBefore = false;

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;

    // if (_imageFile != null) print('IMAGE: ${_imageFile!.path}');
    return ElevatedButton(
      onPressed: () async {
        await CheckIfUploadedAlready();

        print(
            "BEFORE\nselectedImages\t\t$selectedImages\nfilesUploaded\t\t$filesUploaded\nisUploading\t\t\t$isUploading\npickedInExcess\t\t$pickedInExcess\nalreadyUploadedBefore\t$alreadyUploadedBefore\n\n");

        ShowBottomSheet(maxWidth);
      },
      child: Text(
        'Upload Receipt(s)',
        style: FlutterFlowTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        minimumSize: Size(340, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future ShowBottomSheet(double maxWidth) {
    print('WIDTH: $maxWidth');

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: !isUploading,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        print('FILES UPLOADED: $filesUploaded');
        return DraggableScrollableSheet(
          initialChildSize: filesUploaded
              ? 0.45
              : selectedImages
                  ? 0.55
                  : 0.6,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackgroundLight,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SheetLever(),
                  Visibility(
                    visible: alreadyUploadedBefore,
                    child: UserReuploadOptions(context, maxWidth),
                  ),
                  Visibility(
                    visible: !alreadyUploadedBefore && filesUploaded,
                    child: UploadSuccessIllustration(maxWidth, context),
                  ),
                  Visibility(
                    visible: !alreadyUploadedBefore &&
                        !filesUploaded &&
                        !selectedImages,
                    child: PickImagesButton(context, maxWidth),
                  ),
                  Visibility(
                      visible: !alreadyUploadedBefore &&
                          !filesUploaded &&
                          selectedImages,
                      child: SizedBox(height: 20)),
                  Visibility(
                    visible: !alreadyUploadedBefore &&
                        !filesUploaded &&
                        selectedImages,
                    child: Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              AddImageAfterSelectionButton(context),
                              ImagesViewRow(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !alreadyUploadedBefore &&
                          !filesUploaded &&
                          selectedImages,
                      child: UploadImagesButton(context))
                ],
              ),
            );
          },
        );
      },
    );
  }

  Expanded UserReuploadOptions(BuildContext context, double maxWidth) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 7,
            child: SvgPicture.asset(
              'assets/illustrations/receipt_upload_warning.svg',
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(10),
              child: Text(
                "YOU HAVE ALREADY UPLOADED RECEIPTS.\nDO YOU WANT TO REUPLOAD?",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
              ),
            ),
          ),
          Flexible(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ReuploadImagesUserChoiceButton(context,
                        choice: 'Yes', onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        alreadyUploadedBefore = false;
                        selectedImages = false;
                        _chosenImages = [];
                      });
                      ShowBottomSheet(maxWidth);
                    }, color: FlutterFlowTheme.of(context).buttonGreen),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ReuploadImagesUserChoiceButton(context,
                        choice: 'No',
                        onTap: () => Navigator.of(context).pop(),
                        color: FlutterFlowTheme.of(context).buttonRed),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Container ReuploadImagesUserChoiceButton(BuildContext context,
      {required Color color,
      required String choice,
      required void Function() onTap}) {
    return Container(
      child: FFButtonWidget(
        onPressed: onTap,
        text: choice,
        options: FFButtonOptions(
          width: double.infinity,
          height: double.infinity,
          color: color,
          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                fontFamily: 'Poppins',
                color: FlutterFlowTheme.of(context).primaryText,
              ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Expanded UploadSuccessIllustration(double maxWidth, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 7,
            child: SvgPicture.asset(
              'assets/illustrations/receipts_uploaded.svg',
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).buttonGreen,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(10),
              child: Text(
                "Upload Successful!",
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded PickImagesButton(BuildContext context, double maxWidth) {
    return Expanded(
      child: GestureDetector(
        onTap: () async => await Choose_and_AddImages(context, maxWidth),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackgroundDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: !selectedImages
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          '1. Finished buying the items? Upload the receipt!\n2. Make sure the items and price are clearly visible\n3. Select a maximimum of 5 zoomed-in shots if needed',
                          style: FlutterFlowTheme.of(context).bodyText1,
                          // textAlign: TextAlign.cesnter,
                        ),
                        SizedBox(height: 30),
                        Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: FlutterFlowTheme.of(context).primaryColorLight,
                        ),
                        Spacer(),
                        Spacer(),
                      ],
                    )
                  : null),
        ),
      ),
    );
  }

  GestureDetector AddImageAfterSelectionButton(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Choose_and_AddImages(context, maxWidth),
      child: Container(
        height: 250,
        width: 50,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackgroundDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: FlutterFlowTheme.of(context).primaryColorLight)),
        child: Center(
            child: Icon(
          Icons.add_a_photo_rounded,
          color: FlutterFlowTheme.of(context).primaryColorLight,
          size: 30,
        )),
      ),
    );
  }

  Expanded ImagesViewRow(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _chosenImages.length,
            (index) => Stack(
              children: [
                InkWell(
                  onTap: (() {
                    Navigator.of(context).push(
                      HeroDialogRoute(
                        builder: (context) => Center(
                          child: Hero(
                              createRectTween: (begin, end) {
                                return CustomRectTween(begin: begin, end: end);
                              },
                              tag: 'imageHero$index',
                              child: ImageExpandedViewHero(maxWidth, index)),
                        ),
                      ),
                    );
                  }),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 250,
                    width: maxWidth * 0.40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(
                            _chosenImages[_chosenImages.length - index - 1]
                                .path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                DeleteImageButton(context, index, maxWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned DeleteImageButton(
      BuildContext context, int index, double maxWidth) {
    return Positioned(
      top: 0,
      right: 5,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();

          setState(() {
            _chosenImages.removeAt(_chosenImages.length - index - 1);
            if (_chosenImages.isEmpty) selectedImages = false;
            if (_chosenImages.length <= 5) pickedInExcess = false;
          });
          ShowBottomSheet(maxWidth);
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Container ImageExpandedViewHero(double maxWidth, int index) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500, maxWidth: maxWidth * 0.7),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(
              File(_chosenImages[_chosenImages.length - index - 1].path)),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Container SheetLever() {
    return Container(
      width: 40,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container UploadImagesButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: FFButtonWidget(
        onPressed: () async {
          if (isUploading) return;
          print('STARTING UPLOAD...');
          setState(() => isUploading = true);

          try {
            List<String>? urls = await uploadImagesToFirebaseStorage(
              fileNamePrefix: 'receipt',
              imageFiles: _chosenImages,
              storagePath: '${widget.jobRef.id}/verification_receipts',
            );

            if (urls != null) {
              print('UPLOADED Images to firebase storage!');
              await uploadImageUrlsToFirestore(urls);
              print('UPLOADED image urls to firestore!');

              setState(() => filesUploaded = true);
              Navigator.of(context).pop();
              ShowBottomSheet(maxWidth);
            } else {
              throw Exception('Failed to upload images.');
            }
          } catch (e) {
            print("Error: $e");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to submit receipts. Please try again.'),
            ));
          } finally {
            setState(() => isUploading = false);
          }
        },
        text: isUploading ? 'Submitting...' : 'Submit Receipts',
        options: FFButtonOptions(
          width: double.infinity,
          height: 50,
          color: FlutterFlowTheme.of(context).primaryColor,
          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                fontFamily: 'Poppins',
                color: FlutterFlowTheme.of(context).primaryText,
              ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Shows an [AlertDialog] with a message that informs the user that they can only choose up to 5 images.
  Future<void> _showImageLimitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackgroundLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Too Many Images!',
            style: FlutterFlowTheme.of(context).subtitle1,
          ),
          content: Text('You can only choose up to 5 images.',
              style: FlutterFlowTheme.of(context)
                  .bodyText1
                  .copyWith(fontSize: 16)),
          actionsAlignment: MainAxisAlignment.center,
          elevation: 10,
          shadowColor: FlutterFlowTheme.of(context).primaryColorLight,
          actionsPadding: EdgeInsets.only(bottom: 15),
          actions: [
            FFButtonWidget(
                text: "OK",
                onPressed: () => Navigator.of(context).pop(),
                options: FFButtonOptions(
                    padding: EdgeInsets.all(10),
                    width: 150,
                    height: 50,
                    borderRadius: BorderRadius.circular(10),
                    textStyle: FlutterFlowTheme.of(context)
                        .bodyText1
                        .copyWith(fontSize: 16),
                    color: FlutterFlowTheme.of(context).primaryColor))
          ],
        );
      },
    );
  }

  /// This method allows the user to choose images from their device's storage and add them to the current list of chosen images.
  /// The method takes in two parameters: a [BuildContext] and a [double] representing the maximum width of the device screen.
  /// The method returns a [Future] of type [void].
  /// If the number of currently chosen images and the images picked by the user is greater than 5, the method shows an image limit dialog and sets the state accordingly.
  /// Otherwise, the chosen images are added to the current list of chosen images, and the state is updated accordingly.
  /// The method also prints the chosen images and the current state of different variables to the console.
  /// Finally, the method dismisses the bottom sheet and shows the updated list of chosen images in a new bottom sheet.
  Future<void> Choose_and_AddImages(
      BuildContext context, double maxWidth) async {
    List<XFile> currentlyPicked = await ChooseImages();

    if (_chosenImages.length + currentlyPicked.length > 5) {
      debugPrint(
          'EXCESS IMAGES PRESENT: ${_chosenImages.length}(Chosen)+${currentlyPicked.length}(Picked)=${_chosenImages.length + currentlyPicked.length}');
      setState(() => pickedInExcess = true);
      await _showImageLimitDialog(context);
    } else {
      setState(() {
        pickedInExcess = false;
        selectedImages = true;
        _chosenImages
            .addAll(currentlyPicked.sublist(0, currentlyPicked.length));
      });
    }

    print('CHOSEN IMAGES:\t$_chosenImages');
    print(
        'AFTER\nselectedImages\t\t$selectedImages\nfilesUploaded\t\t$filesUploaded\nisUploading\t\t\t$isUploading\npickedInExcess\t\t$pickedInExcess\nalreadyUploadedBefore\t$alreadyUploadedBefore\n\n');
    Navigator.of(context).pop();
    ShowBottomSheet(maxWidth);
  }

  /// Checks if the job record associated with the widget's [jobRef] has verification images already uploaded.
  /// If verification images are found, it sets the [alreadyUploadedBefore] flag to true and [filesUploaded] flag to false.
  /// This function is asynchronous and returns a [Future] with no return value.
  Future<void> CheckIfUploadedAlready() async {
    final DocumentSnapshot snapshot = await widget.jobRef.get();
    final currUrls = snapshot.data() as Map<String, dynamic>;
    final List<dynamic> currUrlsList = currUrls['verificationImages'];
    if (currUrlsList.length > 0)
      setState(() {
        alreadyUploadedBefore = true;
        filesUploaded = false;
      });
  }

  /// Opens the device's image picker and allows the user to select multiple images. Returns a list of [XFile] objects representing the chosen images.
  Future<List<XFile>> ChooseImages() async {
    final picker = ImagePicker();
    List<XFile> pickedFiles = await picker.pickMultiImage();
    print('PICKED FILES LENGTH: ${pickedFiles.length}');
    return pickedFiles;
  }

  /// Uploads a list of [imageFiles] to Firebase Storage with a [fileNamePrefix] and [storagePath].
  ///
  /// The previous images in the given [storagePath] are deleted before uploading new images to avoid overwriting them.
  ///
  /// Returns a list of [String] download URLs of the uploaded images, or null if an error occurs.
  Future<List<String>?> uploadImagesToFirebaseStorage({
    required List<XFile> imageFiles,
    required String fileNamePrefix,
    required String storagePath,
  }) async {
    await ClearPreviousImages(storagePath);
    final List<String> downloadUrls = await uploadImagesAndGetDownloadUrls(
        imageFiles, storagePath, fileNamePrefix);
    return downloadUrls;
  }

  /// This function deletes all the images present in the Firebase Storage at the given [storagePath].
  ///
  /// It first creates a reference to the storage path and gets a list of all the items present in it.
  /// It then deletes all the items (in this case, images) using Future.wait().
  Future<void> ClearPreviousImages(String storagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(storagePath);
    ListResult listResult = await ref.listAll();
    await Future.wait(listResult.items.map((itemRef) => itemRef.delete()));
  }

  /// Uploads a list of image files to Firebase Storage and retrieves the download URLs of the uploaded images.
  ///
  /// Takes a list of XFile objects, representing the image files to be uploaded, a [storagePath]
  /// and a [fileNamePrefix] for generating the storage path and filenames. Returns a [List] of
  /// [String]s, representing the download URLs of the uploaded images.
  ///
  /// Each image file is uploaded concurrently using the [putFile] method of [Reference], and the
  /// download URL of each uploaded file is retrieved using the [getDownloadURL] method of [TaskSnapshot].
  /// If an error occurs during upload, an empty string is returned.
  Future<List<String>> uploadImagesAndGetDownloadUrls(
      List<XFile> imageFiles, String storagePath, String fileNamePrefix) async {
    List<Future<String>> uploadTasks = [];
    for (int i = 0; i < imageFiles.length; i++) {
      String fileName = '$fileNamePrefix\_$i';
      String path = '$storagePath/$fileName';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      uploadTasks.add(ref
          .putFile(File(imageFiles[i].path))
          .then((TaskSnapshot taskSnapshot) {
        return taskSnapshot.ref.getDownloadURL();
      }).catchError((error) {
        print('ERROR UPLOADING IMAGE: $error');
        return '';
      }));
    }
    List<String> downloadUrls = await Future.wait(uploadTasks);
    return downloadUrls;
  }

  /// Uploads the given list of image download URLs to Firestore and updates the verificationImages field in the job record.
  ///
  /// Args:
  /// - downloadUrls: A list of strings representing the download URLs of the images to be uploaded.
  ///
  /// Returns: void.
  Future<void> uploadImageUrlsToFirestore(List<String> downloadUrls) async {
    try {
      final jobUpdateData =
          createJobRecordData(verificationImages: downloadUrls);
      await widget.jobRef.update(jobUpdateData);
      print('Verification receipts uploaded to Firestore successfully');
    } catch (error) {
      print('ERROR UPLOADING VERIFICATION RECEIPTS: $error');
    }
  }
}
