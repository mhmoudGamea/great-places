import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/places_list_screen.dart';
import './providers/great_places_provider.dart';
import './screens/add_place_screen.dart';
import './screens/place_detail_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GreatPlacesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF126381)//aae8d7
          ),
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.amber,
        ),
        home: const PlacesListScreen(),
        routes: {
          AddPlaceScreen.rn: (context) => const AddPlaceScreen(),
          PlaceDetailScreen.rn: (context) => const PlaceDetailScreen(),
        },
      ),
    );
  }
}
