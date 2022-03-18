import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f5f5),
        title: Text("Orders", style: const TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: 10,
          itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10,top: 10),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("12/03/2022", style: TextStyle(color: Colors.grey, fontSize: 12.sp),)),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text("Product name", style: TextStyle(color: Colors.black, fontSize: 16.sp),)),
                Row(
                  children: [
                    Text("Status: ", style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                    Text("Pending", style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                  ],
                ),Row(
                  children: [
                    Text("Total: ", style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                    Text("1200", style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
