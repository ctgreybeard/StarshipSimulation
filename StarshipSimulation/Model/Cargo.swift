//
//  Cargo.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

enum CargoType: Int {
    case None = -1
    case Food = 0
    case Water
    case Oxygen
    case Energy
    case Bomb
}

class Cargo: SystemArrayObject {
    var type: CargoType
    var quantity: Int
    var location: Location

    required convenience init() {
        self.init(type: .None, quantity: 0, location: LocationCode.None.rawValue)
    }

    init(type: CargoType, quantity: Int, location: Int) {
        self.type = type
        self.quantity = quantity
        self.location = Location(location)
        super.init()
        mkSOID(.Cargo)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = Cargo(type: type, quantity: quantity, location: location.num)
        return newOne
    }
}

class EnterpriseCargo: Cargo {
    var GP: Int {
        get {return type.rawValue}
        set {
            if let newType = CargoType(rawValue: newValue) {
                type = newType
            }
        }
    }
    var GQ: Int {
        get {return quantity}
        set {quantity = newValue}
    }
    var GR: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return EnterpriseCargo(type: type, quantity: quantity, location: location.num)
    }
}

class FleetShipCargo: Cargo {
    var HX: Int {
        get {return type.rawValue}
        set {
            if let newType = CargoType(rawValue: newValue) {
                type = newType
            }
        }
    }
    var HY: Int {
        get {return quantity}
        set {quantity = newValue}
    }
    var H1: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return FleetShipCargo(type: type, quantity: quantity, location: location.num)
    }
}