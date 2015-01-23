//
//  LocationCode.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

enum LocationCode: Int {
    case Spatial = -1
    case Bridge = 0
    case SciencesLaboratory
    case Engineering
    case Brig
    case Security
    case NavigationComputer
    case MedicalResearchLaboratory
    case MedicalComputer
    case TurboElevatorComputer
    case TractorBeam
    case FoodProcessingPlant
    case OxygenDistributionAndRecycling
    case WaterDistributionAndRecycling
    case EnergySupply
    case IntensiveCareUnit
    case SensorStations
    case CrewsQuarters
    case Shuttlebay
    case TransporterStation = 20
    case TurboElevatorStation = 30
    case TurboElevator = 50
    case ShuttleCraft = 70
    case PhotonTorpedoTubeStation = 80
    case PhaserStationPort = 90
    case PhaserStationStarboard
    case PhaserStationTop
    case PhaserStationBottom
    case PhaserStationFore
    case PhaserStationAft
    case DeflectorShieldPort = 100
    case DeflectorShieldStarboard
    case DeflectorShieldTop
    case DeflectorShieldBottom
    case DeflectorShieldFore
    case DeflectorShieldAft
    case CelestialObject = 1000
    case EnemyCraft = 2000
    case FederationCraft = 3000
    case Enterprise = 4000
    case None = -9999
}

private let _crafts: [LocationCode] = [.CelestialObject, .EnemyCraft, .FederationCraft, .PhotonTorpedoTubeStation, .ShuttleCraft, .TurboElevator, .TurboElevatorStation, .TransporterStation]

private let hintLocation: [FederationRank: [LocationCode]] =
[.ScienceOfficer: [.Bridge, .SciencesLaboratory, .MedicalResearchLaboratory],
    .EngineeringOfficer: [.Bridge, .Engineering, .TurboElevatorComputer, .TractorBeam, .OxygenDistributionAndRecycling, .WaterDistributionAndRecycling, .EnergySupply],
    .MedicalOfficer: [.MedicalResearchLaboratory, .MedicalComputer, .IntensiveCareUnit],
    .SeniorMedicalOfficer: [.Bridge, .MedicalResearchLaboratory, .MedicalComputer, .IntensiveCareUnit],
    .SecurityOfficer: [.Brig, .Security, .Shuttlebay],
    .MaintenanceCrew: [.Engineering, .TractorBeam, .FoodProcessingPlant, .OxygenDistributionAndRecycling, .WaterDistributionAndRecycling, .EnergySupply, .PhaserStationPort, .PhaserStationStarboard, .PhaserStationTop, .PhaserStationBottom, .PhaserStationFore, .PhaserStationAft, .Shuttlebay, .SensorStations],
    .GeneralCrew: [.Bridge, .Brig, .EnergySupply, .Engineering, .FoodProcessingPlant, .MedicalResearchLaboratory, .OxygenDistributionAndRecycling, .PhaserStationAft, .PhaserStationBottom, .PhaserStationFore, .PhaserStationPort, .PhaserStationStarboard, .PhaserStationTop, .SciencesLaboratory, .Security, .SensorStations, .Shuttlebay, .TractorBeam, .TurboElevatorComputer, .WaterDistributionAndRecycling],
    .RedShirt: [.Bridge, .Brig, .EnergySupply, .Engineering, .FoodProcessingPlant, .MedicalResearchLaboratory, .OxygenDistributionAndRecycling, .PhaserStationAft, .PhaserStationBottom, .PhaserStationFore, .PhaserStationPort, .PhaserStationStarboard, .PhaserStationTop, .SciencesLaboratory, .Security, .SensorStations, .Shuttlebay, .TractorBeam, .TurboElevatorComputer, .WaterDistributionAndRecycling]
]

private let locDescription: [LocationCode: String] = [
    .Spatial: "Spatial",
    .Bridge: "Bridge",
    .SciencesLaboratory: "Sciences Lab",
    .Engineering: "Engineering",
    .Brig: "Brig",
    .Security: "Security",
    .NavigationComputer: "Navigation Computer",
    .MedicalResearchLaboratory: "Medical Research Laboratory",
    .MedicalComputer: "Medical Computer",
    .TurboElevatorComputer: "Turbo Elevator Computer",
    .TractorBeam: "Tractor Beam",
    .FoodProcessingPlant: "Food Processing Plant",
    .OxygenDistributionAndRecycling: "Oxygen Distribution And Recycling",
    .WaterDistributionAndRecycling: "Water Distribution And Recycling",
    .EnergySupply: "Energy Supply",
    .IntensiveCareUnit: "Intensive Care Unit",
    .SensorStations: "Sensor Stations",
    .CrewsQuarters: "Crews Quarters",
    .Shuttlebay: "Shuttlebay",
    .TransporterStation: "Transporter Station",
    .TurboElevatorStation: "Turbo Elevator Station",
    .TurboElevator: "Turbo Elevator",
    .ShuttleCraft: "Shuttle Craft",
    .PhotonTorpedoTubeStation: "Photon Torpedo Tube Station",
    .PhaserStationPort: "Phaser Station-Port",
    .PhaserStationStarboard: "Phaser Station-Starboard",
    .PhaserStationTop: "Phaser Station-Top",
    .PhaserStationBottom: "Phaser Station-Bottom",
    .PhaserStationFore: "Phaser Station-Fore",
    .PhaserStationAft: "Phaser Station-Aft",
    .DeflectorShieldPort: "Deflector Shield-Port",
    .DeflectorShieldStarboard: "Deflector Shield-Starboard",
    .DeflectorShieldTop: "Deflector Shield-Top",
    .DeflectorShieldBottom: "Deflector Shield-Bottom",
    .DeflectorShieldFore: "Deflector Shield-Fore",
    .DeflectorShieldAft: "Deflector Shield-Aft",
    .CelestialObject: "Celestial Object",
    .EnemyCraft: "Enemy Craft",
    .FederationCraft: "Federation Craft",
    .Enterprise: "Enterprise",
    .None: "None"
]

