import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  VISIBLE,
  BECOMING_INVISIBLE
}

class Clap extends StatefulWidget {
  @override
  _ClapState createState() => _ClapState();
}

class _ClapState extends State<Clap> with TickerProviderStateMixin {
  int c = 0;
  int _counter = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  final threeSeconds = new Duration(seconds: 3);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController, scoreOutAnimationController,
      scoreSizeAnimationController, sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;

  initState() {
    super.initState();
    
    random = new Random();
    scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener((){
      setState(() {}); 
    });

    scoreOutAnimationController = new AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = new Tween(begin: 100.0, end: 150.0).animate(
      new CurvedAnimation(parent: scoreOutAnimationController, curve: Curves.easeOut)
    );
    scoreOutPositionAnimation.addListener((){
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener((){
      setState(() {});
    });

    sparklesAnimationController = new AnimationController(vsync: this, duration: duration);
    sparklesAnimation = new CurvedAnimation(parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener((){
      setState(() {});
    });
  }

  dispose() {
   super.dispose();
   scoreInAnimationController.dispose();
   scoreOutAnimationController.dispose();
  }

  void increment(Timer t) {
    scoreSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);
    setState(() {
      _counter++;
      _sparklesAngle = random.nextDouble() * (2*pi);
    });
  }

  void onTapDown(TapDownDetails tap) {
    if (scoreOutETA != null) {
      scoreOutETA.cancel(); 
    }
    if(_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      scoreOutAnimationController.stop(canceled: true);
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    }
    else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN ) {
        _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
        scoreInAnimationController.forward(from: 0.0);
    }
    increment(null);
    holdTimer = new Timer.periodic(duration, increment);
  }

  void onTapUp(TapUpDetails tap) {
    scoreOutETA = new Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    holdTimer.cancel();
    c = 1;
  }
  
  Widget getScoreButton() {
    var scorePosition = 0.0;
    var scoreOpacity = 0.0;
    var extraSize = 0.0;
    switch(_scoreWidgetStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE :
      case ScoreWidgetStatus.VISIBLE:
        scorePosition = scoreInAnimationController.value * 100;
        scoreOpacity = scoreInAnimationController.value;
        extraSize = scoreSizeAnimationController.value * 3;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
    }

    var stackChildren = <Widget>[
    ];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * 50) ;
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for(int i = 0;i < 5; ++i) {
      var currentAngle = (firstAngle + ((2*pi)/5)*(i));
      var sparklesWidget =
        new Positioned(child: new Transform.rotate(
            angle: currentAngle - pi/2,
            child: new Opacity(opacity: sparklesOpacity,
                child : new Image.asset("assets/sparkles.png", width: 14.0, height: 14.0, ))
          ),
          left:(sparkleRadius*cos(currentAngle)) + 20,
          top: (sparkleRadius* sin(currentAngle)) + 20 ,
      );
      stackChildren.add(sparklesWidget);
    }

    stackChildren.add(new Opacity(opacity: scoreOpacity, child: new Container(
        height: 50.0 + extraSize,
        width: 50.0  + extraSize,
        decoration: new ShapeDecoration(
          shape: new CircleBorder(
              side: BorderSide.none
          ),
          color: Colors.lightGreen,
        ),
        child: new Center(child:
        new Text("+" + _counter.toString(),
          style: new TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0),))
    )));

    var widget =  new Positioned(
        child: new Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: stackChildren,
        )
        ,
        bottom: scorePosition
    );
    scoreOutETA = new Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
       c = 0;
    });
    holdTimer.cancel();

    return widget;
  }
 
  Widget getClapButton() {
    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE || _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 3;
    }
    return new GestureDetector(
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: new Container(
          height: 50.0 + extraSize,
          width: 50.0 + extraSize,
          padding: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.lightGreen, width: 1.0),
              borderRadius: new BorderRadius.circular(50.0),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(color: Colors.lightGreen, blurRadius: 8.0)
              ]
          ),
          child: new ImageIcon(
              new AssetImage("assets/clap.png"), color: Colors.lightGreen,
              size: 40.0),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
          ),
        ], color: Colors.white, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: c == 0 ? getClapButton() : getScoreButton()
        ),
      )
    );
  }
}
