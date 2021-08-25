import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FactoryMethodExample(),
        ),
      ),
    );
  }
}

abstract class CustomDialog {
  String getTitle();
  Widget create(BuildContext context);
  
  Future<void> show(BuildContext context) async {
    var dialog = create(context);
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return dialog;
      },
    );
  }
}

class AndroidAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'Android Alert Dialog';
  }
  
  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: Text('This is the material-style alert dialog!'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          }
        )
      ]
    );
  }
}

class IosAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'iOS Alert Dialog';
  }
  
  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: Text('This is cupertino-style alert dialog!'),
      actions: <Widget>[
        CupertinoButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          }
        )
      ]
    );
  }
}

class FactoryMethodExample extends StatefulWidget {
  @override
  _FactoryMethodExampleState createState() => _FactoryMethodExampleState();
}

class _FactoryMethodExampleState extends State<FactoryMethodExample> {
  final List<CustomDialog> customDialogList = [
    AndroidAlertDialog(),
    IosAlertDialog(),
  ];
  
  int _selectedDialogIndex = 0;
  
  Future _showCustomDialog(BuildContext context) async {
    var selectedDialog = customDialogList[_selectedDialogIndex];
    
    await selectedDialog.show(context);
  }
  
  void _setSelectedDialogIndex(int index) {
    setState(() {
      _selectedDialogIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            DialogSelection(
              customDialogList: customDialogList,
              selectedIndex: _selectedDialogIndex,
              onChanged: _setSelectedDialogIndex,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              child: const Text('Show Dialog'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              onPressed: () => _showCustomDialog(context),
            ),
          ]
        )
      )
    );
  }
}

class DialogSelection extends StatelessWidget {
  final List<CustomDialog> customDialogList;
  final int selectedIndex;
  final ValueSetter<int> onChanged;
  
  const DialogSelection({
    @required this.customDialogList,
    @required this.selectedIndex,
    @required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i=0; i<customDialogList.length; i++)
          RadioListTile(
            title: Text(customDialogList[i].getTitle()),
            value: i,
            groupValue: selectedIndex,
            selected: i == selectedIndex,
            activeColor: Colors.black,
            controlAffinity: ListTileControlAffinity.platform,
            onChanged: onChanged,
          )
      ]
    );
  }
}
