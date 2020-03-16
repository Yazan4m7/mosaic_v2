import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mosaic/Controllers/Jobs_Controller.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/business/Queries.dart';
import 'package:mosaic/business/Services.dart';
import 'package:mosaic/models/Case.dart';
import 'package:mosaic/models/Doctor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mosaic/Utils/Custom_Fone_Style.dart';
import 'package:mosaic/models/Job.dart';

class PreviewCase extends StatefulWidget {
  final Case caseItem;
  final Doctor doctor;
  const PreviewCase({Key key, this.caseItem, this.doctor}) : super(key: key);
  @override
  _PreviewCaseState createState() => _PreviewCaseState();
}

class _PreviewCaseState extends State<PreviewCase> {
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

            ),onPressed: (){Navigator.of(context).pop();},),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
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
                                  width: MediaQuery.of(context).size.width /2 -20,
                                  child: Text("Patient Name",
                                      style:
                                          CustomTextStyle.previewCaseSmallFont(
                                              context))),
                              Container(
                                  width: MediaQuery.of(context).size.width /2 -20,
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.caseItem.patientName,
                                      style:
                                          CustomTextStyle.previewCaseLargeFont(
                                              context))),
                            ],
                          ),
                         // SizedBox(width: screenAwareSize(10, context)),
//                          SizedBox(
//                            width: screenAwareSize(30, context),
//                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width /2-20,
                                  child: Text("Doctor Name",
                                      style:
                                          CustomTextStyle.previewCaseSmallFont(
                                              context))),
                              Container(
                                  width: MediaQuery.of(context).size.width /2 -20,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      widget.doctor == null
                                          ? "NA"
                                          : widget.doctor.name,
                                      style:
                                          CustomTextStyle.previewCaseLargeFont(
                                              context)))
                            ],
                          )
                        ]),
                    SizedBox(height: screenAwareSize(10, context)),
                    Column(
                        crossAxisAlignment:CrossAxisAlignment.stretch,children: <Widget>[
                      Container(
                          child: Text("Delivery Date",
                              style: CustomTextStyle.previewCaseSmallFont(
                                  context))),
                      Container(

                          // alignment: Alignment.topRight,
                          child: Text(
                              widget.caseItem.deliverDate.substring(0, 10),
                              style: CustomTextStyle.previewCaseLargeFont(
                                  context)))
                    ]),
                    Divider(
                      height: 50,
                      color: Colors.white,
                    ),
                    Row(children: <Widget>[
                      Container(
                          child: Text("Jobs :",
                              style: CustomTextStyle.previewCaseSmallFont(
                                  context))),
                    ]),
                    Container(
                      child: FutureBuilder(
                        builder: (context, projectSnap) {
                          if (projectSnap.connectionState ==
                                  ConnectionState.none ||
                              projectSnap.data == null) {
                            //print('project snapshot data is: ${projectSnap.data}');
                            return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white));
                          } else
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: projectSnap.data.length,
                              itemBuilder: (context, index) {
                                Job job = projectSnap.data[index];
                                print(
                                    "snap length is : ${projectSnap.data.length} index is $index");
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(job.unitNum,
                                          style: CustomTextStyle
                                              .previewCaseLargeFont(context)),
                                    ),
                                    Container(
                                      child: Text(job.style,
                                          style: CustomTextStyle
                                              .previewCaseLargeFont(context)),
                                    ),
                                    Container(
                                      child: Text(
                                          JobsController.getJobTypeNameById(
                                              int.parse(job.type)),
                                          style: CustomTextStyle
                                              .previewCaseLargeFont(context)),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                );
                              },
                            );
                        },
                        future: jobs,
                      ),
                    ),
                    Divider(height: 50,color:Colors.white),
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
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)),
                              child: Text(
                                widget.caseItem.madeBy == null
                                    ? 'Start'
                                    : "Finish",
                                style: CustomTextStyle.buttonsFont(context),
                              ),
                              onPressed: () {
                                widget.caseItem.madeBy == null
                                    ? Queries.startCase(
                                        widget.caseItem.id.toString(),
                                        widget.caseItem.currentStatus,
                                        Services.getDataFromSharedPreferences(
                                                "user_id")
                                            .toString())
                                    : Queries.finishCase(
                                        widget.caseItem.id.toString(),
                                        widget.caseItem.currentStatus,
                                        Services.getDataFromSharedPreferences(
                                                "user_id")
                                            .toString());
                              }),
                        ),
                      ],
                    ),

                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
