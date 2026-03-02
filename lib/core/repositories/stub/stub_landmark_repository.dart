import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/repositories/landmark_repository.dart';

class StubLandmarkRepository implements LandmarkRepository {
  @override
  List<Landmark> getAll() {
    return <Landmark>[
      Landmark(
        id: 'l1',
        name: 'Irving House',
        category: LandmarkCategory.historic,
        address: '302 Royal Ave',
        description: 'A preserved 19th century home museum.',
        point: Point(coordinates: Position(-122.9094, 49.2064)),
      ),
      Landmark(
        id: 'l2',
        name: 'New Westminster Museum',
        category: LandmarkCategory.historic,
        address: '777 Columbia St',
        description: 'Local history exhibitions and archives.',
        point: Point(coordinates: Position(-122.9079, 49.2060)),
      ),
      Landmark(
        id: 'l3',
        name: 'City Hall',
        category: LandmarkCategory.historic,
        address: '511 Royal Ave',
        description: 'Historic municipal building in downtown core.',
        point: Point(coordinates: Position(-122.9119, 49.2070)),
      ),
      Landmark(
        id: 'l4',
        name: 'Westminster Pier Park',
        category: LandmarkCategory.historic,
        address: '1 Sixth St',
        description: 'Riverfront park with boardwalk views.',
        point: Point(coordinates: Position(-122.9119, 49.2046)),
      ),
      Landmark(
        id: 'l5',
        name: 'Queens Park',
        category: LandmarkCategory.nature,
        address: 'First St',
        description: 'Large urban park with open lawns and trails.',
        point: Point(coordinates: Position(-122.9056, 49.2120)),
      ),
      Landmark(
        id: 'l6',
        name: 'Fraser River Trail',
        category: LandmarkCategory.nature,
        address: 'Fraser River Waterfront',
        description: 'Scenic walk route along the river.',
        point: Point(coordinates: Position(-122.9110, 49.2043)),
      ),
      Landmark(
        id: 'l7',
        name: 'Hume Park',
        category: LandmarkCategory.nature,
        address: '660 East Columbia St',
        description: 'Forest-style city park and recreation space.',
        point: Point(coordinates: Position(-122.8963, 49.2067)),
      ),
      Landmark(
        id: 'l8',
        name: 'Tipperary Park',
        category: LandmarkCategory.nature,
        address: '315 Queens Ave',
        description: 'Small downtown park near civic landmarks.',
        point: Point(coordinates: Position(-122.9099, 49.2076)),
      ),
      Landmark(
        id: 'l9',
        name: 'River Market',
        category: LandmarkCategory.food,
        address: '810 Quayside Dr',
        description: 'Popular food market by the waterfront.',
        point: Point(coordinates: Position(-122.9121, 49.2028)),
      ),
      Landmark(
        id: 'l10',
        name: 'Columbia Street Cafes',
        category: LandmarkCategory.food,
        address: 'Columbia St',
        description: 'Coffee shops and local student hangouts.',
        point: Point(coordinates: Position(-122.9090, 49.2060)),
      ),
      Landmark(
        id: 'l11',
        name: 'Steel and Oak Brewing',
        category: LandmarkCategory.food,
        address: '1319 Third Ave',
        description: 'Local craft brewery with tasting room.',
        point: Point(coordinates: Position(-122.9020, 49.2093)),
      ),
      Landmark(
        id: 'l12',
        name: 'Anvil Centre',
        category: LandmarkCategory.culture,
        address: '777 Columbia St',
        description: 'Arts and culture venue with public events.',
        point: Point(coordinates: Position(-122.9079, 49.2058)),
      ),
      Landmark(
        id: 'l13',
        name: 'Massey Theatre',
        category: LandmarkCategory.culture,
        address: '735 Eighth Ave',
        description: 'Performance venue for concerts and shows.',
        point: Point(coordinates: Position(-122.9054, 49.2124)),
      ),
      Landmark(
        id: 'l14',
        name: 'Douglas College New West',
        category: LandmarkCategory.culture,
        address: '700 Royal Ave',
        description: 'Campus hub for Douglas College students.',
        point: Point(coordinates: Position(-122.9115, 49.2071)),
      ),
      Landmark(
        id: 'l15',
        name: 'Samson V Maritime Museum',
        category: LandmarkCategory.culture,
        address: 'Gallery at Quayside',
        description: 'Historic paddlewheeler ship museum exhibit.',
        point: Point(coordinates: Position(-122.9100, 49.2030)),
      ),
    ];
  }
}
