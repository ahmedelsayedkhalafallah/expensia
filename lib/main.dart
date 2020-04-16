import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'ExpenseType.dart';
import 'ExpenseData.dart';
import "package:configurable_expansion_tile/configurable_expansion_tile.dart";
import "DatabaseHelper.dart";
import 'package:flutter/services.dart';
import 'RegExInputFormatter.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expensia',
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        canvasColor: Colors.white,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final dbHelper = DatabaseHelper.instance;
  static DateTime now = new DateTime.now();
  var formattedDate ;
  double priceInput = 0.0;
  String descriptionInput = " ";
  final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
  ExpenseType Drop_value =
      new ExpenseType("transportation", Icons.directions_bus);
  List<ExpenseType> DropDownValues = new List<ExpenseType>();
  void onChange_Drop(ExpenseType value) {
    todayExpenses.clear();
    weekExpenses.clear();
    setState(() {
      Drop_value = value;
    });
  }
  List allRecords;
  List<ExpenseData>allExpenses = new List<ExpenseData>();
  List<ExpenseData> todayExpenses = new List<ExpenseData>();
  List<DateTime> weekExpenses = new List<DateTime>();
  List<String> weeksExpenses = new List<String>();
  List<String> monthExpensesDetails = new List<String>();
  List<String> yearExpenses = new List<String>();
  Map<String, IconData> typesIcons = new Map<String, IconData>();

  @override
  void initState() {
    typesIcons.addAll({
      "transportation": Icons.directions_bus,
      "food": Icons.fastfood,
      "drink": Icons.local_drink,
      "shopping": Icons.shopping_basket,
      "others": Icons.menu,
    });

    yearExpenses.addAll(["", "", "", "", "", "", "", "", ""]);
    monthExpensesDetails.addAll(["", "", ""]);
    weeksExpenses.addAll([" ", " ", " "]);
    DropDownValues.addAll([
      ExpenseType("transportation", Icons.directions_bus),
      ExpenseType("food", Icons.fastfood),
      ExpenseType("drink", Icons.local_drink),
      ExpenseType("shopping", Icons.shopping_basket),
      ExpenseType("others", Icons.menu),
    ]);

    Drop_value = DropDownValues.elementAt(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.monetization_on,
                  color: Colors.black,
                ),
                new Text(" Expensia"),
              ],
            ),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Add",
              ),
              Tab(
                text: "Prev Expenses",
              ),
              Tab(
                text: "Statistics",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [

          Container(
            child: new SingleChildScrollView(
              // the main content container
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),

                      //Current date and time container
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Hello",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                            textDirection: TextDirection.ltr,
                          ),
                          new Text(
                            "Hello",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //card to hold the addition form
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Container(
                      margin: EdgeInsets.all(20.0),

                      //the addition shadow handler
                      child: new Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(1.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),

                        //the addition form container
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            //Type and amount container
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 16.0,
                                  left: 8.0,
                                  right: 8.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  //Amount container
                                  new Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: new Text(
                                          "hello",
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              color: Colors.black),
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150.0,
                                        child: new Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: new TextFormField(
                                            inputFormatters: [_amountValidator],
                                            maxLines: 1,
                                            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
                                            onChanged: (text) {
                                        priceInput = double.parse(text);
                                        print("$priceInput");
                                        },
                                            decoration: new InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        gapPadding: 0.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                style:
                                                                    BorderStyle
                                                                        .solid,
                                                                width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                hintStyle: TextStyle(
                                                    color: Colors.black26,
                                                    fontSize: 14.0),
                                                contentPadding: EdgeInsets.only(
                                                    left: 12.0,
                                                    right: 12.0,
                                                    top: 8.0,
                                                    bottom: 8.0),
                                                hintText: 'Text'),
                                            autofocus: true,
                                            style: new TextStyle(
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  //Type container
                                  new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        "hello",
                                        textAlign: TextAlign.left,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        textDirection: TextDirection.ltr,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: SizedBox(
                                              height: 31.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 0.0,
                                                    bottom: 0.0),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      value: Drop_value,
                                                      items: DropDownValues.map(
                                                          (ExpenseType value) {
                                                        return new DropdownMenuItem(
                                                            value: value,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                new Icon(value
                                                                    .expIcon),
                                                                new Text(
                                                                  value.expType,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0),
                                                                ),
                                                              ],
                                                            ));
                                                      }).toList(),
                                                      onChanged:
                                                          (ExpenseType value) {
                                                        onChange_Drop(value);
                                                      }),
                                                ),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            //description and add button container
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  // description input
                                  SizedBox(
                                    width: 210.0,
                                    child: new Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 6.0, bottom: 16.0),
                                      child: new TextField(
                                        maxLines: 1,
                                        onChanged: (text) {
                                          descriptionInput = text;
                                          print("$descriptionInput");
                                        },
                                        decoration: new InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                gapPadding: 0.0),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),
                                            hintStyle: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 14.0),
                                            contentPadding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            hintText: 'Text'),
                                        autofocus: true,
                                        style: new TextStyle(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),

                                  //add button
                                  SizedBox(
                                    height: 48.0,
                                    width: 100.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, bottom: 16.0, right: 8.0),
                                      child: new RaisedButton(
                                        onPressed: () {_insert();},
                                        color: Colors.black,
                                        textColor: Colors.white,
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(4.0)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )

                            //
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(boxShadow: [
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2.0,
                          offset: new Offset(0.0, 0.0),
                        ),
                      ]),
                    ),
                  ),

                  //Today expenses list
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 1.0),
                      //Current date and time container
                      child:  ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          return new Card(
                            margin: EdgeInsets.only(bottom: 12.0),
                            elevation: 0.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: SizedBox(
                                        child: Icon(
                                          typesIcons[todayExpenses
                                              .elementAt(position)
                                              .type],
                                          size: 36.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            todayExpenses
                                                .elementAt(position)
                                                .type,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            todayExpenses
                                                .elementAt(position)
                                                .description,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 10.0),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Text(
                                      "${todayExpenses.elementAt(position).amount} EGP"),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: todayExpenses.length,
                      )
                    ),
                  )
                ],
              ),
            ),
          ),


          Container(
            child: new SingleChildScrollView(
              // the main content container
              child: new Column(
                children: <Widget>[
                  //month total
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),

                      //Current date and time container
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Hello",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                            textDirection: TextDirection.ltr,
                          ),
                          new Text(
                            "Hello",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //week total
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),

                      //Current date and time container
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Hello",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            textDirection: TextDirection.ltr,
                          ),
                          new Text(
                            "Hello",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // days expenses
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Container(
                      margin: const EdgeInsets.all(1.0),
                      //Current date and time container
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: new Container(
                              margin: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 20.0,
                                  bottom: 0.0),

                              //the addition shadow handler
                              child: new Card(
                                color: Colors.white,
                                // the shadow size can be controled from the card margin value
                                margin: EdgeInsets.all(1.0),
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),

                                //the addition form container
                                child: new Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    ConfigurableExpansionTile(
                                      header: SizedBox(
                                        height: 30.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: new Container(
                                            //Current date and time container
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                new Text(
                                                  "Hello",
                                                  textAlign: TextAlign.left,
                                                  style: new TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.0),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                                SizedBox(
                                                  width: 200.0,
                                                ),
                                                new Text(
                                                  "Hello",
                                                  textAlign: TextAlign.right,
                                                  style: new TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.0),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                                Icon(Icons.arrow_drop_down),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.0, right: 12.0),
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, position) {
                                                return new Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12.0),
                                                  elevation: 0.0,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8.0),
                                                            child: SizedBox(
                                                              child: Icon(
                                                                typesIcons[todayExpenses
                                                                    .elementAt(
                                                                        position)
                                                                    .type],
                                                                size: 36.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  todayExpenses
                                                                      .elementAt(
                                                                          position)
                                                                      .type,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0,
                                                                ),
                                                                Text(
                                                                  todayExpenses
                                                                      .elementAt(
                                                                          position)
                                                                      .description,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black26,
                                                                      fontSize:
                                                                          10.0),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 6.0),
                                                        child: Text(
                                                            "${todayExpenses.elementAt(position).amount} EGP"),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount: todayExpenses.length,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              decoration: new BoxDecoration(boxShadow: [
                                new BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2.0,
                                  offset: new Offset(0.0, 0.0),
                                ),
                              ]),
                            ),
                          );
                        },
                        itemCount: weekExpenses.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),



          Container(
            child: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[

                    //tabs indicator
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: new Container(
                        margin: EdgeInsets.only(
                            top: 30, bottom: 0.0, right: 60.0, left: 60.0),

                        //the addition shadow handler
                        child: new Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(1.0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: TabBar(
                              indicatorPadding: EdgeInsets.all(50.0),
                              labelColor: Colors.white,
                              indicator: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(4.0)),
                              indicatorColor: Colors.transparent,
                              unselectedLabelColor: Colors.black,
                              tabs: <Widget>[
                                Tab(
                                  text: "weekly",
                                ),
                                Tab(
                                  text: "Monthly",
                                )
                              ]),
                        ),
                        decoration: new BoxDecoration(boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2.0,
                            offset: new Offset(0.0, 0.0),
                          ),
                        ]),
                      ),
                    ),

                    //tabs content
                    new Expanded(
                        child: TabBarView(children: <Widget>[


                          //months deatails container
                      Container(
                          child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Container(
                            child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, position) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 20.0,
                                        right: 20.0,
                                        bottom: 0.0),

                                    //Current date and time container
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(
                                          "Hello",
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        new Text(
                                          "Hello",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0),
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: new Container(
                                    margin: const EdgeInsets.all(1.0),
                                    //Current date and time container
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, position) {
                                        return Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Container(
                                            margin: EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 20.0),

                                            //the addition shadow handler
                                            child: new Card(
                                              color: Colors.white,
                                              // the shadow size can be controled from the card margin value
                                              margin: EdgeInsets.all(1.0),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),

                                              //the addition form container
                                              child: new Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ConfigurableExpansionTile(
                                                    header: SizedBox(
                                                      height: 30.0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: new Container(
                                                          //Current date and time container
                                                          child: new Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              new Text(
                                                                "Hello",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: new TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16.0),
                                                                textDirection:
                                                                    TextDirection
                                                                        .ltr,
                                                              ),
                                                              SizedBox(
                                                                width: 200.0,
                                                              ),
                                                              new Text(
                                                                "Hello",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: new TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16.0),
                                                                textDirection:
                                                                    TextDirection
                                                                        .ltr,
                                                              ),
                                                              Icon(Icons
                                                                  .arrow_drop_down),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    children: <Widget>[
                                                      Container(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0,
                                                                  right: 12.0),
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    position) {
                                                              return new Card(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            12.0),
                                                                elevation: 0.0,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: 8.0),
                                                                          child:
                                                                              SizedBox(
                                                                            child:
                                                                                Icon(
                                                                              typesIcons[todayExpenses.elementAt(position).type],
                                                                              size: 36.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 4.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                todayExpenses.elementAt(position).type,
                                                                                style: TextStyle(fontSize: 16.0),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8.0,
                                                                              ),
                                                                              Text(
                                                                                todayExpenses.elementAt(position).description,
                                                                                style: TextStyle(color: Colors.black26, fontSize: 10.0),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 6.0),
                                                                      child: Text(
                                                                          "${todayExpenses.elementAt(position).amount} EGP"),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            itemCount:
                                                                todayExpenses
                                                                    .length,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration:
                                                new BoxDecoration(boxShadow: [
                                              new BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2.0,
                                                offset: new Offset(0.0, 0.0),
                                              ),
                                            ]),
                                          ),
                                        );
                                      },
                                      itemCount: weeksExpenses.length,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: monthExpensesDetails.length,
                        )),
                      )),

                      //year container
                      Container(
                        child: SingleChildScrollView(
                          child: new Column(
                            children: <Widget>[
                              //year total
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      top: 20.0,
                                      right: 20.0,
                                      bottom: 0.0),

                                  //Current date and time container
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        "Hello",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.0),
                                        textDirection: TextDirection.ltr,
                                      ),
                                      new Text(
                                        "Hello",
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.0),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // months expenses
                              Padding(
                                padding: EdgeInsets.all(1.0),
                                child: new Container(
                                  margin: const EdgeInsets.all(1.0),
                                  //Current date and time container
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Container(
                                          margin: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 20.0,
                                              bottom: 0.0),

                                          //the addition shadow handler
                                          child: new Card(
                                            color: Colors.white,
                                            // the shadow size can be controled from the card margin value
                                            margin: EdgeInsets.all(1.0),
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),

                                            child: new Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                ConfigurableExpansionTile(
                                                  header: SizedBox(
                                                    height: 30.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: new Container(
                                                        //Current date and time container
                                                        child: new Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            new Text(
                                                              "Hello",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      16.0),
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                            ),
                                                            SizedBox(
                                                              width: 200.0,
                                                            ),
                                                            new Text(
                                                              "Hello",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      16.0),
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                            ),
                                                            Icon(Icons
                                                                .arrow_drop_down),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.0,
                                                                right: 12.0),
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context,
                                                              position) {
                                                            return new Card(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          12.0),
                                                              elevation: 0.0,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          child:
                                                                              Icon(
                                                                            typesIcons[todayExpenses.elementAt(position).type],
                                                                            size:
                                                                                36.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 4.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              todayExpenses.elementAt(position).type,
                                                                              style: TextStyle(fontSize: 16.0),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8.0,
                                                                            ),
                                                                            Text(
                                                                              todayExpenses.elementAt(position).description,
                                                                              style: TextStyle(color: Colors.black26, fontSize: 10.0),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                6.0),
                                                                    child: Text(
                                                                        "${todayExpenses.elementAt(position).amount} EGP"),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          itemCount:
                                                              todayExpenses
                                                                  .length,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          decoration:
                                              new BoxDecoration(boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2.0,
                                              offset: new Offset(0.0, 0.0),
                                            ),
                                          ]),
                                        ),
                                      );
                                    },
                                    itemCount: yearExpenses.length,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]))
                  ],
                )),
          ),
        ]),
      ),
    );
    },
    future: _query(),
    );
  }
  void _insert() async {
    formattedDate = intl.DateFormat('yyyyMMdd').format(now);
    print("$formattedDate");
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnPrice : priceInput,
      DatabaseHelper.columnType  : Drop_value.expType,
      DatabaseHelper.columnDescription : descriptionInput,
      DatabaseHelper.columnDate : formattedDate.toString()
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');

    todayExpenses.clear();
    weekExpenses.clear();
    setState(() {

    });
  }
  
  Future _query() async {
    
    allRecords = await dbHelper.getAll();
    allRecords.forEach((element){
      allExpenses.add(ExpenseData.fromJson(element));
      if(allExpenses.elementAt(allExpenses.length-1).dateTime == DateTime.parse(intl.DateFormat('yyyyMMdd').format(now))){
        todayExpenses.add(ExpenseData.fromJson(element));
      }
      for(int i = allExpenses.length-1;(i>0&&allExpenses.elementAt(i).dateTime.difference(DateTime.parse(intl.DateFormat('yyyyMMdd').format(now))).inDays<7);i--){
        if(!weekExpenses.contains(allExpenses.elementAt(i).dateTime))
        weekExpenses.add(allExpenses.elementAt(i).dateTime);
      }
    });
  }
}
