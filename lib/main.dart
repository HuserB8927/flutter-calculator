import 'package:flutter/material.dart';

void main() {

  runApp(

    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Interest Calculator App",
      home: SimpleInterestForm(),

      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        brightness: Brightness.light,

      ),
    )
  );
}

class SimpleInterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _SimpleInterestFormState();
  }
}

class _SimpleInterestFormState extends State<SimpleInterestForm> {
  var _currencies = ["EUR", "HUF", "USD", "ZAR"];
  final _minimumPadding = 5.0;
  var _currentItemSelected = "HUF"; //Storing the currently selected item from the dropdown by the User -- doing some logic

  TextEditingController principalControlled = TextEditingController(); //Whatever the user enter in the textfield we can extraxt that value and use it with logic
  TextEditingController interestControlled = TextEditingController();
  TextEditingController termControlled = TextEditingController();

  var displayResult = "";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6; //It returns the Theme we defined above in the MaterialApp (Theme.of(context) -- the nearest Theme of our app

    return Scaffold( //Let's return the Scaffold and the appBar with the container

    //  resizeToAvoidBottomPadding: false, // I wont get the error: A RenderFlex overflowed by 'x' pixels on the bottom.
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Container(
        margin: EdgeInsets.all(_minimumPadding * 2),
        child: ListView( // Originally defined the child as Column which will contain all of our Widget. But we changed for ListView

          children: <Widget>[
            getImageAsset(), // call this function as the first child
           Padding(
             padding: EdgeInsets.only(top:_minimumPadding, bottom: _minimumPadding),
             child: TextField(
             keyboardType: TextInputType.number,
             style: textStyle,
             controller: principalControlled,
             decoration: InputDecoration(
                 labelText: "Principal",
                 hintText: "Enter Principal e.g. 100",
                 labelStyle: textStyle,
                 border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(5.0)
                 )
             ),
           )),

            Padding(
                padding: EdgeInsets.only(top:_minimumPadding, bottom: _minimumPadding),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: interestControlled,
                  decoration: InputDecoration(
                      labelText: "Interest (%)",
                      hintText: "Enter a number e.g. 27",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )),

            //Whenever we have elements in a row, the elements might overflow out of the screen or beyond.
            //So that we wrap these widgets within expanded widget
            Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                    children: <Widget>[
                
                Expanded(child: TextField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: termControlled,
                  decoration: InputDecoration(
                      labelText: "Term",
                      hintText: "Time in years",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )),

                Container(
                  width: _minimumPadding * 5,
                ),

                Expanded(child: DropdownButton<String>(
                    items: _currencies.map((String value){
                      return DropdownMenuItem<String> (
                        value: value,
                        child: Text(value),
                      );
                      }).toList(),

                      value: _currentItemSelected, // HUF by default as per we initiated in the variable above
                      onChanged: (String newValueSelected) {

                      _onDropDownItemSelected(newValueSelected);

                      },
                     ))

              ],
            )),

            Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child: Row(children: <Widget>[
              Expanded(child: RaisedButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).primaryColorDark,
                child: Text("Calculate", textScaleFactor: 1.5),
                onPressed: () {

                  setState(() {
                    this.displayResult = _calculateTotalReturns();
                  });
                },
              )
              ),

              Expanded(child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text("Reset", textScaleFactor: 1.5),
                onPressed: () {

                  setState(() {
                    _reset();
                  });
                },
              )
              )
            ],)),

            Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: Text(displayResult, style: textStyle,)
              ),

          ],
        ),
      ),
    );
  }
    Widget getImageAsset() {

    AssetImage assetImage = AssetImage("images/bank.png");
    Image image = Image(image: assetImage, width: 125.0, height: 125.0,);//create the image out of the asset

    return Container ( //Wrap the img in the container and return it
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
  String _calculateTotalReturns() {

    double principal = double.parse(principalControlled.text);
    double interest = double.parse(interestControlled.text);
    double term = double.parse(termControlled.text);

    double totalAmountPayable = principal + ( principal * interest * term) / 100;

    String result = "After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected";

    return result;
  }
  void _reset() {
    principalControlled.text = "";
    interestControlled.text = "";
    termControlled.text = "";
  }
}

