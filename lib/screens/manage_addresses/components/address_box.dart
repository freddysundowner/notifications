import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/services/api_calls.dart';

import '../../../utils/utils.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.name}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${address.addrress1}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${address.city}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${address.phone}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
