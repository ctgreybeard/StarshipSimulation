//
//  FleetShip.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/5/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

enum ShipMission: Int {
    case None = 0
    case ConditionalAttack, UnConditionalAttack
    case EstablishPeaceTreaty
    case SearchAndConquerCivilization
    case WeaponsDelivery
    case PeacefulCargoDelivery
}

// The following applies to both Enemy and Federation Ships

class FleetShip: SystemArrayObject {
    var name: String
    var existence: Bool

    var defensiveWeapons: SystemArray
    var offensiveWeapons: SystemArray
    var lifeFormQuantity: Int
    var lifeFormClassification: LifeFormClassification = .None
    var lifeFormIQ: Int
    var lifeFormStatus: SystemStatus
    var lifeFormHealthStatus: Int
    var position: SpatialPosition
    var velocity: Velocity
    var maxSpeed: Int
    var destination: Location
    var navigationComputer: NavigationComputer
    var mission: ShipMission
    var cargo: SystemArray
    var peaceTreatyOffered: Int
    var peaceTreatyRequest: Bool
    var energyQuantity: Double
    var firedUponFlag: Int

    required init() {
        name = "No Name"
        existence = true
        defensiveWeapons = SystemArray()
        offensiveWeapons = SystemArray()
        lifeFormQuantity = 0
        lifeFormClassification = .None
        lifeFormIQ = 100
        lifeFormStatus = SystemStatus()
        lifeFormHealthStatus = 100
        position = SpatialPosition()
        velocity = Velocity()
        maxSpeed = 1
        destination = Location()
        navigationComputer = NavigationComputer()
        mission = .None
        cargo = SystemArray()
        peaceTreatyOffered = 0
        peaceTreatyRequest = false
        energyQuantity = 5.0e10
        firedUponFlag = 0
        super.init()
        mkSOID(.FleetShip)
    }
}

class EnemyShip: FleetShip {
    var GU: String {
        get {return name}
        set {name = newValue}
    }
    var GV: Bool {
        get {return existence}
        set {existence = newValue}
    }
    var GW: Int {
        get {return defensiveWeapons.count}
    }
    var GX: SystemArrayAccess!
    var GY: SystemArrayAccess!
    var GZ: SystemArrayAccess!
    var G1: SystemArrayAccess!
    var G2: SystemArrayAccess!
    var G3: Int {
    get {return offensiveWeapons.count}
    }
    var G4: SystemArrayAccess!
    var G5: SystemArrayAccess!
    var G6: SystemArrayAccess!
    var G7: SystemArrayAccess!
    var G8: SystemArrayAccess!
    var HA: Int {
        get {return lifeFormClassification.rawValue}
        set {
            if let newLife = LifeFormClassification(rawValue: newValue) {
                lifeFormClassification = newLife
            }
        }
    }
    var HB: Int {
        get {return lifeFormQuantity}
        set {lifeFormQuantity = newValue}
    }
    var HC: Int {
        get {return lifeFormIQ}
        set {lifeFormIQ = newValue}
    }
    var HD: FunctionalStatus {
        get {return lifeFormStatus.functionalStatus}
        set {lifeFormStatus.functionalStatus = newValue}
    }
    var HE: OperationalStatus {
        get {return lifeFormStatus.operationalStatus}
        set {lifeFormStatus.operationalStatus = newValue}
    }
    var HF: ReliabilityFactor {
        get {return lifeFormStatus.reliabilityFactor}
        set {lifeFormStatus.reliabilityFactor = newValue}
    }
    var HG: Int {
        get {return lifeFormHealthStatus}
        set {lifeFormHealthStatus = newValue}
    }
    var HH: Coordinate {
        get {return position.x}
        set {position.x = newValue}
    }
    var HI: Coordinate {
        get {return position.y}
        set {position.y = newValue}
    }
    var HJ: Coordinate {
        get {return position.z}
        set {position.z = newValue}
    }
    var HK: BigNum {
        get {return velocity.xy}
        set {velocity.xy = newValue}
    }
    var HL: BigNum {
        get {return velocity.xz}
        set {velocity.xz = newValue}
    }
    var HM: BigNum {
        get {return velocity.speed}
        set {velocity.speed = newValue}
    }
    var HN: Int {
        get {return maxSpeed}
        set {maxSpeed = newValue}
    }
    var HO: Int {
        get {return destination.num}
        set {destination.num = newValue}
    }
    var HOposition: SpatialPosition? {
        get {return destination.position}
        set {destination.position = newValue}
    }
// HP, HQ, HR not individually settable, use HOposition
    var HP: Coordinate {return destination.position?.x ?? Coordinate(0.0)}
    var HQ: Coordinate {return destination.position?.y ?? Coordinate(0.0)}
    var HR: Coordinate {return destination.position?.z ?? Coordinate(0.0)}
    var HS: FunctionalStatus {
        get {return navigationComputer.functionalStatus}
        set {navigationComputer.functionalStatus = newValue}
    }
    var HT: OperationalStatus {
        get {return navigationComputer.operationalStatus}
        set {navigationComputer.operationalStatus = newValue}
    }
    var HU: ReliabilityFactor {
        get {return navigationComputer.reliabilityFactor}
        set {navigationComputer.reliabilityFactor = newValue}
    }
    var HV: EnergyRequirement {
        get {return navigationComputer.energyRequirement}
        set {navigationComputer.energyRequirement = newValue}
    }
    var HW: Int {
        get {return mission.rawValue}
        set {
            if let newMission = ShipMission(rawValue: newValue) {
                mission = newMission
            }
        }
    }
    var HX: SystemArrayAccess!
    var HY: SystemArrayAccess!
    var HZ: SystemArrayAccess!
    var H1: SystemArrayAccess!
    var H2: SystemArrayAccess!
    var H3: SystemArrayAccess!
    var H4: SystemArrayAccess!
    var H5: Int {
        get {return peaceTreatyOffered}
        set {peaceTreatyOffered = newValue}
    }
    var H6: Bool {
        get {return peaceTreatyRequest}
        set {peaceTreatyRequest = newValue}
    }
    var H7: Double {
        get {return energyQuantity}
        set {energyQuantity = newValue}
    }
    var H8: Int {
        get {return firedUponFlag}
        set {firedUponFlag = newValue}
    }

