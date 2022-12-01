import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../models/admin_model.dart';
import '../shared/component/components.dart';
import '../shared/constants/constants.dart';


class UpdateAdminScreen extends StatelessWidget {

  final AdminModel admin;
  UpdateAdminScreen({super.key, required this.admin});


  var adminNameController = TextEditingController();
  var adminIdController = TextEditingController();
  var adminEmailController = TextEditingController();
  var adminPasswordController = TextEditingController();
  var adminPhoneController = TextEditingController();
  var hospitalNameController = TextEditingController();
  var hospitalLocationController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool inProgress=false;

    return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if(state is UpdateAdminDataLoadingState)
          {
            inProgress=true;
          }
          else {
            inProgress=false;
          }

          if(state is UpdateAdminDataSuccessState)
          {
            showToast(
                text: 'Admin Updated Successfully',
                state: ToastStates.SUCCESS
            );

          }
          if(state is UpdateAdminDataErrorState)
          {
            showToast(
                text: '${state.error}',
                state: ToastStates.ERROR
            );
          }


        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          if(admin!=null&&admin.email!=adminEmailController.text.trim()
          &&admin.name!=adminNameController.text.trim()
          &&admin.id!=adminIdController.text.trim()
          &&admin.password!=adminPasswordController.text.trim()
          &&admin.hospitalName!=hospitalNameController.text.trim()
          &&admin.hospitalLocation!=hospitalLocationController.text.trim()
          &&admin.phone!=adminPhoneController.text.trim()


          ) {
            adminEmailController.text =admin.email!;
            adminNameController.text =admin.name!;
            adminIdController.text =admin.id!;
            adminPasswordController.text =admin.password!;
            hospitalNameController.text =admin.hospitalName!;
            hospitalLocationController.text =admin.hospitalLocation!;
            adminPhoneController.text =admin.phone!;

          }
          return Scaffold(
            appBar: myAppBar(appBarText: 'Update Admin Data',
            icon: [Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: ()
                  {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        elevation: 24.0,
                        title: Text('Are You Sure?',style: TextStyle(color:primaryColor)),
                        content: Text(
                            'You will delete this admin',style: TextStyle(color:primaryColor)),
                        actions: [
                          CupertinoDialogAction(
                            child: Container(
                              child: Text('Delete',
                                style: TextStyle(color: Colors.red),),

                            ),
                            onPressed: () {
                              cubit.deleteAdminData(uId: admin.uId!);
                              Navigator.pop(context);
                              Navigator.pop(context);

                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Cancel',style: TextStyle(color: primaryColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
                  },
                  icon: Icon(Icons.delete_forever_rounded,color: Colors.red[400],size: 40,)
              ),
            )]
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      CircleAvatar(
                        backgroundColor:primaryColor,
                        radius: 100,
                        child: CircleAvatar(
                          backgroundColor: blue9,
                          radius: 95,
                          backgroundImage: AssetImage('images/updateAdmin.png'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter the name',
                        controller: adminNameController,
                        inputType: TextInputType.name,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        labelText: 'Name',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter the ID ',
                        controller: adminIdController,
                        inputType: TextInputType.number,
                        prefixIcon: const Icon(
                          Icons.perm_identity,
                          color: Colors.black,
                        ),
                        labelText: 'ID',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter the Phone',
                        controller: adminPhoneController,
                        inputType: TextInputType.phone,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Phone',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter the Email',
                        controller: adminEmailController,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Email',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        context: context,
                        isObsecured: cubit.isObsecured,
                        validatorText: 'please enter your Password',
                        controller: adminPasswordController,
                        suffixIcon: IconButton(
                            color: Colors.white,
                            icon: cubit.isObsecured
                                ? Icon(
                              Icons.visibility,
                              color: primaryColor,
                            )
                                : Icon(
                              Icons.visibility_off,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              cubit.changeVisibility();
                            }),
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        labelText: 'Password',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter Hospital Name',
                        controller: hospitalNameController,
                        inputType: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.local_hospital_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Hospital Name',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        cursorColor: primaryColor,
                        borderColor: Colors.black,
                        color: Colors.black,
                        context: context,
                        validatorText: 'please enter Hospital Location',
                        controller: hospitalLocationController,
                        inputType: TextInputType.streetAddress,
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Hospital Location',
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      inProgress?const CircularProgressIndicator():Center(
                        child: defaultButton(
                            width: size.width * .7,
                            textColor: Colors.white,
                            context: context,
                            string: 'Update',
                            function: (){
                              if(formKey.currentState!.validate()){
                              cubit.updateAdminData(

                                  email: adminEmailController.text.trim(),
                                  password: adminPasswordController.text.trim(),
                                  name: adminNameController.text.trim(),
                                  phone: adminPhoneController.text.trim(),
                                  id: adminIdController.text.trim(),
                                  hospitalLocation: hospitalLocationController.text.trim(),
                                  hospitalName: hospitalNameController.text.trim(),
                                  uId:admin.uId!
                              );}
                            },
                            color: primaryColor),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
