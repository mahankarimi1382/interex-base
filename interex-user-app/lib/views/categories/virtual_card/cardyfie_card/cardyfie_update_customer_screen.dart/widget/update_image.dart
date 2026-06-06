import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../../../../../../backend/utils/custom_snackbar.dart';

import '../../../../../../utils/basic_screen_imports.dart';
import '../../../../../../widgets/payment_link/image_picker_sheet.dart';
import '../../../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../controller/cardyfie_update_customer_controller.dart';

File? imageFile;

class SelectedImageWidget extends StatefulWidget {
  const SelectedImageWidget({
    super.key,
    required this.labelName,
    required this.fieldName,
    this.imageUrl,
    this.optionalLabel = '',
  });

  final String labelName;
  final String fieldName;
  final String? imageUrl;
  final String optionalLabel;

  @override
  State<SelectedImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<SelectedImageWidget> {
  final controller = Get.put(UpdateCustomerCardyfieController());

  Future pickImage(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (image == null) return;

      imageFile = File(image.path);

      if (controller.listFieldName.isNotEmpty) {
        if (controller.listFieldName.contains(widget.fieldName)) {
          int itemIndex = controller.listFieldName.indexOf(widget.fieldName);
          controller.listFieldName[itemIndex] = widget.fieldName;
          controller.listImagePath[itemIndex] = imageFile!.path;
        } else {
          controller.listImagePath.add(imageFile!.path);
          controller.listFieldName.add(widget.fieldName);
        }
      } else {
        controller.listImagePath.add(imageFile!.path);
        controller.listFieldName.add(widget.fieldName);
      }
      setState(() {
        controller.updateImageData(widget.fieldName, imageFile!.path);
      });
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImagePickerBottomSheet(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: CustomTitleHeadingWidget(
              text: widget.labelName,
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? CustomColor.whiteColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ),
          ),
          if (widget.optionalLabel != '')
            TitleHeading5Widget(
              text: widget.optionalLabel,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.headingTextSize5,
              color: CustomColor.primaryLightColor.withValues(alpha: .8),
            ),
          verticalSpace(Dimensions.marginBetweenInputTitleAndBox),

          Container(
            height: controller.getImagePath(widget.fieldName) == null
                ? MediaQuery.of(context).size.height * 0.15
                : MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius),
              border: RDottedLineBorder.all(
                color: CustomColor.primaryLightColor,
              ),
              image: controller.getImagePath(widget.fieldName) == null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.imageUrl ?? ''),
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(controller.getImagePath(widget.fieldName) ?? ''),
                      ),
                    ),
            ),
            child: controller.getImagePath(widget.fieldName) == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: CustomColor.primaryLightColor,
                      ),
                      SizedBox(width: Dimensions.widthSize * 0.5),
                      TitleHeading4Widget(text: Strings.uploadImage),
                    ],
                  )
                : const Row(children: []),
          ),
          verticalSpace(Dimensions.heightSize * 0.3),
        ],
      ),
    );
  }

  _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: ImagePickerSheet(
            fromCamera: () {
              pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
            fromGallery: () {
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
