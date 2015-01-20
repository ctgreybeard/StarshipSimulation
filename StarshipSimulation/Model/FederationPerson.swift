//
//  FederationPerson.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

/// An officer or crew member
class FederationPerson: SystemArrayObject {

    var name: String
    var rank: Rank
    var iq: Int
    var location: Location
    var position: SpatialPosition? {
        get {return location.position}
        set {location.position = newValue}
    }
    var destination: Location?
    var functionalStatus: FunctionalStatus
    var healthStatus: Int

    required init() {
        name = Name()?.asString() ?? "No Name"
        let hRank = Rank.randomRank()
        rank = hRank
        iq = 100
        location = Location(hint: hRank)    // Make a logical choice based on their Rank
        destination = nil  // No destination
        functionalStatus = FunctionalStatus(100)
        healthStatus = 10
        super.init()
        mkSOID(.FederationPerson)
    }

    init(nname: String, nrank: Rank, niq: Int, nloc: Location, ndest: Location?, nfstat: FunctionalStatus, nhealth: Int) {
        name = nname
        rank = nrank
        iq = niq
        location = nloc
        destination = ndest
        functionalStatus = nfstat
        healthStatus = nhealth
        super.init()
        mkSOID(.FederationPerson)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = FederationPerson(nname: name, nrank: rank, niq: iq, nloc: location.copy() as Location, ndest: destination?.copy() as? Location, nfstat: functionalStatus, nhealth: healthStatus)
        return newOne
    }
}

class EnterprisePerson: FederationPerson {
    dynamic var BL: String {
        get {return name}
        set {name = newValue}
    }

    dynamic var BM: String {
        get {return rank.rank.rawValue}
        set {
            if let newRank = FederationRank(rawValue: newValue) {
                rank.rank = newRank
            }
        }
    }

    dynamic var BN: Int {
        get {return iq}
        set {iq = newValue}
    }

    dynamic var BO: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    dynamic var BOd: String {return location.description}

    dynamic var BP: Coordinate {
        get {return position?.x ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: newValue, y: BQ, z: BR)}
    }

    dynamic var BQ: Coordinate {
        get {return position?.y ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: newValue, z: BR)}
    }
    dynamic var BR: Coordinate {
        get {return position?.z ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: BQ, z: newValue)}
    }

    dynamic var BS: Int {
        get {return destination?.num ?? LocationCode.None.rawValue}
        set {
            if newValue == LocationCode.None.rawValue {
                destination = nil
            } else {
                destination = Location(newValue)
            }
        }
    }

    dynamic var BSd: String {return destination?.description ?? ""}

    dynamic var BT: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }

    dynamic var BU: Int {
        get {return healthStatus}
        set {healthStatus = newValue}
    }

    required init() {
        super.init()
        mkSOID(.EnterprisePerson)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = super.copyWithZone(zone) as EnterprisePerson
        newOne.mkSOID(.EnterprisePerson)
        return newOne
    }
}