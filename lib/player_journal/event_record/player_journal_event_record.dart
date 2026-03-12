import 'dart:convert';

import 'package:edna/player_journal/player_journal.dart';

export './player_journal_backpack_event_record.dart';
export './player_journal_backpack_materials_event_record.dart';
export './player_journal_carrier_name_change_event_record.dart';
export './player_journal_carrier_stats_event_record.dart';
export './player_journal_docked_event_record.dart';
export './player_journal_engineer_craft_event_record.dart';
export './player_journal_engineer_progress_event_record.dart';
export './player_journal_f_s_d_jump_event_record.dart';
export './player_journal_location_event_record.dart';
export './player_journal_market_event_record.dart';
export './player_journal_scan_event_record.dart';
export './player_journal_statistics_event_record.dart';
export './player_journal_synthesis_event_record.dart';
export './player_journal_carrier_jump_event_record.dart';
export './player_journal_commander_event_record.dart';
export './player_journal_continued_event_record.dart';
export './player_journal_fileheader_event_record.dart';
export './player_journal_music_event_record.dart';
export './player_journal_rank_event_record.dart';
export './player_journal_progress_event_record.dart';
export './player_journal_shutdown_event_record.dart';
export './player_journal_unknown_event_record.dart';

abstract class PlayerJournalEventRecord {

  final DateTime _timestamp;
  DateTime get timestamp => _timestamp;

  final PlayerJournalEventType _event;
  PlayerJournalEventType get event => _event;

  PlayerJournalEventRecord({ required final DateTime timestamp, required final PlayerJournalEventType event }): _timestamp = timestamp, _event = event;
  Map<String, dynamic> _rawJson = const {};
  Map<String, dynamic> get rawJson => _rawJson;

