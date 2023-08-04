import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yo_bray/controller/with_file_upload.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/view/report/search_product_color_size_page.dart';
import 'package:yo_bray/widgets/image_preview_page.dart';
import 'package:yo_bray/widgets/toast.dart';
import 'package:yo_bray/widgets/video_player.dart';
import 'package:yo_bray/widgets/video_preview_page.dart';

class AddFeedPage extends StatefulWidget {
  final bool isFromActivity;
  final bool? isEditPage;
  final String? note;
  final dynamic networkImage;
  final int? id;
  AddFeedPage({
    Key? key,
    this.isFromActivity = false,
    this.note,
    this.isEditPage,
    this.networkImage,
    this.id,
  });

  @override
  _AddFeedPageState createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  final controller = Get.find<HomeController>();

  final _noteController = TextEditingController();
  List<String> networkImages = [];
  final _formKey = GlobalKey<FormState>();

  List<File> imageFiles = [];
  List<File> videoFiles = [];
  List<VideoPlayerController> _controllers = [];
  final int jobId = Get.arguments as int;
  String? selectedTitle;
  Map<String, dynamic>? _selectedProduct;

  bool isPicking = false;
  @override
  void initState() {
    if (widget.isEditPage!) {
      _noteController.text = widget.note ?? '';
      final listImagesSplit = widget.networkImage.toString().split(",");
      listImagesSplit.forEach((data) {
        networkImages.add(data);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isEditPage! ? 'Edit Feed' : 'Add Feed'),
          leadingWidth: leadingWidth),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            addProduct(),
            SizedBox(height: 10),
            showVideos(),
            SizedBox(height: 10),
            addVideo(),
            SizedBox(height: 10),
            showImages(),
            if (widget.networkImage != null) getFileWidget(networkImages),
            SizedBox(height: 10),
            addFile(),
            SizedBox(height: 10),
            TextFormField(
              controller: _noteController,
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: Color(0xffF2F2F2),
                filled: true,
                hintText: 'Note',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _submit,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget showImages() {
    var children = <Widget>[];
    imageFiles.asMap().forEach((int index, File file) {
      children.add(
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.file(file,
                      height: 60, width: 60, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    imageFiles.removeAt(index);
                    setState(() {});
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      );
    });
    return Wrap(children: children);
  }

  Widget showVideos() {
    var children = <Widget>[];
    _controllers.asMap().forEach((int index, VideoPlayerController controller) {
      children.add(
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: VideoPlayer(controller),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeVideo(index),
                ),
              )
            ],
          ),
        ),
      );
    });
    return Wrap(children: children);
  }

  void removeVideo(int index) {
    videoFiles.removeAt(index);
    _controllers.removeAt(index);
    setState(() {});
  }

  Widget getFileWidget(List<String> network) {
    if (network.isEmpty) return SizedBox();

    return Wrap(
      children: networkImages.map((e) {
        if (GetUtils.isImage(e))
          return Stack(
            children: [
              imageView(e),
              IconButton(
                onPressed: () {
                  networkImages.remove(e);
                  controller
                      .deleteFeedImage(id: widget.id, imageName: e)
                      .then((value) {
                    controller.feedback(id: widget.id.toString());
                  });
                  setState(() {});
                },
                icon: Icon(Icons.delete, color: Colors.red),
              )
            ],
          );
        else if (GetUtils.isVideo(e)) return videoView(e);
        return videoView(e);
      }).toList(),
    );
  }

  Widget videoView(String e) {
    return InkWell(
      onTap: () {
        Get.to(() => VideoPreviewPage(path: e));
      },
      child: VideoPlayerWidget(path: e),
    );
  }

  Widget imageView(String e) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 130,
        maxWidth: 130,
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => ImagePreviewPage(imagePath: Urls.feedbackFile + e));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CachedNetworkImage(
            imageUrl: Urls.feedbackFile + e,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Image.asset('assets/dumy.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (imageFiles.length == 0 &&
        videoFiles.length == 0 &&
        _noteController.text.isEmpty &&
        selectedTitle == null) {
      errorToast('Fill Up at least one field');
      return;
    }
    final body = {
      'job_id': jobId,
      'description': _noteController.text,
      '_method': 'post',
      if (selectedTitle != null) 'product_title': selectedTitle!,
    };

    controller.feedback(id: jobId.toString());
    myShowDialog();

    if (selectedTitle != null) {
      final getProduct = _selectedProduct!['color_size'] as ColorSizeModel;

      final Map<String, dynamic> body = {
        'product_id': '${getProduct.productId!}',
        'quantity': '1',
        'price': '${getProduct.salePrice}',
        'color_size': selectedTitle,
        'color_size_id': "${getProduct.id}",
        'sell_price ': 'Regular'
      };
      final quantity = int.parse(getProduct.quantity ?? '0');

      if (quantity > 0) {
        await controller.submitProductSell(body);
        controller.feedback(id: jobId.toString());
      } else {
        errorToast("Product quantity 0 you can't sale");
      }
    }

    WithFileUpload withFileUpload = WithFileUpload();
    final result = await withFileUpload.feedBack(
        body, imageFiles, videoFiles, widget.isEditPage!, widget.id.toString());

    if (result) {
      if (widget.isFromActivity) {
        final _controller = Get.find<ActivityController>();
        await _controller.fetchActivityJobs();
        await controller.feedback(id: jobId.toString());
      } else
        await controller.fetchJobs(DateTime.now());
      await controller.feedback(id: jobId.toString());
      if (Get.isDialogOpen!) Get.back();
      Get.back(result: true);
    }
  }

  Widget addFile() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      color: Colors.black,
      strokeWidth: 1,
      child: InkWell(
        onTap: () => _pickImages(),
        child: Container(
          height: 60,
          child: isPicking
              ? Center(child: loading)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text('add image'),
                  ],
                ),
        ),
      ),
    );
  }

  Widget addVideo() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      color: Colors.black,
      strokeWidth: 1,
      child: InkWell(
        onTap: () => _pickVideos(),
        child: Container(
          height: 60,
          child: isPicking
              ? Center(child: loading)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_settings),
                    SizedBox(width: 10),
                    Text('add video'),
                  ],
                ),
        ),
      ),
    );
  }

  Widget get loading => CircularProgressIndicator();

  Widget addProduct() {
    if (selectedTitle != null)
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(5),
        color: Colors.black,
        strokeWidth: 1,
        child: InkWell(
          onTap: _selectProduct,
          child: Container(
            height: 60,
            child: Center(child: Text(selectedTitle ?? '')),
          ),
        ),
      );
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      color: Colors.black,
      strokeWidth: 1,
      child: InkWell(
        onTap: _selectProduct,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.production_quantity_limits),
              SizedBox(width: 10),
              Text('add product'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectProduct() async {
    final returnData = await Get.to(() => SearchProductColorSizePage());
    if (returnData != null) {
      _selectedProduct = returnData;
      selectedTitle = _selectedProduct!['title'] as String;
      final getProduct = _selectedProduct!['color_size'] as ColorSizeModel;
      print(getProduct);
      print(selectedTitle);
      setState(() {});
    }
  }

  Future<void> _pickImages() async {
    final source = await Utils.showImageSource(context);
    if (source == null) return;

    final _pickFile = await Utils.pickFile(source);
    if (_pickFile == null) return;

    imageFiles.add(File(_pickFile.path));

    setState(() {});
  }

  Future<void> _pickVideos() async {
    final source = await Utils.showImageSource(context);
    if (source == null) return;

    final _pickFile = await Utils.pickVideo(source);
    if (_pickFile == null) return;

    final videoCtr = VideoPlayerController.file(
      File(_pickFile.path),
    )..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });

    _controllers.add(videoCtr);
    videoFiles.add(File(_pickFile.path));

    setState(() {});
  }
}
