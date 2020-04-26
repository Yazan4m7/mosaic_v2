import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';

class DataSearch extends SearchDelegate<String> {
   TextEditingController controller =TextEditingController();

  DataSearch(this.controller);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon:Icon(Icons.clear),onPressed: (){query
    ="";},)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {close(context, "search result");},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  //     ! CALLS SYNC FUNCTIONS WITHOUT AWAIT !
  @override
  Widget buildSuggestions(BuildContext context) {
    DoctorsController.fetchAllDoctors();
    List doctorsList = DoctorsController.getDoctorsNamesAsList();
    final List<String>suggestionList =query.isEmpty? doctorsList :
        doctorsList.where((element) => element.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        String sugText = suggestionList[index];
        return ListTile(
          onTap:(){ controller.text = sugText;close(context, null);},

          title:
          RichText(
            text: TextSpan(
              text:sugText.substring(0, sugText.indexOf(query)),
              style:
                  TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: sugText.substring(sugText.indexOf(query), sugText.indexOf(query)+query.length),
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),TextSpan(
                  text: sugText.substring(sugText.indexOf(query)+query.length, sugText.length),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )

      );},
      itemCount: suggestionList.length,
    );
  }
}
