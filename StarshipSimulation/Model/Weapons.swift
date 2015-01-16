//
//  Weapons.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/28/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

/// General Weapons class
///
/// Note that the systemStatus properties are double-aliased (AY/A5, AZ/A^, etc.) because defensive and offensive
/// weapons were assigned different sets. We can take advantage of subclassing, though, to combine the common
// properties of Weapons to use for both types.
class Weapon: SystemStatus {
    // There are so many of these to cover all the Federation and Enemy ship classifications
    var AY: FunctionalStatus {
        set {functionalStatus = newValue}
        get {return functionalStatus}
    }
    var AZ: OperationalStatus {
        set {operationalStatus = newValue}
        get {return operationalStatus}
    }
    var A1: ReliabilityFactor {
        set {reliabilityFactor = newValue}
        get {return reliabilityFactor}
    }
    var A2: EnergyRequirement {
        set {energyRequirement = newValue}
        get {return energyRequirement}
    }
    var A5: FunctionalStatus {
        set {functionalStatus = newValue}
        get {return functionalStatus}
    }
    var A6: OperationalStatus {
        set {operationalStatus = newValue}
        get {return operationalStatus}
    }
    var A7: ReliabilityFactor {
        set {reliabilityFactor = newValue}
        get {return reliabilityFactor}
    }
    var A8: EnergyRequirement {
        set {energyRequirement = newValue}
        get {return energyRequirement}
    }
    var GY: FunctionalStatus {
        set {functionalStatus = newValue}
        get {return functionalStatus}
    }
    var GZ: OperationalStatus {
        set {operationalStatus = newValue}
        get {return operationalStatus}
    }
    var G1: ReliabilityFactor {
        set {reliabilityFactor = newValue}
        get {return reliabilityFactor}
    }
    var G2: EnergyRequirement {
        set {energyRequirement = newValue}
        get {return energyRequirement}
    }
    var G5: FunctionalStatus {
        set {functionalStatus = newValue}
        get {return functionalStatus}
    }
    var G6: OperationalStatus {
        set {operationalStatus = newValue}
        get {return operationalStatus}
    }
    var G7: ReliabilityFactor {
        set {reliabilityFactor = newValue}
        get {return reliabilityFactor}
    }
    var G8: EnergyRequirement {
        set {energyRequirement = newValue}
        get {return energyRequirement}
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = Weapon()
        return newOne
    }

}

/// Combined types for Federation and Enemy ships
enum DefensiveWeaponType {
    case None, CloakingDevice, ShieldScreen
}

/// Let's hope UltimateDestruct is never needd!
enum OffensiveWeaponType {
    case None, Phaser, PhotonTorpedo, CommunicationsDisrupter, UltimateDestruct
}

/// Subclass of Weapon
class DefensiveWeapon: Weapon {
    var type: DefensiveWeaponType = .None
    var AX: DefensiveWeaponType {
        set {type = newValue}
        get {return type}
    }
    var GX: DefensiveWeaponType {
        set {type = newValue}
        get {return type}
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = super.copyWithZone(zone) as DefensiveWeapon
        newOne.type = type
        return newOne
    }
}

/// Subclass of Weapon
class OffensiveWeapon: Weapon {
    var type: OffensiveWeaponType = .None
    var A4: OffensiveWeaponType {
        set {type = newValue}
        get {return type}
    }
    var G4: OffensiveWeaponType {
        set {type = newValue}
        get {return type}
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = super.copyWithZone(zone) as OffensiveWeapon
        newOne.type = type
        return newOne
    }
}

