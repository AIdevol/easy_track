import 'package:app_task/constants/colors.dart';
import 'package:app_task/constants/images.dart';
import 'package:app_task/utilities/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      floatingActionButton: _buttonView(context),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Gap(70), _headerDetailsView(context)],
        ),
      ),
    );
  }
}

/// Header view
_headerDetailsView(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habitron",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            "Welcome, Devesh",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () => context.go('/profile'),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(appIcon),
        ),
      )
    ],
  );
}

///button view

_buttonView(BuildContext context) {
  return InkWell(
    onTap: () {
      context.go("/createTask");
    },
    child: CustomContainer(
      outerShadow: CustomContainer.softOuterShadow(),
      backgroundColor: appColor,
      height: 70,
      width: 70,
      borderRadius: 40,
      child: Icon(
        Icons.add,
        size: 45,
      ),
    ),
  );
}
