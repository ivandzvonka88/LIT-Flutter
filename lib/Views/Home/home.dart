
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';

class FeedPage extends StatefulWidget {
  final String userID;
  FeedPage({Key key , this.userID}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {

  int _tabIndex = 0;
  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: feedWidget()
    );

  }

  Widget feedWidget(){
    return Stack(
      children: [
        feedIndexedStackProvider(),
        Align(alignment: Alignment.topCenter,child: feedTabs(),)
      ],
    );
  }
  Widget feedIndexedStackProvider(){
    return Column(
      children: [
        Expanded(
      child: IndexedStack(
        index: _tabIndex,
        children: [

        ],
      ),
        )
      ],
    );
  }

  Widget feedTabs(){
    return Container(
      width: 250,
      margin: EdgeInsets.only(top: 75),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: tappableTab('Last Night Lit', 0),),
          Expanded(child: tappableTab('Trending Lituations', 1),),
        ],
      ),
    );
  }

  Widget tappableTab(String title, int idx){
    Color c = Theme.of(context).textSelectionColor;
    Widget indicator = Container();
    var scale = 0.8;
    if(idx == _tabIndex){
      scale = 1.1;
      indicator = selectedIndicator(Theme.of(context).buttonColor);
      c = Theme.of(context).buttonColor;
    }
    return Container(
      height: 35,
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 9,child: Text(title , style: TextStyle(color: c), textAlign: TextAlign.center, textScaleFactor: scale,),),
            Expanded(child: indicator, flex: 1)
          ],
        ),
        onTap: (){
          setState(() {
            _tabIndex = idx;
          });
        },
      )
    );
  }


}
