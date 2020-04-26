import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'case_controller.dart';
import 'package:mosaic/job/Jobs_Controller.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/business/Queries.dart';
import 'package:mosaic/cases/case_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mosaic/Utils/font_style.dart';
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/job/Job.dart';
import 'package:mosaic/widgets/Widgets.dart';

import 'cases_view.dart';

class PreviewCase extends StatefulWidget {
  final Case caseItem;
  final Doctor doctor;
  final VoidCallback refreshLocalList;
  final void Function(String msg) showInSnackBar;
  const PreviewCase(
      {Key key,
      this.caseItem,
      this.doctor,
      this.refreshLocalList,
      this.showInSnackBar})
      : super(key: key);
  @override
  _PreviewCaseState createState() => _PreviewCaseState(refreshLocalList);
}

class _PreviewCaseState extends State<PreviewCase> {
  VoidCallback refreshLocalList;
  _PreviewCaseState(this.refreshLocalList);
  Future jobs;
  void initState() {
    super.initState();
    jobs = JobsController.fetchJobsByCaseId(widget.caseItem.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
      ],
      title: 'MOSAIC',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),

        //fontFamily: 'Arial'
      ),
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(58, 66, 86, 1.0),
          Color.fromRGBO(30, 38, 58, 15.0)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Case info',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenAwareSize(20, context))),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: screenAwareSize(25.0, context),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Text("Patient Name",
                                        style:
                                            MyFontStyles.headlinesGreyFontStyle(
                                                context))),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        widget.caseItem.patientName ?? "N/A",
                                        style:
                                            MyFontStyles.titlesWhiteFontStyle(
                                                context))),
                              ],
                            ),
                            // SizedBox(width: screenAwareSize(10, context)),
//                          SizedBox(
//                            width: screenAwareSize(30, context),
//                          ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      child: Text("Doctor Name",
                                          style: MyFontStyles
                                              .headlinesGreyFontStyle(
                                                  context))),
                                  Container(
                                      child: Text(
                                          widget.doctor == null
                                              ? "NA"
                                              : widget.doctor.name,
                                          style:
                                              MyFontStyles.titlesWhiteFontStyle(
                                                  context)))
                                ],
                              ),
                            )
                          ]),
                      SizedBox(height: screenAwareSize(10, context)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                child: Text("Delivery Date",
                                    style: MyFontStyles.headlinesGreyFontStyle(
                                        context))),
                            Container(

                                // alignment: Alignment.topRight,
                                child: Text(
                                    widget.caseItem.deliverDate == null
                                        ? "N/A "
                                        : widget.caseItem.deliverDate
                                            .substring(0, 10),
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context)))
                          ]),
                      Divider(
                        height: 50,
                        color: Colors.white,
                      ),
                      Row(children: <Widget>[
                        Container(
                            child: Text("Jobs :",
                                style: MyFontStyles.headlinesGreyFontStyle(
                                    context))),
                      ]),
                      Container(
                        child: FutureBuilder(
                          builder: (context, projectSnap) {
                            switch (projectSnap.connectionState) {
                              case ConnectionState.none:
                                return Widgets.loadingCircle(
                                    'Connection failed');
                              case ConnectionState.waiting:
                                return Widgets.loadingCircle(
                                    'Waiting Connection');
                              case ConnectionState.active:
                                break;
                              case ConnectionState.done:
                                {
                                  if (projectSnap == null) {
                                    return CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white));
                                  }
                                  if (!projectSnap.hasData)
                                    return Text('No Jobs',
                                        style:
                                            MyFontStyles.headlinesGreyFontStyle(
                                                context));
                                }
                                break;
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: projectSnap.data.length,
                              itemBuilder: (context, index) {
                                Job job = projectSnap.data[index];
                                print(
                                    "snap length is : ${projectSnap.data.length} index is $index");
                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: screenAwareSize(10, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                              job.unitNum +
                                                  '  ' +
                                                  job.style +
                                                  '  ' +
                                                  JobsController
                                                      .getJobTypeNameById(
                                                          int.parse(job.type)),
                                              style: MyFontStyles
                                                  .titlesWhiteFontStyle(
                                                      context)),
                                        ),
//                                    Container(
//                                      child: Text(job.style,
//                                          style: CustomTextStyle
//                                              .previewCaseLargeFont(context)),
//                                    ),
//                                    Container(
//                                      child: Text(
//                                          JobsController.getJobTypeNameById(
//                                              int.parse(job.type)),
//                                          style: CustomTextStyle
//                                              .previewCaseLargeFont(context)),
//                                    ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          future: jobs,
                        ),
                      ),
                      Divider(height: 50, color: Colors.white),
                      Row(
                        children: <Widget>[
                          Container(
                              child: Text("Notes",
                                  style: MyFontStyles.headlinesGreyFontStyle(
                                      context))),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Flexible(
                                child: Text(
                                    widget.caseItem.note == null
                                        ? "None"
                                        : widget.caseItem.note,
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context))),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton(
                                textColor: Color.fromRGBO(58, 66, 86, 1.0),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                child: Text(
                                  widget.caseItem.madeBy == null
                                      ? 'Start'
                                      : "Finish",
                                  style: MyFontStyles.buttonsFont(context),
                                ),
                                onPressed: () async {
                                  String response = "N/A";
                                  if (widget.caseItem.madeBy == null) {
                                    CasesController.startCaseInLocalList(
                                        widget.caseItem.id.toString());
                                    refreshLocalList();
                                    Navigator.of(context).pop();
                                    response = await Queries.startCase(
                                        widget.caseItem.id.toString(),
                                        widget.caseItem.currentStatus,
                                        "1");
                                    response == "success"
                                        ? widget.showInSnackBar(
                                            "Case Started successfully")
                                        : widget.showInSnackBar(
                                            "Operation failed, please restart application");
                                  } else {
                                    CasesController.finishCaseInLocalList(
                                        widget.caseItem.id.toString());
                                    refreshLocalList();
                                    Navigator.of(context).pop();
                                    response = await Queries.finishCase(
                                        widget.caseItem,
                                        widget.caseItem.currentStatus,
                                        "1");
                                    response == "success"
                                        ? widget.showInSnackBar(
                                            "Case finished successfully")
                                        : widget.showInSnackBar(
                                            "Operation failed, please restart application");
                                  }
                                }),
                          ),
                          _buildRepeatButton()
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatButton() {
    if (widget.caseItem.currentStatus == '4' && widget.caseItem.madeBy != null)
      return ButtonTheme(
        minWidth: 200.0,
        height: 40.0,
        child: RaisedButton(
            textColor: Color.fromRGBO(58, 66, 86, 1.0),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            child: Text(
              'Repeat',
              style: MyFontStyles.buttonsFont(context),
            ),
            onPressed: () async {

              showDialog(
                context: context,
                builder: (BuildContext context) => stageToBeRepeatedToDialog(),
              ).then((_) => setState(() {}));

            }),
      );
    return Container();
  }

  stageToBeRepeatedToDialog() {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text("Design"),
          onPressed: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text("Milling"),
          onPressed: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text("Furnace"),
          onPressed: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text("Finishing"),
          onPressed: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
