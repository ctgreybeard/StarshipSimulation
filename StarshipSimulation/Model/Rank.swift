//
//  File.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/14/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

enum FederationRank: String {
    case None = "Civilian",
    ScienceOfficer = "Science Officer",
    EngineeringOfficer = "Engineering Officer",
    MedicalOfficer = "Medical Officer",
    ChiefMedicalOfficer = "Chief Medical Officer",
    SecurityOfficer = "Security Officer",
    MaintenanceCrew = "Maintenance Crew",
    GeneralCrew = "General Crew",
    RedShirt = "Red Shirt"
}

private let officers: [FederationRank] = [.ScienceOfficer, .EngineeringOfficer, .MedicalOfficer, .ChiefMedicalOfficer, .SecurityOfficer]
private let crew: [FederationRank] = [.MaintenanceCrew, .GeneralCrew, .RedShirt]

let numEnterpriseOfficers = 43
let numEnterpriseCrew = 387

class Rank: SystemObject, Printable, NSCopying, Hashable, Equatable {

    var rank: FederationRank

    required convenience init() {
        self.init(rank: .None)
    }

    init(rank: FederationRank) {
        self.rank = rank
        super.init()
        mkSOID(.Rank)
    }

    class func randomRank() -> Rank {
        let pick1 = random() % (numEnterpriseCrew + numEnterpriseOfficers)
        var pickRank: Rank

        if pick1 < numEnterpriseOfficers {
            pickRank = randomOfficerRank()
        } else {
            pickRank = randomCrewRank()
        }

        return pickRank
    }

    class func randomOfficerRank() -> Rank {
        let pick1 = random()  % officers.count
        var pickRank: FederationRank

        pickRank = officers[pick1]

        return Rank(rank: pickRank)
    }

    class func randomCrewRank() -> Rank {
        let pick1 = random() % crew.count
        var pickRank: FederationRank

        pickRank = crew[pick1]

        return Rank(rank: pickRank)
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return Rank(rank: rank)
    }

    func description() -> String {
        return rank.rawValue
    }

    override func isEqual(other: AnyObject?) -> Bool {
        if let oRank = other as? Rank {
            return self == oRank
        } else {
            return false
        }
    }

    override var hash: Int {return hashValue}

    override var hashValue: Int {return rank.rawValue.hashValue}
}

func ==(lhs: Rank, rhs: Rank) -> Bool {
    return lhs.rank == rhs.rank
}