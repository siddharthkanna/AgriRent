import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EquipmentCategory {
  final String englishTitle;
  final String localTitle;
  final String iconUrl;

  EquipmentCategory({
    required this.englishTitle,
    required this.localTitle,
    required this.iconUrl,
  });
}

class MarketCategory {
  final String englishName;
  final String localName;
  final String iconUrl;

  MarketCategory({
    required this.englishName,
    required this.localName,
    required this.iconUrl,
  });
}

class EquipmentCategories {
  static List<EquipmentCategory> getEquipmentCategories(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return [
      EquipmentCategory(
        englishTitle: 'Baler',
        localTitle: appLoc.baler,
        iconUrl: 'assets/category/baler.png',
      ),
      EquipmentCategory(
        englishTitle: 'Cultivator',
        localTitle: appLoc.cultivator,
        iconUrl: 'assets/category/cultivator.png',
      ),
      EquipmentCategory(
        englishTitle: 'Harvester',
        localTitle: appLoc.harvester,
        iconUrl: 'assets/category/harvester.png',
      ),
      EquipmentCategory(
        englishTitle: 'Rake',
        localTitle: appLoc.rake,
        iconUrl: 'assets/category/rake.png',
      ),
      EquipmentCategory(
        englishTitle: 'Seeder',
        localTitle: appLoc.seeder,
        iconUrl: 'assets/category/seeder.png',
      ),
      EquipmentCategory(
        englishTitle: 'Sprayer',
        localTitle: appLoc.sprayer,
        iconUrl: 'assets/category/sprayer.png',
      ),
      EquipmentCategory(
        englishTitle: 'Spreader',
        localTitle: appLoc.spreader,
        iconUrl: 'assets/category/spreader.png',
      ),
      EquipmentCategory(
        englishTitle: 'Sprinkler',
        localTitle: appLoc.sprinkler,
        iconUrl: 'assets/category/sprinkler.png',
      ),
      EquipmentCategory(
        englishTitle: 'Wheel Barrow',
        localTitle: appLoc.wheelBarrow,
        iconUrl: 'assets/category/wheelBarrow.png',
      ),
    ];
  }
}

class MarketCategories {
  static List<MarketCategory> getMarketCategories(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return [
      MarketCategory(
        englishName: 'Baler',
        localName: appLoc.baler,
        iconUrl: 'assets/category/bw/balerbw.png',
      ),
      MarketCategory(
        englishName: 'Cultivator',
        localName: appLoc.cultivator,
        iconUrl: 'assets/category/bw/cultivatorbw.png',
      ),
      MarketCategory(
        englishName: 'Harvester',
        localName: appLoc.harvester,
        iconUrl: 'assets/category/bw/harvesterbw.png',
      ),
      MarketCategory(
        englishName: 'Rake',
        localName: appLoc.rake,
        iconUrl: 'assets/category/bw/rakebw.png',
      ),
      MarketCategory(
        englishName: 'Seeder',
        localName: appLoc.seeder,
        iconUrl: 'assets/category/bw/seederbw.png',
      ),
      MarketCategory(
        englishName: 'Sprayer',
        localName: appLoc.sprayer,
        iconUrl: 'assets/category/bw/sprayerbw.png',
      ),
      MarketCategory(
        englishName: 'Spreader',
        localName: appLoc.spreader,
        iconUrl: 'assets/category/bw/spreaderbw.png',
      ),
      MarketCategory(
        englishName: 'Sprinkler',
        localName: appLoc.sprinkler,
        iconUrl: 'assets/category/bw/sprinklerbw.jpg',
      ),
      MarketCategory(
        englishName: 'Wheel Barrow',
        localName: appLoc.wheelBarrow,
        iconUrl: 'assets/category/bw/wheelBarrowbw.png',
      ),
    ];
  }
}
