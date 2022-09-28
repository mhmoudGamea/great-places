import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './google_map_screen.dart';
import '../providers/great_places_provider.dart';
import '../widgets/my_text.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const rn = '/place_detail_screen';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPlace = Provider.of<GreatPlacesProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(title: MyText(text: selectedPlace.title)),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            selectedPlace.location!.address!,
            style: const TextStyle(
                fontSize: 17,
                letterSpacing: 1.1,
                color: Colors.blueGrey,
                fontFamily: 'AveriaSerifLibre'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => GoogleMapScreen(
                        placeLocation: selectedPlace.location!,
                        isSelected: true,
                      )));
            },
            icon: const Icon(
              Icons.map_rounded,
              size: 21,
            ),
            label: MyText(
              text: 'View On Map',
              size: 17,
              letterSpace: 0,
            ),
            style: ElevatedButton.styleFrom(primary: Colors.purple[200]),
          ),
        ],
      ),
    );
  }
}
