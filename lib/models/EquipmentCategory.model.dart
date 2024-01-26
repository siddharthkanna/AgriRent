class EquipmentCategory {
  final String title;
  final String iconUrl;

  EquipmentCategory({required this.title, required this.iconUrl});
}

List<EquipmentCategory> equipmentCategories = [
  EquipmentCategory(title: 'Baler', iconUrl: 'assets/category/baler.png'),
  EquipmentCategory(
    title: 'Cultivator',
    iconUrl: 'assets/category/cultivator.png',
  ),
  EquipmentCategory(
    title: 'Harvester',
    iconUrl: 'assets/category/harvester.png',
  ),
  EquipmentCategory(
    title: 'Rake',
    iconUrl: 'assets/category/rake.png',
  ),
  EquipmentCategory(
    title: 'Seeder',
    iconUrl: 'assets/category/seeder.png',
  ),
  EquipmentCategory(
    title: 'Sprayer',
    iconUrl: 'assets/category/sprayer.png',
  ),
  EquipmentCategory(
    title: 'Spreader',
    iconUrl: 'assets/category/spreader.png',
  ),
  EquipmentCategory(
    title: 'Sprinkler',
    iconUrl: 'assets/category/sprinkler.png',
  ),
  EquipmentCategory(
    title: 'Wheel Barrow',
    iconUrl: 'assets/category/wheelBarrow.png',
  ),
];

class MarketCategory {
  final String name;
  final String iconUrl;

  MarketCategory({required this.name, required this.iconUrl});
}

List<MarketCategory> marketCategories = [
  MarketCategory(
    name: 'Baler',
    iconUrl: 'assets/category/bw/balerbw.png',
  ),
  MarketCategory(
    name: 'Cultivator',
    iconUrl: 'assets/category/bw/cultivatorbw.png',
  ),
  MarketCategory(
    name: 'Harvester',
    iconUrl: 'assets/category/bw/harvesterbw.png',
  ),
  MarketCategory(
    name: 'Rake',
    iconUrl: 'assets/category/bw/rakebw.png',
  ),
  MarketCategory(
    name: 'Seeder',
    iconUrl: 'assets/category/bw/seederbw.png',
  ),
  MarketCategory(
    name: 'Sprayer',
    iconUrl: 'assets/category/bw/sprayerbw.png',
  ),
  MarketCategory(
    name: 'Spreader',
    iconUrl: 'assets/category/bw/spreaderbw.png',
  ),
  MarketCategory(
    name: 'Sprinkler',
    iconUrl: 'assets/category/bw/sprinklerbw.png',
  ),
  MarketCategory(
    name: 'Wheel Barrow',
    iconUrl: 'assets/category/bw/wheelBarrowbw.png',
  ),
];
