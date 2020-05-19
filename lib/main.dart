import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Interest Calculator App",
    home: SimpleInterestForm(),
    theme: ThemeData(
      primaryColor: Colors.blueGrey,
      accentColor: Colors.blueGrey,
      brightness: Brightness.light,
    ),
  ));
}

class SimpleInterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SimpleInterestFormState();
  }
}

class _SimpleInterestFormState extends State<SimpleInterestForm> {
  var _formKey = GlobalKey<FormState>(); //defining the global key after we created the child Form within Scaffold. GlobalKey is a generic type so we use super FormState superclass instead of using the _SimpleInterestFormState.
  // it will behave as a key for our Form below withing Scafford
  var _currencies = ["EUR", "HUF", "USD", "ZAR"];
  final _minimumPadding = 5.0;
  var _currentItemSelected =
      ""; //Storing the currently selected item from the dropdown by the User -- doing some logic

  @override
  void initState() {
    //Here we want to instantiate some values when State of Widget (_SimpleInterestFormState) created
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalControlled =
      TextEditingController(); //Whatever the user enter in the textfield we can extraxt that value and use it with logic
  TextEditingController interestControlled = TextEditingController();
  TextEditingController termControlled = TextEditingController();

  var displayResult = "";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .headline6; //It returns the Theme we defined above in the MaterialApp (Theme.of(context) -- the nearest Theme of our app

    return Scaffold(
      //Let's return the Scaffold and the appBar with the container

      //  resizeToAvoidBottomPadding: false, // I wont get the error: A RenderFlex overflowed by 'x' pixels on the bottom.
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey, //in the future we will use this key to identitfy our Form() instance. We will get our current state of our Form
          //Originally it was a Container but for validation we need to repace it with a Form
          child: Padding(
        //we wrapped the whole ListView within Padding as a child of it so we can have a padding
        padding: EdgeInsets.all(_minimumPadding * 2),
        //  margin: EdgeInsets.all(_minimumPadding * 2), --> this doesn't work with the Form body unlike with Container
        child: ListView(
          // Originally defined the child as Column which will contain all of our Widget. But we changed for ListView

          children: <Widget>[
            getImageAsset(),
            // call this function as the first child
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField( // it was TextField before using Form within Scafford
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: principalControlled,
                  validator: (String value) { //validate the input from user,
                    if (value.isEmpty) { // if the user inout is empty
                      return "Field musn't be empty";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Principal",
                      hintText: "Enter Principal e.g. 100",
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                          color: Colors.pink,
                          fontSize: 15.0
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),

            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(// it was TextField before using Form within Scafford
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: interestControlled,
                  validator: (String value) { //validate the input from user,
                  if (value.isEmpty) { // if the user inout is empty
                    return "Field musn't be empty";
                  }
                    },
                  decoration: InputDecoration(
                      labelText: "Interest (%)",
                      hintText: "Enter a number e.g. 27",
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.pink,
                            fontSize: 15.0
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),

            //Whenever we have elements in a row, the elements might overflow out of the screen or beyond.
            //So that we wrap these widgets within expanded widget
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField( // it was TextField before using Form within Scafford
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: termControlled,
                          validator: (String value) { //validate the input from user,
                            if (value.isEmpty) { // if the user inout is empty
                              return "Field musn't be empty";
                            }
                          },
                      decoration: InputDecoration(
                          labelText: "Term",
                          hintText: "Time in years",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.pink,
                              fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),

                      value: _currentItemSelected,
                      // HUF by default as per we initiated in the variable above
                      onChanged: (String newValueSelected) {
                        _onDropDownItemSelected(newValueSelected);
                      },
                    ))
                  ],
                )),

            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text("Calculate", textScaleFactor: 1.5),
                      onPressed: () {
                        setState(() {
                          if(_formKey.currentState.validate()) //returns true if the validation passes it
                            //when we are using this formkey we are referring to the form in which it represent. And this key is unique across the entire application
                            //Wit the key we can indentify which Form we are using for
                          this.displayResult = _calculateTotalReturns();
                        });
                      },
                    )),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Reset", textScaleFactor: 1.5),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    ))
                  ],
                )),

            Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: Text(
                  displayResult,
                  style: textStyle,
                )),
          ],
        ),
      )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/bank.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    ); //create the image out of the asset

    return Container(
      //Wrap the img in the container and return it
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

    double totalAmountPayable = principal + (principal * interest * term) / 100;

    String result =
        "After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected";

    return result;
  }

  void _reset() {
    principalControlled.text = "";
    interestControlled.text = "";
    termControlled.text = "";
    displayResult = "";
    _currentItemSelected = _currencies[0];
  }
}
