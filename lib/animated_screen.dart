import 'dart:async';

import 'package:animation_solar_system/planet_name.dart';
import 'package:animation_solar_system/planet_selector.dart';
import 'package:flutter/material.dart';

import 'astronaut.dart';
import 'model.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  final List<Planet> _planets = planets;
  int _currentPlanetIndex = 2;
  final StreamController _navigationStreamController =
      StreamController.broadcast();
  @override
  void dispose() {
    // TODO: implement dispose
    _navigationStreamController.close();
    super.dispose();
  }

  _handleArrowClick(ClickDirection direction) {
    setState(() {
      switch (direction) {
        case ClickDirection.Left:
          _currentPlanetIndex--;
          break;
        case ClickDirection.Right:
          _currentPlanetIndex++;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionalTranslation(
              translation: Offset(0, 0.65),
              child: PlanetSelector(
                screenSize: screenSize,
                planets: _planets,
                currentPlanetIndex: _currentPlanetIndex,
                onArrowClick: _handleArrowClick,
                onPlanetClicked: () =>
                    _navigationStreamController.sink.add(null),
              ),
            ),
          ),
          Container(
            height: screenSize.height * 0.8,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.only(left: 50),
                      child: PlanetName(
                        name: _planets[_currentPlanetIndex].name.toUpperCase(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Astronaut(
                    size: screenSize,
                    planets: _planets,
                    currentPlanetIndex: _currentPlanetIndex,
                    shouldNavigate: _navigationStreamController.stream,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
