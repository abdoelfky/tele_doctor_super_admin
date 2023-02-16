
import 'package:advanced_search/advanced_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tele_doctor_super_admin/cubit/app_cubit.dart';
import 'package:tele_doctor_super_admin/cubit/app_state.dart';
import 'package:tele_doctor_super_admin/models/admin_model.dart';
import 'package:tele_doctor_super_admin/modules/update_user_screen.dart';
import 'package:tele_doctor_super_admin/shared/component/components.dart';
import 'package:tele_doctor_super_admin/shared/constants/constants.dart';

class SearchWidget extends StatelessWidget {

  List<String> searchableList = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery.of(context).size.height;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {


        AppCubit.get(context).admins2.forEach((element) {
          searchableList.add(element.name!.toLowerCase());

        });
        return Container(
          color: Color(0x35a9a3),
          width: width * .9,
          // padding: EdgeInsets.all(AppPadding.p15),
          child: AdvancedSearch(
            searchItems: searchableList,
            maxElementsToDisplay: 10,
            singleItemHeight: 50,
            minLettersForSearch: 0,
            selectedTextColor: Color(0xFF3363D9),
            fontSize: 14,
            borderRadius: 10.0,
            hintText: 'Search',
            cursorColor: primaryColor,
            autoCorrect: false,
            focusedBorderColor: primaryColor,
            searchResultsBgColor: Color(0xFAFAFA),
            disabledBorderColor: primaryColor,
            enabledBorderColor: primaryColor,
            enabled: true,
            caseSensitive: true,
            clearSearchEnabled: true,
            itemsShownAtStart: 10,
            searchMode: SearchMode.CONTAINS,
            showListOfResults: true,
            unSelectedTextColor: primaryColor,
            verticalPadding: 18,
            horizontalPadding: 20,
            hideHintOnTextInputFocus: true,
            hintTextColor: primaryColor,
            searchItemsWidget: searchWidget,
            onItemTap: (index, value) {
              print("selected item Index is $index");
              AppCubit.get(context).searchWord=value;
              AppCubit.get(context).search();
              navigateTo(context,
                  UpdateAdminScreen(
                  admin:AppCubit.get(context).admins2[index]
              ));


            },
            onSearchClear: () {
              print("Cleared Search");
              AppCubit.get(context).searchWord='';
              AppCubit.get(context).searchResult=[];
              print(AppCubit.get(context).searchResult.length);
              AppCubit.get(context).search();

            },
            onSubmitted: (value, value2) {
              print("Submitted: " + value);
              AppCubit.get(context).searchWord=value;
              AppCubit.get(context).search();

            },
            onEditingProgress: (value, value2) {
              print("TextEdited: " + value);
              AppCubit.get(context).searchWord=value;
              print("LENGTH: " + value2.length.toString());
              AppCubit.get(context).search();
            },
          ),
        );
      },
    );
  }

  Widget searchWidget(String text) {
    return ListTile(
      title:  Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: primaryColor,
        ),
      ),
    );
  }
}
