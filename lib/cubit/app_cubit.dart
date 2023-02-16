import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/admin_model.dart';
import '../modules/login/login_screen.dart';
import '../shared/component/components.dart';
import '../shared/constants/constants.dart';
import '../shared/local/shared_preference.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  //add new admin
  void addNewAdmin({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String id,
    required String hospitalLocation,
    required String hospitalName,
    required String floorNumbers


  }) {
    emit(AddNewAdminRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      userCreate(email: email, name: name,password: password ,phone: phone, uId: value.user?.uid,
          id:id, hospitalLocation: hospitalLocation, hospitalName:hospitalName,
          floorNumbers: floorNumbers);
      emit(AddNewAdminRegisterSuccessState());

    }).catchError((onError) {
      emit(AddNewAdminErrorState(onError.toString()));
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String? uId,
    required String id,
    required String hospitalLocation,
    required String hospitalName,
    required String password,
    required String floorNumbers


  }) {
    AdminModel model=AdminModel(
        name:name ,
        email:email ,
        phone:phone ,
        uId: uId,
      id:id,
      hospitalLocation:hospitalLocation,
      hospitalName:hospitalName,
      password:password,
      type: 'ADMIN',
      floorNumbers:floorNumbers
    );
    FirebaseFirestore.instance
        .collection('admins')
        .doc(uId)
        .set(model.toMap()).then((value)
    {
      emit(AdminCreateUserSuccessState());
    }).catchError((onError)
    {
      emit(AdminCreateUserErrorState(onError.toString()));

    });
  }

//get all admins data
  List <AdminModel> admins1=[];
  List <AdminModel> admins2=[];

  bool? isSuper=false;

  void getUsers() {
    admins1=[];
    admins2=[];

    emit(GetAdminsLoadingState());
    FirebaseFirestore.instance.collection('admins').get()
        .then((value) async {
      value.docs.forEach((element)
      {


        if(element.data()['uId']!=uId){
          admins1.add(AdminModel.fromJson(element.data()));
        }
        print(admins1);
      });

      //check if user is super admin

      admins1.forEach((element) {

        isSuper=true;
        if(element.type.toString().toUpperCase()=='ADMIN'){
          admins2.add(element);
        }

        });

      print(isSuper);
      if(!isSuper!) {
        emit(GetAdminsSuccessState());

      }
      else
      {
        emit(GetAdminsErrorState('this user can\' access these data'));

      }



    })
        .catchError((onError) {
      emit(GetAdminsErrorState(onError.toString()));
    });
  }


  //search
  String searchWord='';
  List<AdminModel> searchResult=[];
  void search()
  {
    if(searchWord!=''){
      searchResult=[];
      searchResult = admins2
          .where((admin) =>
          admin.name!.toLowerCase()
              .contains(searchWord.toLowerCase()))
          .toList();
      emit(SearchDoneSuccessState());
    }
    else
    {
      searchWord='';
      emit(SearchDoneSuccessState());

    }

  }




//update admin data
  Future<void> updateAdminData({
    required String email,
    required String name,
    required String phone,
    required String uId,
    required String id,
    required String hospitalLocation,
    required String hospitalName,
    required String password,
    required String floorNumbers

  }) async {
    emit(UpdateAdminDataLoadingState());
    AdminModel model = AdminModel(
      name: name,
      phone: phone,
      email: email,
      id: id,
      hospitalLocation:hospitalLocation ,
      hospitalName:hospitalName ,
      password: password,
      uId: uId,
      type: 'ADMIN',
      floorNumbers:floorNumbers


    );



    FirebaseFirestore.instance.collection('admins').doc(uId).update(model.toMap())
     .then((value)async
 {

   getUsers();
   emit(UpdateAdminDataSuccessState());
 }).catchError((onError)
 {
   emit(UpdateAdminDataErrorState(onError.toString()));

 });

  }


//delete admin data
  Future<void> deleteAdminData({
    required String uId,
  }) async {
    emit(DeleteAdminDataLoadingState());
    FirebaseFirestore.instance.collection('admins').doc(uId).delete()
        .then((value)async
    {

      getUsers();
      emit(DeleteAdminDataSuccessState());
    }).catchError((onError)
    {
      emit(DeleteAdminDataErrorState(onError.toString()));

    });

  }


void logOut(context)
{
  CacheHelper.removeData(key: 'uId');
  navigateAndEnd(context,LoginScreen());

}

  bool isObsecured=true;

  void changeVisibility()
  {
    isObsecured=!isObsecured;
    emit(ChangeVisibilityState());
  }

  bool isLast =false;

  void changeOnBoarding(index,boardingLength)
  {
    if(index == boardingLength - 1)
    {
      isLast=true;
      emit(ChangeOnBoardingState());
    }else
    {

      isLast=false;
      emit(ChangeOnBoardingState());
    }
  }


  void submit(context) {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value)
    {
      if (value==true) {
        navigateAndEnd(
          context,
          LoginScreen(),
        );
      }
    });
  }


}
