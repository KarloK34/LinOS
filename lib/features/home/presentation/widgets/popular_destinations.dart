import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/data/models/search_history_item.dart';
import 'package:linos/features/home/data/models/selected_place.dart';
import 'package:linos/features/home/presentation/cubit/popular_destinations_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';

class PopularDestinations extends StatelessWidget {
  const PopularDestinations({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.homePage_popularDestinationsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(context.l10n.homePage_popularDestinationsSubtitle),
        Expanded(
          child: BlocBuilder<PopularDestinationsCubit, List<SearchHistoryItem>>(
            builder: (context, popularDestinations) {
              if (popularDestinations.isEmpty) {
                return Center(child: Text(context.l10n.homePage_noPopularDestinations));
              }

              return Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: popularDestinations.length,
                  itemBuilder: (context, index) {
                    final destination = popularDestinations[index];
                    return ListTile(
                      leading: Icon(Icons.place),
                      title: Text(destination.placeName),
                      trailing: Icon(Icons.trending_up),
                      onTap: () {
                        final selectedPlace = SelectedPlace(
                          placeId: destination.placeId,
                          name: destination.placeName,
                          coordinates: LatLng(destination.latitude, destination.longitude),
                        );
                        context.read<SearchDestinationCubit>().selectPopularDestination(selectedPlace);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