  static PlayerJournalEventRecord _createFromJson(final Map<String, dynamic> json) {
    final timestamp = DateTime.parse(json['timestamp'] as String);
    final PlayerJournalEventType event = json['event'] as String;
    switch (event) {

      case PlayerJournalCommanderEventRecord.type:
        final String fid = json['FID'] as String;
        final String name = json['Name'] as String;
        return PlayerJournalCommanderEventRecord(timestamp: timestamp, fid: fid, name: name);
      case PlayerJournalContinuedEventRecord.type:
        final part = json['Part'] as int;
        return PlayerJournalContinuedEventRecord(timestamp: timestamp, part: part);
      case PlayerJournalFileheaderEventRecord.type:
        final part = json['part'] as int;
        final String language = json['language'] as String;
        final String gameVersion = json['gameversion'] as String;
        final String build = json['build'].trim() as String;
        return PlayerJournalFileheaderEventRecord(timestamp: timestamp, part: part, language: language, gameVersion: gameVersion, build: build);
      case PlayerJournalMusicEventRecord.type:
        final musicTrack = json['MusicTrack'] as String;
        return PlayerJournalMusicEventRecord(timestamp: timestamp, musicTrack: musicTrack);
      case PlayerJournalRankEventRecord.type:
        final combat = json['Combat'] as int;
        final trade = json['Trade'] as int;
        final explore = json['Explore'] as int;
        final empire = json['Empire'] as int;
        final federation = json['Federation'] as int;
        final cqc = json['CQC'] as int;
        return PlayerJournalRankEventRecord(timestamp: timestamp, combat: combat, trade: trade, explore: explore, empire: empire, federation: federation, cqc: cqc);
      case PlayerJournalProgressEventRecord.type:
        final combat = json['Combat'] as int;
        final trade = json['Trade'] as int;
        final explore = json['Explore'] as int;
        final empire = json['Empire'] as int;
        final federation = json['Federation'] as int;
        final cqc = json['CQC'] as int;
        return PlayerJournalProgressEventRecord(timestamp: timestamp, combat: combat, trade: trade, explore: explore, empire: empire, federation: federation, cqc: cqc);
      case PlayerJournalShutdownEventRecord.type:
        return PlayerJournalShutdownEventRecord(timestamp: timestamp);      case PlayerJournalBackpackEventRecord.type:
        return PlayerJournalBackpackEventRecord(timestamp: timestamp);

      case PlayerJournalBackpackMaterialsEventRecord.type:
        final items = json['Items'] as List<dynamic>?; 
        final components = json['Components'] as List<dynamic>?; 
        final consumables = json['Consumables'] as List<dynamic>?; 
        final data = json['Data'] as List<dynamic>?; 
        return PlayerJournalBackpackMaterialsEventRecord(timestamp: timestamp, items: items, components: components, consumables: consumables, data: data);

      case PlayerJournalCarrierNameChangeEventRecord.type:
        final carrierid = json['CarrierID'] as int?; 
        final name = json['Name'] as String?; 
        final callsign = json['Callsign'] as String?; 
        return PlayerJournalCarrierNameChangeEventRecord(timestamp: timestamp, carrierid: carrierid, name: name, callsign: callsign);

      case PlayerJournalCarrierStatsEventRecord.type:
        final carrierid = json['CarrierID'] as int?; 
        final callsign = json['Callsign'] as String?; 
        final name = json['Name'] as String?; 
        final dockingaccess = json['DockingAccess'] as String?; 
        final allownotorious = json['AllowNotorious'] as bool?; 
        final fuellevel = json['FuelLevel'] as int?; 
        final jumprangecurr = (json['JumpRangeCurr'] as num?)?.toDouble();
        final jumprangemax = (json['JumpRangeMax'] as num?)?.toDouble();
        final pendingdecommission = json['PendingDecommission'] as bool?; 
        final spaceusage = json['SpaceUsage'] as Map<String, dynamic>?; 
        final finance = json['Finance'] as Map<String, dynamic>?; 
        final crew = json['Crew'] as List<dynamic>?; 
        final shippacks = json['ShipPacks'] as List<dynamic>?; 
        final modulepacks = json['ModulePacks'] as List<dynamic>?; 
        return PlayerJournalCarrierStatsEventRecord(timestamp: timestamp, carrierid: carrierid, callsign: callsign, name: name, dockingaccess: dockingaccess, allownotorious: allownotorious, fuellevel: fuellevel, jumprangecurr: jumprangecurr, jumprangemax: jumprangemax, pendingdecommission: pendingdecommission, spaceusage: spaceusage, finance: finance, crew: crew, shippacks: shippacks, modulepacks: modulepacks);

      case PlayerJournalDockedEventRecord.type:
        final stationname = json['StationName'] as String?; 
        final stationtype = json['StationType'] as String?; 
        final starsystem = json['StarSystem'] as String?; 
        final faction = json['Faction'] as String?; 
        final factionstate = json['FactionState'] as String?; 
        final allegiance = json['Allegiance'] as String?; 
        final economy = json['Economy'] as String?; 
        final economyLocalised = json['Economy_Localised'] as String?; 
        final government = json['Government'] as String?; 
        final governmentLocalised = json['Government_Localised'] as String?; 
        final security = json['Security'] as String?; 
        final securityLocalised = json['Security_Localised'] as String?; 
        final systemAddress = json['SystemAddress'] as int?; 
        final marketid = json['MarketID'] as int?; 
        final stationfaction = json['StationFaction'] as String?; 
        final stationgovernment = json['StationGovernment'] as String?; 
        final stationgovernmentLocalised = json['StationGovernment_Localised'] as String?; 
        final stationservices = json['StationServices'] as List<dynamic>?; 
        final stationeconomy = json['StationEconomy'] as String?; 
        final stationeconomyLocalised = json['StationEconomy_Localised'] as String?; 
        final stationeconomies = json['StationEconomies'] as List<dynamic>?; 
        final distfromstarls = (json['DistFromStarLS'] as num?)?.toDouble();
        return PlayerJournalDockedEventRecord(timestamp: timestamp, stationname: stationname, stationtype: stationtype, starsystem: starsystem, faction: faction, factionstate: factionstate, allegiance: allegiance, economy: economy, economyLocalised: economyLocalised, government: government, governmentLocalised: governmentLocalised, security: security, securityLocalised: securityLocalised, systemAddress: systemAddress, marketid: marketid, stationfaction: stationfaction, stationgovernment: stationgovernment, stationgovernmentLocalised: stationgovernmentLocalised, stationservices: stationservices, stationeconomy: stationeconomy, stationeconomyLocalised: stationeconomyLocalised, stationeconomies: stationeconomies, distfromstarls: distfromstarls);

      case PlayerJournalEngineerCraftEventRecord.type:
        final engineer = json['Engineer'] as String?; 
        final blueprint = json['Blueprint'] as String?; 
        final level = json['Level'] as int?; 
        final ingredients = json['Ingredients'] as Map<String, dynamic>?; 
        return PlayerJournalEngineerCraftEventRecord(timestamp: timestamp, engineer: engineer, blueprint: blueprint, level: level, ingredients: ingredients);

      case PlayerJournalEngineerProgressEventRecord.type:
        final engineer = json['Engineer'] as String?; 
        final progress = json['Progress'] as String?; 
        final engineerid = json['EngineerID'] as int?; 
        final rank = json['Rank'] as int?; 
        final engineers = json['Engineers'] as List<dynamic>?; 
        return PlayerJournalEngineerProgressEventRecord(timestamp: timestamp, engineer: engineer, progress: progress, engineerid: engineerid, rank: rank, engineers: engineers);

      case PlayerJournalFSDJumpEventRecord.type:
        final starsystem = json['StarSystem'] as String?; 
        final starpos = json['StarPos'] as List<dynamic>?; 
        final allegiance = json['Allegiance'] as String?; 
        final economy = json['Economy'] as String?; 
        final economyLocalised = json['Economy_Localised'] as String?; 
        final government = json['Government'] as String?; 
        final governmentLocalised = json['Government_Localised'] as String?; 
        final security = json['Security'] as String?; 
        final securityLocalised = json['Security_Localised'] as String?; 
        final jumpdist = (json['JumpDist'] as num?)?.toDouble();
        final fuelused = (json['FuelUsed'] as num?)?.toDouble();
        final fuellevel = (json['FuelLevel'] as num?)?.toDouble();
        final faction = json['Faction'] as String?; 
        final factionstate = json['FactionState'] as String?; 
        final systemAddress = json['SystemAddress'] as int?; 
        final systemallegiance = json['SystemAllegiance'] as String?; 
        final systemeconomy = json['SystemEconomy'] as String?; 
        final systemeconomyLocalised = json['SystemEconomy_Localised'] as String?; 
        final systemsecondeconomy = json['SystemSecondEconomy'] as String?; 
        final systemsecondeconomyLocalised = json['SystemSecondEconomy_Localised'] as String?; 
        final systemgovernment = json['SystemGovernment'] as String?; 
        final systemgovernmentLocalised = json['SystemGovernment_Localised'] as String?; 
        final systemsecurity = json['SystemSecurity'] as String?; 
        final systemsecurityLocalised = json['SystemSecurity_Localised'] as String?; 
        final population = json['Population'] as int?; 
        final factions = json['Factions'] as List<dynamic>?; 
        final systemfaction = json['SystemFaction'] as String?; 
        return PlayerJournalFSDJumpEventRecord(timestamp: timestamp, starsystem: starsystem, starpos: starpos, allegiance: allegiance, economy: economy, economyLocalised: economyLocalised, government: government, governmentLocalised: governmentLocalised, security: security, securityLocalised: securityLocalised, jumpdist: jumpdist, fuelused: fuelused, fuellevel: fuellevel, faction: faction, factionstate: factionstate, systemAddress: systemAddress, systemallegiance: systemallegiance, systemeconomy: systemeconomy, systemeconomyLocalised: systemeconomyLocalised, systemsecondeconomy: systemsecondeconomy, systemsecondeconomyLocalised: systemsecondeconomyLocalised, systemgovernment: systemgovernment, systemgovernmentLocalised: systemgovernmentLocalised, systemsecurity: systemsecurity, systemsecurityLocalised: systemsecurityLocalised, population: population, factions: factions, systemfaction: systemfaction);

      case PlayerJournalLocationEventRecord.type:
        final docked = json['Docked'] as bool?; 
        final stationname = json['StationName'] as String?; 
        final stationtype = json['StationType'] as String?; 
        final starsystem = json['StarSystem'] as String?; 
        final starpos = json['StarPos'] as List<dynamic>?; 
        final allegiance = json['Allegiance'] as String?; 
        final economy = json['Economy'] as String?; 
        final economyLocalised = json['Economy_Localised'] as String?; 
        final government = json['Government'] as String?; 
        final governmentLocalised = json['Government_Localised'] as String?; 
        final security = json['Security'] as String?; 
        final securityLocalised = json['Security_Localised'] as String?; 
        final body = json['Body'] as String?; 
        final bodytype = json['BodyType'] as String?; 
        final faction = json['Faction'] as String?; 
        final factionstate = json['FactionState'] as String?; 
        final marketid = json['MarketID'] as int?; 
        final stationfaction = json['StationFaction'] as String?; 
        final stationgovernment = json['StationGovernment'] as String?; 
        final stationgovernmentLocalised = json['StationGovernment_Localised'] as String?; 
        final stationservices = json['StationServices'] as List<dynamic>?; 
        final stationeconomy = json['StationEconomy'] as String?; 
        final stationeconomyLocalised = json['StationEconomy_Localised'] as String?; 
        final stationeconomies = json['StationEconomies'] as List<dynamic>?; 
        final systemAddress = json['SystemAddress'] as int?; 
        final systemallegiance = json['SystemAllegiance'] as String?; 
        final systemeconomy = json['SystemEconomy'] as String?; 
        final systemeconomyLocalised = json['SystemEconomy_Localised'] as String?; 
        final systemsecondeconomy = json['SystemSecondEconomy'] as String?; 
        final systemsecondeconomyLocalised = json['SystemSecondEconomy_Localised'] as String?; 
        final systemgovernment = json['SystemGovernment'] as String?; 
        final systemgovernmentLocalised = json['SystemGovernment_Localised'] as String?; 
        final systemsecurity = json['SystemSecurity'] as String?; 
        final systemsecurityLocalised = json['SystemSecurity_Localised'] as String?; 
        final population = json['Population'] as int?; 
        final bodyId = json['BodyID'] as int?; 
        final factions = json['Factions'] as List<dynamic>?; 
        final systemfaction = json['SystemFaction'] as String?; 
        return PlayerJournalLocationEventRecord(timestamp: timestamp, docked: docked, stationname: stationname, stationtype: stationtype, starsystem: starsystem, starpos: starpos, allegiance: allegiance, economy: economy, economyLocalised: economyLocalised, government: government, governmentLocalised: governmentLocalised, security: security, securityLocalised: securityLocalised, body: body, bodytype: bodytype, faction: faction, factionstate: factionstate, marketid: marketid, stationfaction: stationfaction, stationgovernment: stationgovernment, stationgovernmentLocalised: stationgovernmentLocalised, stationservices: stationservices, stationeconomy: stationeconomy, stationeconomyLocalised: stationeconomyLocalised, stationeconomies: stationeconomies, systemAddress: systemAddress, systemallegiance: systemallegiance, systemeconomy: systemeconomy, systemeconomyLocalised: systemeconomyLocalised, systemsecondeconomy: systemsecondeconomy, systemsecondeconomyLocalised: systemsecondeconomyLocalised, systemgovernment: systemgovernment, systemgovernmentLocalised: systemgovernmentLocalised, systemsecurity: systemsecurity, systemsecurityLocalised: systemsecurityLocalised, population: population, bodyId: bodyId, factions: factions, systemfaction: systemfaction);

      case PlayerJournalMarketEventRecord.type:
        final marketid = json['MarketID'] as int?; 
        final stationname = json['StationName'] as String?; 
        final stationtype = json['StationType'] as String?; 
        final starsystem = json['StarSystem'] as String?; 
        return PlayerJournalMarketEventRecord(timestamp: timestamp, marketid: marketid, stationname: stationname, stationtype: stationtype, starsystem: starsystem);

      case PlayerJournalScanEventRecord.type:
        final bodyname = json['BodyName'] as String?; 
        final distancefromarrivalls = (json['DistanceFromArrivalLS'] as num?)?.toDouble();
        final tidallock = json['TidalLock'] as bool?; 
        final terraformstate = json['TerraformState'] as String?; 
        final planetclass = json['PlanetClass'] as String?; 
        final atmosphere = json['Atmosphere'] as String?; 
        final atmospheretype = json['AtmosphereType'] as String?; 
        final volcanism = json['Volcanism'] as String?; 
        final massem = (json['MassEM'] as num?)?.toDouble();
        final radius = (json['Radius'] as num?)?.toDouble();
        final surfacegravity = (json['SurfaceGravity'] as num?)?.toDouble();
        final surfacetemperature = (json['SurfaceTemperature'] as num?)?.toDouble();
        final surfacepressure = (json['SurfacePressure'] as num?)?.toDouble();
        final landable = json['Landable'] as bool?; 
        final materials = json['Materials'] as Map<String, dynamic>?; 
        final semimajoraxis = (json['SemiMajorAxis'] as num?)?.toDouble();
        final eccentricity = (json['Eccentricity'] as num?)?.toDouble();
        final orbitalinclination = (json['OrbitalInclination'] as num?)?.toDouble();
        final periapsis = (json['Periapsis'] as num?)?.toDouble();
        final orbitalperiod = (json['OrbitalPeriod'] as num?)?.toDouble();
        final rotationperiod = (json['RotationPeriod'] as num?)?.toDouble();
        return PlayerJournalScanEventRecord(timestamp: timestamp, bodyname: bodyname, distancefromarrivalls: distancefromarrivalls, tidallock: tidallock, terraformstate: terraformstate, planetclass: planetclass, atmosphere: atmosphere, atmospheretype: atmospheretype, volcanism: volcanism, massem: massem, radius: radius, surfacegravity: surfacegravity, surfacetemperature: surfacetemperature, surfacepressure: surfacepressure, landable: landable, materials: materials, semimajoraxis: semimajoraxis, eccentricity: eccentricity, orbitalinclination: orbitalinclination, periapsis: periapsis, orbitalperiod: orbitalperiod, rotationperiod: rotationperiod);

      case PlayerJournalStatisticsEventRecord.type:
        final bankAccount = json['Bank_Account'] as Map<String, dynamic>?; 
        final combat = json['Combat'] as Map<String, dynamic>?; 
        final crime = json['Crime'] as Map<String, dynamic>?; 
        final smuggling = json['Smuggling'] as Map<String, dynamic>?; 
        final trading = json['Trading'] as Map<String, dynamic>?; 
        final mining = json['Mining'] as Map<String, dynamic>?; 
        final exploration = json['Exploration'] as Map<String, dynamic>?; 
        final passengers = json['Passengers'] as Map<String, dynamic>?; 
        final searchAndRescue = json['Search_And_Rescue'] as Map<String, dynamic>?; 
        final tgEncounters = json['TG_ENCOUNTERS'] as Map<String, dynamic>?; 
        final crafting = json['Crafting'] as Map<String, dynamic>?; 
        final crew = json['Crew'] as Map<String, dynamic>?; 
        final multicrew = json['Multicrew'] as Map<String, dynamic>?; 
        final materialTraderStats = json['Material_Trader_Stats'] as Map<String, dynamic>?; 
        final cqc = json['CQC'] as Map<String, dynamic>?; 
        final fleetcarrier = json['FLEETCARRIER'] as Map<String, dynamic>?; 
        return PlayerJournalStatisticsEventRecord(timestamp: timestamp, bankAccount: bankAccount, combat: combat, crime: crime, smuggling: smuggling, trading: trading, mining: mining, exploration: exploration, passengers: passengers, searchAndRescue: searchAndRescue, tgEncounters: tgEncounters, crafting: crafting, crew: crew, multicrew: multicrew, materialTraderStats: materialTraderStats, cqc: cqc, fleetcarrier: fleetcarrier);

      case PlayerJournalSynthesisEventRecord.type:
        final name = json['Name'] as String?; 
        final materials = json['Materials'] as Map<String, dynamic>?; 
        return PlayerJournalSynthesisEventRecord(timestamp: timestamp, name: name, materials: materials);

      case PlayerJournalCarrierJumpEventRecord.type:
        final docked = json['Docked'] as bool?; 
        final stationname = json['StationName'] as String?; 
        final stationtype = json['StationType'] as String?; 
        final marketid = json['MarketID'] as int?; 
        final stationfaction = json['StationFaction'] as Map<String, dynamic>?; 
        final stationgovernment = json['StationGovernment'] as String?; 
        final stationgovernmentLocalised = json['StationGovernment_Localised'] as String?; 
        final stationservices = json['StationServices'] as List<dynamic>?; 
        final stationeconomy = json['StationEconomy'] as String?; 
        final stationeconomyLocalised = json['StationEconomy_Localised'] as String?; 
        final stationeconomies = json['StationEconomies'] as List<dynamic>?; 
        final taxi = json['Taxi'] as bool?; 
        final multicrew = json['Multicrew'] as bool?; 
        final starsystem = json['StarSystem'] as String?; 
        final systemAddress = json['SystemAddress'] as int?; 
        final starpos = json['StarPos'] as List<dynamic>?; 
        final systemallegiance = json['SystemAllegiance'] as String?; 
        final systemeconomy = json['SystemEconomy'] as String?; 
        final systemeconomyLocalised = json['SystemEconomy_Localised'] as String?; 
        final systemsecondeconomy = json['SystemSecondEconomy'] as String?; 
        final systemsecondeconomyLocalised = json['SystemSecondEconomy_Localised'] as String?; 
        final systemgovernment = json['SystemGovernment'] as String?; 
        final systemgovernmentLocalised = json['SystemGovernment_Localised'] as String?; 
        final systemsecurity = json['SystemSecurity'] as String?; 
        final systemsecurityLocalised = json['SystemSecurity_Localised'] as String?; 
        final population = json['Population'] as int?; 
        final body = json['Body'] as String?; 
        final bodyId = json['BodyID'] as int?; 
        final bodytype = json['BodyType'] as String?; 
        final controllingpower = json['ControllingPower'] as String?; 
        final powers = json['Powers'] as List<dynamic>?; 
        final powerplaystate = json['PowerplayState'] as String?; 
        final powerplaystatecontrolprogress = (json['PowerplayStateControlProgress'] as num?)?.toDouble();
        final powerplaystatereinforcement = json['PowerplayStateReinforcement'] as int?; 
        final powerplaystateundermining = json['PowerplayStateUndermining'] as int?; 
        final factions = json['Factions'] as List<dynamic>?; 
        final systemfaction = json['SystemFaction'] as Map<String, dynamic>?; 
        return PlayerJournalCarrierJumpEventRecord(timestamp: timestamp, docked: docked, stationname: stationname, stationtype: stationtype, marketid: marketid, stationfaction: stationfaction, stationgovernment: stationgovernment, stationgovernmentLocalised: stationgovernmentLocalised, stationservices: stationservices, stationeconomy: stationeconomy, stationeconomyLocalised: stationeconomyLocalised, stationeconomies: stationeconomies, taxi: taxi, multicrew: multicrew, starsystem: starsystem, systemAddress: systemAddress, starpos: starpos, systemallegiance: systemallegiance, systemeconomy: systemeconomy, systemeconomyLocalised: systemeconomyLocalised, systemsecondeconomy: systemsecondeconomy, systemsecondeconomyLocalised: systemsecondeconomyLocalised, systemgovernment: systemgovernment, systemgovernmentLocalised: systemgovernmentLocalised, systemsecurity: systemsecurity, systemsecurityLocalised: systemsecurityLocalised, population: population, body: body, bodyId: bodyId, bodytype: bodytype, controllingpower: controllingpower, powers: powers, powerplaystate: powerplaystate, powerplaystatecontrolprogress: powerplaystatecontrolprogress, powerplaystatereinforcement: powerplaystatereinforcement, powerplaystateundermining: powerplaystateundermining, factions: factions, systemfaction: systemfaction);

      default:
        return PlayerJournalUnknownEventRecord(timestamp: timestamp, event: event);
    }
  }

  factory PlayerJournalEventRecord.fromJson(final Map<String, dynamic> json) {
    final record = _createFromJson(json);
    record._rawJson = json;
    return record;
  }

  factory PlayerJournalEventRecord.fromString(final String jsonString) => PlayerJournalEventRecord.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  @override
  String toString() {
    return '[$timestamp] $event';
  }
}
