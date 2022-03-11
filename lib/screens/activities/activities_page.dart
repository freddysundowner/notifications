import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Activities",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 0.04.sw,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Full name",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ),
                            Text("11 Mar 2022 16:02 PM",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.sp))
                          ],
                        ),
                        SizedBox(height: 0.01.sh,),
                        Text("Full name started a room. Join?", style: TextStyle(color: Colors.black54, fontSize: 14.sp),)
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
