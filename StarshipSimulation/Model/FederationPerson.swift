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
    var BL: String {
        get {return name}
        set {name = newValue}
    }
    var rank: Rank
    var BM: FederationRank {
        get {return rank.rank}
        set {rank.rank = newValue}
    }
    var iq: Int
    var BN: Int {
        get {return iq}
        set {iq = newValue}
    }
    var location: Location
    var position: SpatialPosition? {
        get {return location.position}
        set {location.position = newValue}
    }
    var BO: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    var BP: Coordinate {
        get {return position?.x ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: newValue, y: BQ, z: BR)}
    }
    var BQ: Coordinate {
        get {return position?.y ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: newValue, z: BR)}
    }
    var BR: Coordinate {
        get {return position?.z ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: BQ, z: newValue)}
    }
    var destination: Location?
    var BS: Int! {
        get {return destination?.num ?? LocationCode.None.rawValue}
        set {
            if let newLoc = newValue {
                destination = Location(newLoc)
            } else {
                destination = nil
            }
        }
    }
    var functionalStatus: FunctionalStatus
    var BT: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var healthStatus: Int
    var BU: Int {
        get {return healthStatus}
        set {healthStatus = newValue}
    }

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