import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tele_doctor_super_admin/modules/update_user_screen.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../models/admin_model.dart';
import '../shared/component/components.dart';
import '../shared/constants/constants.dart';
import 'add_admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: myAppBar(appBarText: 'Admins', icon: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                elevation: 24.0,
                                title: Text('Are You Sure?',
                                    style: TextStyle(color: primaryColor)),
                                content: Text('You will log out',
                                    style: TextStyle(color: primaryColor)),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Container(
                                      child: Text(
                                        'Log out',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    onPressed: () {
                                      cubit.logOut(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('Cancel',
                                        style: TextStyle(color: primaryColor)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ));
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      color: Colors.red[400],
                      size: 40,
                    )),
              )
            ]),
            body: RefreshIndicator(
              onRefresh: () async => cubit.getUsers(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.05,
                      horizontal: size.width * .05),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.admins2.length,
                        itemBuilder: (context, index) {
                          return myCard(context, cubit.admins2[index]);
                        },
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 3 / 5,
                            crossAxisSpacing: size.width * .03,
                            mainAxisSpacing: size.height * .02),
                      ),
                      SizedBox(
                        height: size.height,
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Container(
              height: size.height * .1,
              width: size.width * .18,
              child: FloatingActionButton(
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
                onPressed: () {
                  navigateTo(context, AddAdminScreen());
                },
              ),
            ),
          );
        });
  }
}

Widget myCard(context, AdminModel admin) => InkWell(
      onTap: () {
        navigateTo(context, UpdateAdminScreen(admin: admin));
      },
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: blue4, borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Column(
          children: [
            CircleAvatar(
              backgroundColor: blue10,
              backgroundImage: const AssetImage('images/user.png'),
              radius: 42,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '${admin.name?.toUpperCase()}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${admin.hospitalName?.toUpperCase()}',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
            )
          ],
        )),
      ),
    );
