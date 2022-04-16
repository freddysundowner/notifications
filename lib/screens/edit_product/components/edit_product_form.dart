import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/firestore_files_access_service.dart';
import 'package:fluttergistshop/services/local_files_access_service.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class EditProductForm extends StatelessWidget {
  Product? product;
  EditProductForm({
    Key? key,
    this.product,
  }) : super(key: key);

  final _basicDetailsFormKey = GlobalKey<FormState>();
  final _describeProductFormKey = GlobalKey<FormState>();
  ProductController productController = Get.find<ProductController>();

  bool newProduct = true;
  String btnTxt = "Save Product";

  @override
  void dispose() {}

  @override
  void initState() {}

  Future<bool> uploadProductImages(
      String productId, BuildContext context) async {
    bool allImagesUpdated = true;
    for (int i = 0; i < productController.selectedImages.length; i++) {
      if (productController.selectedImages[i].imgType == ImageType.local) {
        print("Image being uploaded: " +
            productController.selectedImages[i].path);
        String? downloadUrl;
        try {
          final imgUploadFuture = FirestoreFilesAccess().uploadFileToPath(
              File(productController.selectedImages[i].path),
              ProductPI.getPathForProductImage(productId, i));
          downloadUrl = await showDialog(
            context: context,
            builder: (context) {
              return AsyncProgressDialog(
                imgUploadFuture,
                message: Text(
                    "Uploading Images ${i + 1}/${productController.selectedImages.length}"),
              );
            },
          );
        } finally {
          if (downloadUrl != null) {
            productController.selectedImages[i] =
                CustomImage(imgType: ImageType.network, path: downloadUrl);
          } else {
            allImagesUpdated = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Couldn't upload image ${i + 1} due to some issue",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: sc_snackBar,
              ),
            );
          }
        }
      }
    }
    return allImagesUpdated;
  }

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      btnTxt = "Update";
      productController.titleFieldController.text =
          productController.product.name!;

      productController.variantFieldController.text =
          productController.product.variations!.join(",");

      productController.originalPriceFieldController.text =
          productController.product.price.toString();

      productController.qtyFieldController.text =
          productController.product.quantity.toString();

      productController.desciptionFieldController.text =
          productController.product.description!;
    } else {
      productController.titleFieldController.text = "";

      productController.variantFieldController.text = "";

      productController.originalPriceFieldController.text = "";

      productController.qtyFieldController.text = "";

      productController.desciptionFieldController.text = "";
    }
    final column = Column(
      children: [
        buildBasicDetailsTile(context),
        SizedBox(height: 10.h),
        buildDescribeProductTile(context),
        SizedBox(height: 10.h),
        buildUploadImagesTile(context),
        Obx(() {
          if (productController.selectedImages.value.length > 0) {
            return SizedBox(height: 80.h);
          } else {
            return SizedBox(height: 20.h);
          }
        }),
        DefaultButton(
            text: btnTxt,
            press: () async {
              await _saveProduct(context);
            }),
        SizedBox(height: 10.h),
      ],
    );
    return column;
  }

  Future<void> _saveProduct(BuildContext context) async {
    if (_basicDetailsFormKey.currentState!.validate()) {
      String snackbarMessage = "";
      var response;
      if (product != null) {
        response =
            productController.updateProduct(productController.product.id!);
      } else {
        if (productController.selectedImages.length == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "add atleast one image",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        response = productController.saveProduct();
      }
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            response,
            message: Text(productController.productObservable.value != null
                ? "Updating product"
                : "Creating product"),
            onError: (e) {
              snackbarMessage = e.toString();
            },
          );
        },
      );
      snackbarMessage = productController.error.value;

      var waitedResponse = await response;
      Product productresponse = Product.fromJson(waitedResponse["data"]);
      productresponse.ownerId = Get.find<AuthController>().usermodel.value;
      productresponse.shopId =
          Get.find<AuthController>().usermodel.value!.shopId;

      await uploadProductImages(productresponse.id!, context);

      List<dynamic> downloadUrls = productController.selectedImages
          .map((e) => e.imgType == ImageType.network ? e.path : null)
          .toList();

      bool productFinalizeUpdate = false;
      try {
        final updateProductFuture =
            ProductPI.updateProductsImages(productresponse.id!, downloadUrls);
        productFinalizeUpdate = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              updateProductFuture,
              message: const Text("Saving Product"),
            );
          },
        );
        if (productFinalizeUpdate == true) {
          snackbarMessage = product != null
              ? "Product updated successfully"
              : "Product uploaded successfully";
          productController.selectedImages.value = [];
        } else {
          throw "Couldn't upload product properly, please retry";
        }
      } on FirebaseException catch (e) {
        snackbarMessage = "Something went wrong $e";
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        if (Get.find<AuthController>().usermodel.value!.shopId! != null) {
          await ProductController.getMyProductsByShop(
              Get.find<AuthController>().usermodel.value!.shopId!.id!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackbarMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: sc_snackBar,
          ),
        );
        Get.back();
      }
    }
  }

  Widget buildBasicDetailsTile(BuildContext context) {
    return Form(
      key: _basicDetailsFormKey,
      child: ExpansionTile(
        initiallyExpanded: true,
        maintainState: true,
        title: Text(
          "Basic Details",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: Icon(
          Icons.shop,
        ),
        childrenPadding: EdgeInsets.symmetric(vertical: 20.h),
        children: [
          buildTitleField(),
          SizedBox(height: 20.h),
          buildVariantField(),
          SizedBox(height: 20.h),
          buildOriginalPriceField(),
          SizedBox(height: 20.h),
          buildDiscountPriceField(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget buildDescribeProductTile(BuildContext context) {
    return Form(
      key: _describeProductFormKey,
      child: ExpansionTile(
        maintainState: true,
        title: Text(
          "Describe Product",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: Icon(
          Icons.description,
        ),
        childrenPadding: EdgeInsets.symmetric(vertical: 20.h),
        children: [
          buildDescriptionField(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Future<void> addImageButtonCallback(BuildContext context,
      {int? index}) async {
    String path = "";
    path = await choseImageFromLocalFiles(context);
    print(path);
    if (path == null) {
      throw LocalImagePickingUnknownReasonFailureException();
    }
    if (path == null) {
      return;
    }
    if (index == null) {
      productController.selectedImages
          .add(CustomImage(imgType: ImageType.local, path: path));
    } else {
      if (index < productController.selectedImages.value.length) {
        productController.selectedImages[index] =
            CustomImage(imgType: ImageType.local, path: path);
      }
    }
  }

  Widget buildUploadImagesTile(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Upload Images",
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(Icons.image),
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
              ),
              color: kTextColor,
              onPressed: () {
                addImageButtonCallback(context);
              }),
        ),
        Obx(() => Container(
              height:
                  productController.selectedImages.value.length == 0 ? 0 : 90.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productController.selectedImages.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 90.h,
                    height: 90.h,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          addImageButtonCallback(context, index: index);
                        },
                        child: productController
                                    .selectedImages[index].imgType ==
                                ImageType.local
                            ? Image.memory(File(productController
                                    .selectedImages[index].path)
                                .readAsBytesSync())
                            : Image.network(
                                productController.selectedImages[index].path),
                      ),
                    ),
                  );
                },
              ),
            )),
      ],
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: productController.titleFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Samsung Galaxy F41 Mobile",
        labelText: "Product Title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (productController.titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildVariantField() {
    return TextFormField(
      controller: productController.variantFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Fusion Green",
        labelText: "Variant",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (productController.variantFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      controller: productController.desciptionFieldController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText:
            "e.g., This a flagship phone under made in India, by Samsung. With this device, Samsung introduces its new F Series.",
        labelText: "Description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (productController.desciptionFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildOriginalPriceField() {
    return TextFormField(
      controller: productController.originalPriceFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g., 5999.0",
        labelText: "Price (in $currencySymbol)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (productController.originalPriceFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDiscountPriceField() {
    return TextFormField(
      controller: productController.qtyFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g. 34",
        labelText: "Qty",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (productController.qtyFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
