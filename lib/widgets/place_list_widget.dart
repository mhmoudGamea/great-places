import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './my_text.dart';
import '../models/place.dart';
import '../providers/great_places_provider.dart';
import '../screens/place_detail_screen.dart';

class PlaceListWidget extends StatelessWidget {
  final Place myPlace;

  const PlaceListWidget({Key? key, required this.myPlace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final myPlaces = Provider.of<GreatPlacesProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(PlaceDetailScreen.rn, arguments: myPlace.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: const Color(0xFF126381).withAlpha(120),
            title: MyText(text: myPlace.title.toUpperCase(), letterSpace: 1.3, size: 14),
            trailing: IconButton(
                onPressed: () {
                  buildShowDialog(context);
                },
                icon: const Icon(Icons.delete_rounded),
                color: Colors.red[400]),
          ),
          child: Image.file(myPlace.image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: MyText(
                text: 'Are You Sure ?',
                color: Colors.blueGrey,
                size: 18,
              ),
              content: MyText(
                text: 'This action will entirely remove your place.',
                color: Colors.blueGrey[400],
                letterSpace: 1.1,
                size: 17,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: MyText(
                      text: 'No',
                      color: Colors.blue[400],
                      size: 17,
                    )),
                TextButton(
                    onPressed: () {
                      Provider.of<GreatPlacesProvider>(ctx, listen: false).deletePlace(myPlace.id);
                      Navigator.of(ctx).pop();
                    },
                    child: MyText(
                      text: 'Yes',
                      color: Colors.red[400],
                      size: 17,
                    )),
              ],
            ));
  }
}
