import 'package:app_task/constants/colors.dart';
import 'package:app_task/constants/images.dart';
import 'package:app_task/utilities/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/screen_launcher_bloc.dart';

class ScreenLauncherView extends StatelessWidget {
  const ScreenLauncherView({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          ScreenLauncherBloc(context)..add(InitializeScreenLauncherEvent()),
      child: Scaffold(
        backgroundColor: appColor,
        body: BlocBuilder<ScreenLauncherBloc, ScreenLauncherState>(
          builder: (context, state) {
            if (state is ScreenLauncherErrorState) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            return Center(
              child: Container(
                height: sizeScreen.height * 0.2,
                width: sizeScreen.height * 0.2,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Image.asset(
                  appIcon,
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
