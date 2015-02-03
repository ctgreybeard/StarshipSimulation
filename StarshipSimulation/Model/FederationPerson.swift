//
//  FederationPerson.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

private let infoArrayFP = ["_name","rank","iq","location","position","destination","functionalStatus","healthStatus"]

/// An officer or crew member
class FederationPerson: SystemArrayObject {

    var personInfo: String {
        return "\(name)|\(rank)|\(iq)|\(location)|\(destination)|\(functionalStatus)|\(healthStatus)"
    }
    class func keyPathsForValuesAffectingPersonInfo() -> NSSet {
        logger.debug("Entry")
        return NSSet(array: infoArrayFP)
    }

    dynamic var _name: Name
    var name: String {return _name.asString()}
    class func keyPathsForValuesAffectingName() -> NSSet {
        return NSSet(array: ["_name"])
    }

    dynamic var rank: Rank

    dynamic var iq: Int

    dynamic var location: Location

    dynamic var position: SpatialPosition? {
        get {return location.position}
        set {location.position = newValue}
    }
    class func keyPathsForValuesAffectingPosition() -> NSSet {
        return NSSet(array: ["location","location.position"])
    }

    dynamic var destination: Location?

    dynamic var functionalStatus: FunctionalStatus

    dynamic var healthStatus: Int

    required init() {
        _name = Name()
        let hRank = Rank.randomRank()
        rank = hRank
        iq = Int(ssRandomSND(130.0, 15.0))
        location = Location(hint: hRank)    // Make a logical choice based on their Rank
        destination = nil  // No destination
        functionalStatus = FunctionalStatus(min(100, Int(104.0 - ssRandomSND(8.0, 4.0))))    // Everybody is raring to go!
        healthStatus = max(1, min(10, Int(14.0 - ssRandomSND(3.0, 2.0))))                    // And mostly healthy
        super.init()
        mkSOID(.FederationPerson)
    }

    init(nname: Name, nrank: Rank, niq: Int, nloc: Location, ndest: Location?, nfstat: FunctionalStatus, nhealth: Int) {
        _name = nname.copy() as Name
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
        let newOne = FederationPerson(nname: _name, nrank: rank, niq: iq, nloc: location.copy() as Location, ndest: destination?.copy() as? Location, nfstat: functionalStatus, nhealth: healthStatus)
        return newOne
    }
}

private let infoArrayEP = ["BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU"]

class EnterprisePerson: FederationPerson {

    class override func keyPathsForValuesAffectingPersonInfo() -> NSSet {
        logger.debug("Entry")
        return super.keyPathsForValuesAffectingPersonInfo().setByAddingObjectsFromArray(infoArrayEP)
    }

    dynamic var BL: String {
        get {return name}
        set {_name = Name(name: newValue)}
    }
    class func keyPathsForValuesAffectingBL() -> NSSet {
        return super.keyPathsForValuesAffectingName().setByAddingObject("name")
    }

    var BLid: String {return soID.description}
    class func keyPathsForValuesAffectingBLid() -> NSSet {
        return NSSet(array: ["soID","soID.description"])
    }

    var BLgiven: String {return _name.given}
    class func keyPathsForValuesAffectingBLgiven() -> NSSet {
        return NSSet(array: ["_name","_name.given"])
    }

    var BLsurname: String {return _name.sur}
    class func keyPathsForValuesAffectingBLsurname() -> NSSet {
        return NSSet(array: ["_name","_name.sur"])
    }

    dynamic var BM: String {
        get {return rank.description}
        set {
            if let newRank = FederationRank(rawValue: newValue) {
                rank.rank = newRank
            }
        }
    }
    class func keyPathsForValuesAffectingBM() -> NSSet {
        return NSSet(array: ["rank","rank.rank"])
    }

    dynamic var BN: Int {
        get {return iq}
        set {iq = newValue}
    }
    class func keyPathsForValuesAffectingBN() -> NSSet {
        return NSSet(array: ["iq"])
    }

    dynamic var BO: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    class func keyPathsForValuesAffectingBO() -> NSSet {
        return NSSet(array: ["location","location.num"])
    }

    var BOd: String {return location.description}
    class func keyPathsForValuesAffectingBOd() -> NSSet {
        return keyPathsForValuesAffectingBO().setByAddingObject("BO")
    }

    dynamic var BP: Coordinate {
        get {return position?.x ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: newValue, y: BQ, z: BR)}
    }
    class func keyPathsForValuesAffectingBP() -> NSSet {
        return super.keyPathsForValuesAffectingPosition().setByAddingObjectsFromArray(["position","position.x"])
    }

    dynamic var BQ: Coordinate {
        get {return position?.y ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: newValue, z: BR)}
    }
    class func keyPathsForValuesAffectingBQ() -> NSSet {
        return super.keyPathsForValuesAffectingPosition().setByAddingObjectsFromArray(["position","position.y"])
    }

    dynamic var BR: Coordinate {
        get {return position?.z ?? Coordinate(0.0)}
        set {position = SpatialPosition(x: BP, y: BQ, z: newValue)}
    }
    class func keyPathsForValuesAffectingBR() -> NSSet {
        return super.keyPathsForValuesAffectingPosition().setByAddingObjectsFromArray(["position","position.z"])
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
    class func keyPathsForValuesAffectingBS() -> NSSet {
        return NSSet(array: ["destination","destination.num"])
    }

    var BSd: String {return destination?.description ?? "—"}
    class func keyPathsForValuesAffectingBSd() -> NSSet {
        return keyPathsForValuesAffectingBS().setByAddingObject("BS")
    }

    dynamic var BT: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    class func keyPathsForValuesAffectingBT() -> NSSet {
        return NSSet(array: ["functionalStatus"])
    }

    dynamic var BU: Int {
        get {return healthStatus}
        set {healthStatus = newValue}
    }
    class func keyPathsForValuesAffectingBU() -> NSSet {
        return NSSet(array: ["healthStatus"])
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