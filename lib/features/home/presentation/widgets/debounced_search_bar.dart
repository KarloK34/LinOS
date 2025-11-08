import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/features/home/data/models/place_suggestion.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_state.dart';

class DebouncedSearchBar extends StatefulWidget {
  const DebouncedSearchBar({super.key});

  @override
  State<DebouncedSearchBar> createState() => _DebouncedSearchBarState();
}

class _DebouncedSearchBarState extends State<DebouncedSearchBar> {
  final SearchController _searchController = SearchController();
  final BehaviorSubject<String> _querySubject = BehaviorSubject<String>.seeded('');
  StreamSubscription<String>? _querySubscription;
  String? _sessionToken;
  bool _isSettingTextProgrammatically = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (!_isSettingTextProgrammatically) {
        _querySubject.add(_searchController.text);
      }
    });

    _querySubscription = _querySubject.debounceTime(const Duration(milliseconds: 300)).listen((query) {
      if (!mounted) return;
      // Don't clear search if we're setting text programmatically (e.g., after selecting a place)
      if (_isSettingTextProgrammatically) {
        return;
      }
      final searchCubit = context.read<SearchDestinationCubit>();
      final currentState = searchCubit.state;
      // Don't clear search if a destination is already selected
      if (query.isEmpty && currentState is! SearchDestinationSelected) {
        _sessionToken = null;
        searchCubit.clearSearch();
      } else if (query.isNotEmpty) {
        _sessionToken ??= const Uuid().v4();
        searchCubit.searchPlaces(query, _sessionToken!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _querySubject.close();
    _querySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      isFullScreen: false,
      viewOnClose: () {
        // Only clear search if no destination is currently selected
        final currentState = context.read<SearchDestinationCubit>().state;
        if (currentState is! SearchDestinationSelected) {
          if (_sessionToken != null) {
            context.read<SearchDestinationCubit>().clearSearch();
            _sessionToken = null;
          }
        }
        _searchController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).unfocus();
        });
      },
      viewOnSubmitted: (value) {
        if (_sessionToken != null) {
          context.read<SearchDestinationCubit>().selectPlace(
            PlaceSuggestion(description: value, placeId: ''),
            _sessionToken!,
          );
          _sessionToken = null;
        }
        _searchController.clear();
      },
      viewBuilder: (suggestions) {
        return SizedBox(height: 300, child: Column(children: suggestions.toList()));
      },
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: context.l10n.homePage_searchHint,
          leading: const Icon(Icons.search),
          onTap: () {
            if (_searchController.text.isNotEmpty && _sessionToken == null) {
              _sessionToken = const Uuid().v4();
            }
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext suggestionsContext, SearchController controller) {
        return [
          StreamBuilder<SearchDestinationState>(
            stream: context.read<SearchDestinationCubit>().stream,
            initialData: context.read<SearchDestinationCubit>().state,
            builder: (_, snapshot) {
              final currentState = snapshot.data;

              if (currentState is SearchDestinationLoading) {
                return ListTile(
                  leading: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  title: Text(context.l10n.searchBar_searching),
                );
              }

              if (currentState is SearchDestinationError) {
                return ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(context.l10n.searchBar_error),
                );
              }

              if (currentState is SearchDestinationSuggestionsLoaded) {
                final suggestions = currentState.suggestions;

                if (suggestions.isEmpty) {
                  return ListTile(leading: const Icon(Icons.info), title: Text(context.l10n.homePage_noSuggestions));
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: suggestions.map((place) {
                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(place.description),
                      onTap: () async {
                        if (_sessionToken != null) {
                          // Set text first before closing view to prevent viewOnClose from clearing
                          _isSettingTextProgrammatically = true;
                          _searchController.text = place.description;
                          _isSettingTextProgrammatically = false;
                          // Await selectPlace to ensure state is emitted before closing view
                          final sessionToken = _sessionToken!;
                          _sessionToken = null;
                          await context.read<SearchDestinationCubit>().selectPlace(place, sessionToken);
                          // Close view after state is emitted
                          if (mounted) {
                            controller.closeView(place.description);
                          }
                        } else {
                          controller.closeView(place.description);
                          _isSettingTextProgrammatically = true;
                          _searchController.text = place.description;
                          _isSettingTextProgrammatically = false;
                        }
                      },
                    );
                  }).toList(),
                );
              }

              return ListTile(leading: const Icon(Icons.search), title: Text(context.l10n.searchBar_startSearchHint));
            },
          ),
        ];
      },
    );
  }
}
