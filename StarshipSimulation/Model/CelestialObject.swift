//
//  CelestialObject.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/28/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

enum CelestialObjectClassification: Int {
    case None = 0, Star = 1, BlackHole, ParticleCloud, TimeWarp, Planet, Moon, Nova
}

/// TODO: Make CO a SystemArray

/// A Celestial Object
///
/// Two-letter variable aliases are supplied for each of the data points. The names of these is taken from the book.
/// Diversions from the book are taken where it is expedient.
class CelestialObject: SystemArrayObject {

    var coClass: CelestialObjectClassification
    dynamic var name: String
    dynamic var charted: Bool
    dynamic var x: Coordinate
    dynamic var y: Coordinate
    dynamic var z: Coordinate
    dynamic var xy: BigNum
    dynamic var xz: BigNum
    dynamic var speed: Double
    dynamic var radius: BigNum
    var radiation = Radiation()
    dynamic var mass: Int
    var lifeFormQuantity = 0
    var lifeFormClassification: LifeFormClassification = .None
    dynamic var lifeFormIQ: Int = 100
    dynamic var _defensiveWeapons: SystemArray
    dynamic var defensiveWeapons: SystemArrayAccess
    dynamic var _offensiveWeapons: SystemArray
    dynamic var offensiveWeapons: SystemArrayAccess
    dynamic var firedUpon: Bool = false
    dynamic var peaceTreatyOffer: Int = 0
    dynamic var peaceTreatyRequest: Bool = false

    var AH: Int {
        set {
            if let newClass = CelestialObjectClassification(rawValue: newValue) {
                coClass = newClass
            } else {
                coClass = .None
            }
        }
        get {
            return coClass.rawValue
        }
    }
    dynamic var AI: String {
        set {
            name = newValue
        }
        get {
            return name
        }
    }
    dynamic var JV: Bool {
        set {
            charted = newValue
        }
        get {
            return charted
        }
    }
    dynamic var AJ: Coordinate {
        set {
            x = newValue
        }
        get {
            return x
        }
    }
    dynamic var AK: Coordinate {
        set {
            y = newValue
        }
        get {
            return y
        }
    }
    dynamic var AL: Coordinate {
        set {
            z = newValue
        }
        get {
            return z
        }
    }
    dynamic var AM: BigNum {
        set {
            xy = newValue
        }
        get {
            return xy
        }
    }
    dynamic var AN: BigNum {
        set {
            xz = newValue
        }
        get {
            return xz
        }
    }
    dynamic var AO: Double {
        set {
            speed = newValue
        }
        get {
            return speed
        }
    }
    dynamic var AP: BigNum {
        set {
            radius = newValue
        }
        get {
            return radius
        }
    }
    var AQ: Int {
        set {
            if let newRad = RadiationType(rawValue: newValue) {
                radiation.type = newRad
            }
        }
        get {
            return radiation.type.rawValue
        }
    }
    dynamic var AR: Int {
        set {
            radiation.intensity = newValue
        }
        get {
            return radiation.intensity
        }
    }
    dynamic var AS: Int {
        set {
            mass = newValue
        }
        get {
            return mass
        }
    }
    dynamic var AT: Int {
        set {
            lifeFormQuantity = newValue
        }
        get {
            return lifeFormQuantity
        }
    }
    var AU: LifeFormClassification {
        set {
            lifeFormClassification = newValue
        }
        get {
            return lifeFormClassification
        }
    }
    dynamic var AV: Int {
        set {
            lifeFormIQ = newValue
        }
        get {
            return lifeFormIQ
        }
    }
    var AW: Int {return defensiveWeapons.count}
    let AX: SystemArrayAccess
    let AY: SystemArrayAccess
    let AZ: SystemArrayAccess
    let A1: SystemArrayAccess
    let A2: SystemArrayAccess
    var A3: Int {return offensiveWeapons.count}
    let A4: SystemArrayAccess
    let A5: SystemArrayAccess
    let A6: SystemArrayAccess
    let A7: SystemArrayAccess
    let A8: SystemArrayAccess
    var A9: Bool {
        set {
            firedUpon = newValue
        }
        get {
            return firedUpon
        }
    }
    var BA: Int {
        set {
            peaceTreatyOffer = newValue
        }
        get {
            return peaceTreatyOffer
        }
    }
    var BB: Bool {
        set {
            peaceTreatyRequest = newValue
        }
        get {
            return peaceTreatyRequest
        }
    }

    init(coClass: CelestialObjectClassification, name: String, charted: Bool, x: Coordinate, y: Coordinate, z: Coordinate, xy: Double, xz: Double, speed: Double, radius: BigNum, radiation: Radiation, mass: Int, numDefensiveWeapons: Int = 0, numOffensiveWeapons: Int = 0) {
        self.coClass = coClass
        self.name = name
        self.charted = charted
        self.x = x
        self.y = y
        self.z = z
        self.xy = xy
        self.xz = xz
        self.speed = speed
        self.radius = radius
        self.radiation = radiation
        self.mass = mass
        _defensiveWeapons = SSMakeSystemArray(count: numDefensiveWeapons, withType: DefensiveWeapon.self)
        defensiveWeapons = SystemArrayAccess(source: _defensiveWeapons)
        AX = SystemArrayAccess(source: _defensiveWeapons, member: "AX")
        AY = SystemArrayAccess(source: _defensiveWeapons, member: "AY")
        AZ = SystemArrayAccess(source: _defensiveWeapons, member: "AZ")
        A1 = SystemArrayAccess(source: _defensiveWeapons, member: "A1")
        A2 = SystemArrayAccess(source: _defensiveWeapons, member: "A2")
        _offensiveWeapons = SSMakeSystemArray(count: numOffensiveWeapons, withType: OffensiveWeapon.self)
        offensiveWeapons = SystemArrayAccess(source: _offensiveWeapons)
        A4 = SystemArrayAccess(source: _offensiveWeapons, member: "A4")
        A5 = SystemArrayAccess(source: _offensiveWeapons, member: "A5")
        A6 = SystemArrayAccess(source: _offensiveWeapons, member: "A6")
        A7 = SystemArrayAccess(source: _offensiveWeapons, member: "A7")
        A8 = SystemArrayAccess(source: _offensiveWeapons, member: "A8")
        super.init()
        mkSOID(.CelestialObject)
    }

    required convenience init() {
        var radNone = Radiation()
        self.init(coClass: .None, name: "None", charted: false, x: 0.0, y: 0.0, z: 0.0, xy: 0.0, xz: 0.0, speed: 0.0, radius: 1.0,
            radiation: radNone, mass: 1)
    }
}
