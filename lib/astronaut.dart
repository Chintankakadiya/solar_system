import 'dart:async';

import 'package:animation_solar_system/planet_page.dart';
import 'package:flutter/material.dart';

import 'custom_page.dart';
import 'model.dart';

class Astronaut extends StatefulWidget {
  final Size size;
  final List<Planet> planets;
  final int currentPlanetIndex;
  final Stream shouldNavigate;

  const Astronaut(
      {Key? key,
      required this.size,
      required this.planets,
      required this.currentPlanetIndex,
      required this.shouldNavigate})
      : super(key: key);
  @override
  AstronautState createState() {
    return new AstronautState();
  }
}

class AstronautState extends State<Astronaut> with TickerProviderStateMixin {
  AnimationController? _smokeAnimController;
  AnimationController? _scaleAnimController;
  AnimationController? _floatingAnimController;
  Animation<Offset>? _floatingAnim;
  TabController? _tabController;
  StreamSubscription? _navigationSubscription;

  @override
  void initState() {
    super.initState();
    _smokeAnimController =
        AnimationController(duration: Duration(seconds: 35), vsync: this);

    _floatingAnimController = AnimationController(
        duration: Duration(milliseconds: 1700), vsync: this);

    _floatingAnim = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.035))
        .animate(_floatingAnimController!);

    _smokeAnimController!.repeat();

    _floatingAnimController!.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _floatingAnimController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _floatingAnimController!.forward();
      }
    });

    _floatingAnimController!.forward();

    _tabController = TabController(
        initialIndex: widget.currentPlanetIndex,
        length: widget.planets.length,
        vsync: this);

    _navigationSubscription = widget.shouldNavigate.listen((_) async {
      Navigator.of(context)
          .push(
        MyPageRoute(
          transDuation: Duration(milliseconds: 700),
          builder: (BuildContext context) {
            return PlanetPage(
              currentPlanet: widget.planets[widget.currentPlanetIndex],
            );
          },
        ),
      )
          .then((_) {
        _scaleAnimController!.reverse();
      });

      await _scaleAnimController!.forward();
    });

    _scaleAnimController = AnimationController(
        lowerBound: 1.0,
        upperBound: 10.0,
        duration: Duration(milliseconds: 700),
        vsync: this);
  }

  @override
  void didUpdateWidget(Astronaut oldWidget) {
    if (widget.currentPlanetIndex != oldWidget.currentPlanetIndex) {
      _tabController!.animateTo(widget.currentPlanetIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _smokeAnimController!.dispose();
    _floatingAnimController!.dispose();
    _tabController!.dispose();
    _navigationSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size.width * 0.65;
    return SlideTransition(
      position: _floatingAnim!,
      child: ScaleTransition(
        scale: _scaleAnimController!,
        child: Container(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: size * 0.080,
                left: size * 0.060,
                child: Container(
                  width: size * 0.9,
                  height: size * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.transparent, Colors.black],
                        stops: [0.1, 0.8]),
                  ),
                  child: ClipOval(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: widget.planets.map((Planet p) {
                        return PlanetViewImg(
                          p.imgAssetPath,
                          planetName: p.name,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanetViewImg extends StatelessWidget {
  final String planetName;
  final String imgAssetPath;

  const PlanetViewImg(
    this.imgAssetPath, {
    Key? key,
    required this.planetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$planetName',
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        if (flightDirection == HeroFlightDirection.pop) {
          return Container();
        } else if (flightDirection == HeroFlightDirection.push) {
          return toHeroContext.widget;
        }
        return SizedBox();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 30.0),
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          imgAssetPath,
          height: 280,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
