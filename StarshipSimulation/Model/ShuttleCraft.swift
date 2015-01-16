//
//  ShuttleCraft.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 1/1/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

enum ShuttleCraftOperationalStatus: Int {
    case InShuttleBay = 0
    case OnMission = 1
}

enum ShuttleCraftMission: Int {
    case None = 0
    case SeekSensorData
    case DeliverCargo
    case TransportPersonnel
    case SeekShuttleBay
}

var numShuttlCraft = 0

class ShuttleCraft: SystemArrayObject {
    var operationalStatus: ShuttleCraftOperationalStatus
    var DI: Int {
        get {return operationalStatus.rawValue}
        set {
            if let newStatus = ShuttleCraftOperationalStatus(rawValue: newValue) {
                operationalStatus = newStatus
            }
        }
    }
    var location: SpatialPosition
    var DJ: Coordinate {
        get {return location.x}
        set {location.x = newValue}
    }
    var DK: Coordinate {
        get {return location.y}
        set {location.y = newValue}
    }
    var DL: Coordinate {
        get {return location.z}
        set {location.z = newValue}
    }
    var velocity: Velocity
    var DM: BigNum {
        get {return velocity.xy}
        set {velocity.xy = newValue}
    }
    var DN: BigNum {
        get {return velocity.xz}
        set {velocity.xz = newValue}
    }
    var DO: BigNum {
        get {return velocity.speed}
        set {velocity.speed = newValue}
    }
    var mission: ShuttleCraftMission
    var DP: Int {
        get {return mission.rawValue}
        set {
            if let newStatus = ShuttleCraftMission(rawValue: newValue) {
                mission = newStatus
            }
        }
    }
    var destination: Location
    var DQ: Int {
        get {return destination.num}
        set {destination.num = newValue}
    }

    // Propulsion
    var propulsionTubes: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: propulsionTubes, accessList: propulsionTubesArrayAccessList)
        }
    }
    var numPropulsionTubes: Int {return propulsionTubes.count}
    let DR: SystemArrayAccess
    let DS: SystemArrayAccess
    let DT: SystemArrayAccess
    let DU: SystemArrayAccess
    let propulsionTubesArrayAccessList: [SystemArrayAccess]

    // Cargo
    var cargo: String

    // Sensor Array
    var sensorArray: ShuttleCraftSensorArray
    var DW: Int {
        get {return sensorArray.DW}
        set {sensorArray.DW = newValue}
    }
    var DX: Int {
        get {return sensorArray.DX}
        set {sensorArray.DX = newValue}
    }
    var DY: Int {
        get {return sensorArray.DY}
        set {sensorArray.DY = newValue}
    }
    var DZ: Double {
        get {return sensorArray.DZ}
        set {sensorArray.DZ = newValue}
    }

    // Defensive Weapons
    let shield: ShuttleCraftDefensiveWeapons
    var D1: Int {
        get {return shield.D1}
        set {shield.D1 = newValue}
    }
    var D2: Int {
        get {return shield.D2}
        set {shield.D2 = newValue}
    }
    var D3: Int {
        get {return shield.D3}
        set {shield.D3 = newValue}
    }
    var D4: Double {
        get {return shield.D4}
        set {shield.D4 = newValue}
    }

    // Offensive Weapons
    let phaser: ShuttleCraftOffensiveWeapons
    var D5: Int {
        get {return phaser.D5}
        set {phaser.D6 = newValue}
    }
    var D6: Int {
        get {return phaser.D6}
        set {phaser.D6 = newValue}
    }
    var D7: Int {
        get {return phaser.D7}
        set {phaser.D7 = newValue}
    }
    var D8: Double {
        get {return phaser.D8}
        set {phaser.D8 = newValue}
    }

    required init() {
        operationalStatus = .InShuttleBay
        location = SpatialPosition()
        velocity = Velocity()
        mission = .None
        destination = Location()
        let defaultNumPropulsionTubes = 2
        propulsionTubes = SystemArray(num: defaultNumPropulsionTubes, withType: ShuttleCraftPropulsionTube.self)
        DR = SystemArrayAccess(source: propulsionTubes, member: "DR")
        DS = SystemArrayAccess(source: propulsionTubes, member: "DS")
        DT = SystemArrayAccess(source: propulsionTubes, member: "DT")
        DU = SystemArrayAccess(source: propulsionTubes, member: "DU")
        propulsionTubesArrayAccessList = [DR, DS, DT, DU]
        cargo = ""
        sensorArray = ShuttleCraftSensorArray()
        shield = ShuttleCraftDefensiveWeapons()
        phaser = ShuttleCraftOffensiveWeapons()
        super.init()
        mkSOID(.ShuttleCraft)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        // TODO: Allow copying shuttlecraft
        abort()
    }
}