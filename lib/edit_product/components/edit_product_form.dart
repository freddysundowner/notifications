import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    print("productController.product.id ${productController.product.id}");
    if (productController.product.id != null) {
      btnTxt = "Update";
      productController.titleFieldController.text =
          productController.product.name;

      productController.variantFieldController.text =
          productController.product.variations.join(",");

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
        SizedBox(height: 80.h),
        DefaultButton(
            text: btnTxt,
            press: () async {
              if (_basicDetailsFormKey.currentState!.validate()) {
                String snackbarMessage = "";
                var response;
                if (productController.product.id != null) {
                  response = productController
                      .updateProduct(productController.product.id!);
                } else {
                  response = productController.saveProduct();
                }

                try {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AsyncProgressDialog(
                        response,
                        message: Text(productController.product.id != null
                            ? "Updating product"
                            : "Creating product"),
                        onError: (e) {
                          snackbarMessage = e.toString();
                        },
                      );
                    },
                  );
                  snackbarMessage = productController.error.value;
                } finally {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackbarMessage),
                    ),
                  );
                  if (productController.error.value == "") {
                    Get.find<ProductController>().products =
                        await ProductController.getProductsByShop(
                            productController.product.shopId!);
                    Get.back();
                  }
                }
              }
            }),
        SizedBox(height: 10.h),
      ],
    );
    return column;
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

  Widget buildUploadImagesTile(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Upload Images",
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(Icons.image),
      childrenPadding: EdgeInsets.symmetric(vertical: 20.h),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
              ),
              color: kTextColor,
              onPressed: () {}),
        ),
        if (productController.product != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                productController.product.images.length,
                (index) => SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.network(
                          productController.product.images[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
