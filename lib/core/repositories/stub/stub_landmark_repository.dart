import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/repositories/landmark_repository.dart';

class StubLandmarkRepository implements LandmarkRepository {
  @override
  List<Landmark> getAll() {
    return const <Landmark>[
      Landmark(
        id: 'l1',
        name: 'Irving House',
        category: LandmarkCategory.historic,
        address: '302 Royal Ave',
        description: 'A preserved 19th century home museum.',
      ),
      Landmark(
        id: 'l2',
        name: 'New Westminster Museum',
        category: LandmarkCategory.historic,
        address: '777 Columbia St',
        description: 'Local history exhibitions and archives.',
      ),
      Landmark(
        id: 'l3',
        name: 'City Hall',
        category: LandmarkCategory.historic,
        address: '511 Royal Ave',
        description: 'Historic municipal building in downtown core.',
      ),
      Landmark(
        id: 'l4',
        name: 'Westminster Pier Park',
        category: LandmarkCategory.historic,
        address: '1 Sixth St',
        description: 'Riverfront park with boardwalk views.',
      ),
      Landmark(
        id: 'l5',
        name: 'Queens Park',
        category: LandmarkCategory.nature,
        address: 'First St',
        description: 'Large urban park with open lawns and trails.',
      ),
      Landmark(
        id: 'l6',
        name: 'Fraser River Trail',
        category: LandmarkCategory.nature,
        address: 'Fraser River Waterfront',
        description: 'Scenic walk route along the river.',
      ),
      Landmark(
        id: 'l7',
        name: 'Hume Park',
        category: LandmarkCategory.nature,
        address: '660 East Columbia St',
        description: 'Forest-style city park and recreation space.',
      ),
      Landmark(
        id: 'l8',
        name: 'Tipperary Park',
        category: LandmarkCategory.nature,
        address: '315 Queens Ave',
        description: 'Small downtown park near civic landmarks.',
      ),
      Landmark(
        id: 'l9',
        name: 'River Market',
        category: LandmarkCategory.food,
        address: '810 Quayside Dr',
        description: 'Popular food market by the waterfront.',
      ),
      Landmark(
        id: 'l10',
        name: 'Columbia Street Cafes',
        category: LandmarkCategory.food,
        address: 'Columbia St',
        description: 'Coffee shops and local student hangouts.',
      ),
      Landmark(
        id: 'l11',
        name: 'Steel and Oak Brewing',
        category: LandmarkCategory.food,
        address: '1319 Third Ave',
        description: 'Local craft brewery with tasting room.',
      ),
      Landmark(
        id: 'l12',
        name: 'Anvil Centre',
        category: LandmarkCategory.culture,
        address: '777 Columbia St',
        description: 'Arts and culture venue with public events.',
      ),
      Landmark(
        id: 'l13',
        name: 'Massey Theatre',
        category: LandmarkCategory.culture,
        address: '735 Eighth Ave',
        description: 'Performance venue for concerts and shows.',
      ),
      Landmark(
        id: 'l14',
        name: 'Douglas College New West',
        category: LandmarkCategory.culture,
        address: '700 Royal Ave',
        description: 'Campus hub for Douglas College students.',
      ),
      Landmark(
        id: 'l15',
        name: 'Samson V Maritime Museum',
        category: LandmarkCategory.culture,
        address: 'Gallery at Quayside',
        description: 'Historic paddlewheeler ship museum exhibit.',
      ),
    ];
  }
}