class Location: SystemArrayObject, Equatable, Printable {
    private var _code: LocationCode
    var code: LocationCode {
        return _code
    }
    dynamic var craftOrObjectNum: Int
    private var _position: SpatialPosition?
    var position: SpatialPosition? {
        set {
            if newValue != nil {
                _code = .Spatial
                craftOrObjectNum = -1
            }
            _position = newValue
        }
        get {return _position}
    }
    var num: Int {
        get {
            var rVal: Int
            if isCraft {
                rVal = _code.rawValue + craftOrObjectNum
            } else {
                rVal = _code.rawValue
            }

            return rVal
        }
        set {
            setNum(newValue)
        }
    }

    var isCraft: Bool {
        return _crafts.filter({$0 == self._code}).count > 0
    }

    override var description: String {
        var ans: String
        ans = locDescription[_code] ?? "?"
        if isCraft {
            ans += "(\(craftOrObjectNum))"
        }
        return ans
    }

    /// null initializer
    required convenience init() {
        self.init(code: .None, craft: -1, position: nil)
    }

    init(code: LocationCode, craft: Int, position: SpatialPosition?) {
        _code = code
        craftOrObjectNum = craft
        _position = position
        super.init()
        mkSOID(.Location)
    }

    convenience init(_ num: Int) {
        self.init()
        self.setNum(num)
    }

    convenience init(_ newPos: SpatialPosition) {
        self.init()
        setPos(newPos)
    }

    // Not to be used with "craft" locations
    convenience init?(code: LocationCode) {
        if _crafts.filter({$0 == code}).count > 0 {
            self.init(code: .None, craft: -1, position: nil)
            return nil
        }
        self.init(code: code, craft: -1, position: nil)
    }

    convenience init(hint: Rank) {
        if ssRandom(4) == 0 {      // 1 in 4 chance that they are at work
            if let possibles = hintLocation[hint.rank] {
                self.init(code: possibles[ssRandom(possibles.count)], craft: -1, position: nil)
            } else {
                self.init(code: .CrewsQuarters, craft: -1, position: nil)   // We don't know who they are so they are probably sleeping
            }
        } else {
            self.init(code: .CrewsQuarters, craft: -1, position: nil)
        }
    }

    func setPos(newValue: SpatialPosition) {
        position = newValue
    }

    func setNum(newValue: Int) {
        switch newValue {
            // Test first for one of the ranges values, set the base code and Object number
        case LocationCode.TransporterStation.rawValue..<LocationCode.TurboElevatorStation.rawValue:
            _code = .TransporterStation
            craftOrObjectNum = newValue - LocationCode.TransporterStation.rawValue
        case LocationCode.TurboElevatorStation.rawValue..<LocationCode.TurboElevator.rawValue:
            _code = .TurboElevatorStation
            craftOrObjectNum = newValue - LocationCode.TurboElevatorStation.rawValue
        case LocationCode.TurboElevator.rawValue..<LocationCode.ShuttleCraft.rawValue:
            _code = .TurboElevator
            craftOrObjectNum = newValue - LocationCode.TurboElevator.rawValue
        case LocationCode.ShuttleCraft.rawValue..<LocationCode.PhotonTorpedoTubeStation.rawValue:
            _code = .ShuttleCraft
            craftOrObjectNum = newValue - LocationCode.ShuttleCraft.rawValue
        case LocationCode.PhotonTorpedoTubeStation.rawValue..<LocationCode.PhaserStationPort.rawValue:
            _code = .PhotonTorpedoTubeStation
            craftOrObjectNum = newValue - LocationCode.PhotonTorpedoTubeStation.rawValue
        case LocationCode.CelestialObject.rawValue...LocationCode.EnemyCraft.rawValue:
            _code = .CelestialObject
            craftOrObjectNum = newValue - LocationCode.CelestialObject.rawValue
        case LocationCode.EnemyCraft.rawValue...LocationCode.FederationCraft.rawValue:
            _code = .EnemyCraft
            craftOrObjectNum = newValue - LocationCode.EnemyCraft.rawValue
        case LocationCode.FederationCraft.rawValue...LocationCode.Enterprise.rawValue:
            _code = .FederationCraft
            craftOrObjectNum = newValue - LocationCode.FederationCraft.rawValue
        default:
            if let newCode = LocationCode(rawValue: newValue) {
                _code = newCode
                craftOrObjectNum = -1
            } else {
                _code = .None
                craftOrObjectNum = -1
            }
        }
        position = nil
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = Location(code: _code, craft: craftOrObjectNum, position: position)
        return newOne
    }

}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs._code != rhs._code && lhs.isCraft && lhs.craftOrObjectNum == rhs.craftOrObjectNum
}