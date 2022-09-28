import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places_provider.dart';
import '../widgets/my_text.dart';
import '../widgets/place_list_widget.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: 'Your places',
          letterSpace: 0.2,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.rn);
              },
              icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlacesProvider>(context, listen: false).fetchAndSetData(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              )
            : Consumer<GreatPlacesProvider>(
                child: Center(
                    child: MyText(
                  text: 'No places yet, add one.',
                  color: Colors.blueGrey,
                )),
                builder: (context, greatPlacesProvider, ch) => greatPlacesProvider.getItems.isEmpty
                    ? ch!
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.4 / 2.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: greatPlacesProvider.getItems.length,
                        itemBuilder: (context, index) =>
                            PlaceListWidget(myPlace: greatPlacesProvider.getItems[index]),
                      ),
              ),
      ),
    );
  }
}