    required convenience init() {
        self.init(name: "No Name")
    }

    init(name: String) {
        super.init()
        mkSOID(.EnemyShip)
        self.name = name
        GX = SystemArrayAccess(source: defensiveWeapons, member: "AX")
        GY = SystemArrayAccess(source: defensiveWeapons, member: "GY")
        GZ = SystemArrayAccess(source: defensiveWeapons, member: "GZ")
        G1 = SystemArrayAccess(source: defensiveWeapons, member: "G1")
        G2 = SystemArrayAccess(source: defensiveWeapons, member: "G2")

        G4 = SystemArrayAccess(source: offensiveWeapons, member: "A4")
        G5 = SystemArrayAccess(source: offensiveWeapons, member: "G5")
        G6 = SystemArrayAccess(source: offensiveWeapons, member: "G6")
        G7 = SystemArrayAccess(source: offensiveWeapons, member: "G7")
        G8 = SystemArrayAccess(source: offensiveWeapons, member: "G8")

        HX = SystemArrayAccess(source: cargo)   // Returns the instance of Cargo at [n]
        HY = SystemArrayAccess(source: cargo, member: "HY")
        HZ = SystemArrayAccess(source: cargo, member: "HZ")
        H1 = SystemArrayAccess(source: cargo, member: "H1")
        H2 = SystemArrayAccess(source: cargo, member: "H2")
        H3 = SystemArrayAccess(source: cargo, member: "H3")
        H4 = SystemArrayAccess(source: cargo, member: "H4")

    }

    /// Map EnemyShip keys to FederationShip keys, they are nearly the same
    ///
    /// JF, JG, and JH exist in the FederationShip definition but they don't make much sense
    /// We have left them out for now.
    let keyMap = [
        // Name
        "IA": "GU",
        "IB": "GV",
        // Defensive Weapons
        "IC": "GW",
        "ID": "GX",
        "IE": "GY",
        "IF": "GZ",
        "IG": "G1",
        "IH": "G2",
        // Offensive Weapons
        "IJ": "G3",
        "IK": "G4",
        "IL": "G5",
        "IM": "G6",
        "IN": "G7",
        "IO": "G8",
        // Life Forms
        "IP": "HB",
        "IQ": "HC",
        "IR": "HD",
        "IS": "HE",
        "IT": "HF",
        "IU": "HG",
        // Navigation Data
        // Location
        "IV": "HH",
        "IW": "HI",
        "IX": "HJ",
        // Velocity
        "IY": "HK",
        "IZ": "HL",
        "I1": "HM",
        "I2": "HN",
        // Destination
        "I3": "HO",
        "I4": "HP",
        "I5": "HQ",
        "I6": "HR",
        // Navigation Computer
        "I7": "HS",
        "I8": "HT",
        "I9": "HU",
        "JA": "HV",
        // Mission
        "JB": "HW",
        // Cargo
        "JC": "HX",
        "JD": "HY",
        "JE": "HZ",
        // JF - Cargo Location x, y, z - No equivalent and probably not needed
        // JG
        // JH
        "JI": "H1",
        "JK": "H2",
        "JL": "H3",
        "JM": "H4",
        // Peace Treaty Offered
        "JN": "H5",
        // Peace Treaty Request
        "JO": "H6",
        // Energy
        "JP": "H7",
        // Fired Upon
        "JQ": "H8",
    ]

    override func valueForUndefinedKey(key: String) -> AnyObject? {
        if let commonKey = keyMap[key] {
            return valueForKey(commonKey)
        } else {
            return nil
        }
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if let commonKey = keyMap[key] {
            setValue(value, forKey: commonKey)
        }
    }
}

typealias FederationShip = EnemyShip



