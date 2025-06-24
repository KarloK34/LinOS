import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/widgets/error_state.dart';
import 'package:linos/core/widgets/vehicle_type_selector.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart';
import 'package:linos/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:linos/features/schedule/presentation/cubit/schedule_state.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late VehicleType _selectedScheduleType;

  @override
  void initState() {
    super.initState();
    _selectedScheduleType = VehicleType.tram;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<FirebaseFavoriteStopsRepository>().ensureUserInitialized();
    });
  }

  void _onScheduleTypeSelected(VehicleType scheduleType) {
    setState(() {
      _selectedScheduleType = scheduleType;
    });
    context.read<ScheduleCubit>().clearSelectedStop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VehicleTypeSelector(
              isTramSelected: _selectedScheduleType == VehicleType.tram,
              isBusSelected: _selectedScheduleType == VehicleType.bus,
              onTramSelected: () => _onScheduleTypeSelected(VehicleType.tram),
              onBusSelected: () => _onScheduleTypeSelected(VehicleType.bus),
              tramTitle: context.l10n.schedulePage_tramScheduleTitle,
              busTitle: context.l10n.schedulePage_busScheduleTitle,
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                if (state is ScheduleLoading) {
                  return Expanded(child: const Center(child: CircularProgressIndicator()));
                }

                if (state is ScheduleError) {
                  final errorMessage = AppErrorHandler.getLocalizedMessage(
                    context,
                    state.originalError ?? state.errorKey,
                  );
                  return Expanded(
                    child: Center(
                      child: ErrorState(title: context.l10n.schedulePage_errorLoadingSchedule, message: errorMessage),
                    ),
                  );
                }

                if (state is ScheduleLoaded) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFavoriteStopsSection(
                          _selectedScheduleType == VehicleType.tram ? state.favoriteTramStops : state.favoriteBusStops,
                        ),
                        const SizedBox(height: 16.0),
                        _buildStopSelector(
                          _selectedScheduleType == VehicleType.tram ? state.tramStops : state.busStops,
                          state.selectedStop,
                        ),
                        const SizedBox(height: 16.0),
                        _buildScheduleTable(state.selectedStop),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteStopsSection(List<TransitStop> favoriteStops) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.schedulePage_favoriteStopsTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 40.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favoriteStops.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 8.0),
            itemBuilder: (context, index) {
              if (index == favoriteStops.length) {
                return ActionChip(
                  label: Text(context.l10n.schedulePage_addFavoriteButton),
                  avatar: Icon(Icons.add_circle_outline, color: context.theme.colorScheme.primary),
                  onPressed: () => _showAddFavoriteDialog(),
                );
              }
              final stop = favoriteStops[index];
              return GestureDetector(
                onTap: () => context.read<ScheduleCubit>().selectStop(stop),
                child: Chip(
                  label: Text(stop.name),
                  onDeleted: () => context.read<ScheduleCubit>().toggleFavoriteStop(stop),
                  deleteIcon: const Icon(Icons.close, size: 18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStopSelector(List<TransitStop> allStops, TransitStop? selectedStop) {
    final validSelectedStop = selectedStop != null
        ? allStops.where((stop) => stop.id == selectedStop.id).firstOrNull
        : null;
    return DropdownButtonFormField<TransitStop>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        filled: true,
        fillColor: context.theme.colorScheme.surface,
      ),
      hint: Text(context.l10n.schedulePage_selectStopLabel, style: context.theme.textTheme.labelLarge),
      value: validSelectedStop,
      items: allStops.map<DropdownMenuItem<TransitStop>>((TransitStop stop) {
        return DropdownMenuItem<TransitStop>(value: stop, child: Text(stop.name));
      }).toList(),
      onChanged: (TransitStop? newStop) {
        if (newStop != null) {
          context.read<ScheduleCubit>().selectStop(newStop);
        } else {
          context.read<ScheduleCubit>().clearSelectedStop();
        }
      },
    );
  }

  Widget _buildScheduleTable(TransitStop? selectedStop) {
    if (selectedStop == null) {
      return Expanded(
        child: Center(
          child: Text(
            context.l10n.schedulePage_selectStopToViewSchedule,
            style: context.theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Mock schedule data - in real implementation, this would come from an API
    final scheduleData = selectedStop.schedule.departureTimes
        .map(
          (time) => {
            'origin': selectedStop.origin,
            'destination': selectedStop.destination,
            'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          },
        )
        .toList();

    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  context.l10n.schedulePage_originColumn,
                  style: context.theme.textTheme.labelLarge?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  context.l10n.schedulePage_destinationColumn,
                  style: context.theme.textTheme.labelLarge?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  context.l10n.schedulePage_departureTimeColumn,
                  style: context.theme.textTheme.labelLarge?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          rows: scheduleData
              .map(
                (schedule) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(schedule['origin']!, textAlign: TextAlign.center)),
                    DataCell(Text(schedule['destination']!, textAlign: TextAlign.center)),
                    DataCell(Text(schedule['time']!, textAlign: TextAlign.center)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showAddFavoriteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<ScheduleCubit>(),
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state is! ScheduleLoaded) return const SizedBox.shrink();
              final stops = _selectedScheduleType == VehicleType.tram ? state.tramStops : state.busStops;

              return AlertDialog(
                title: Text(context.l10n.schedulePage_addFavoriteButton),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: stops.length,
                    itemBuilder: (context, index) {
                      final stop = stops[index];
                      final isFavorite =
                          state.favoriteTramStops.any((fav) => fav.id == stop.id) ||
                          state.favoriteBusStops.any((fav) => fav.id == stop.id);

                      return ListTile(
                        title: Text(stop.name),
                        trailing: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onTap: () {
                          context.read<ScheduleCubit>().toggleFavoriteStop(stop);
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(context.l10n.button_close),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
