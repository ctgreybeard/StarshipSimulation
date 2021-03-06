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
    SeniorMedicalOfficer = "Senior Medical Officer",
    SecurityOfficer = "Security Officer",
    MaintenanceCrew = "Maintenance Crew",
    GeneralCrew = "General Crew",
    RedShirt = "Red Shirt"
}

let FederationRankOrder: [FederationRank: NSNumber] =
[   .None: 0,
    .RedShirt: 10,
    .GeneralCrew: 20,
    .MaintenanceCrew: 30,
    .SecurityOfficer: 40,
    .ScienceOfficer: 50,
    .EngineeringOfficer: 60,
    .MedicalOfficer: 70,
    .SeniorMedicalOfficer: 80
]

private let officers: [FederationRank] = [.ScienceOfficer, .EngineeringOfficer, .MedicalOfficer, .SeniorMedicalOfficer, .SecurityOfficer]
private let crew: [FederationRank] = [.MaintenanceCrew, .GeneralCrew]

let numEnterpriseOfficers = 43
let numEnterpriseCrew = 387

class Rank: SystemObject, Printable, NSCopying, Hashable, Equatable, Comparable {

    var rank: FederationRank

    dynamic override var description: String {
        return rank.rawValue
    }

    required convenience init() {
        self.init(rank: .None)
    }

    init(rank: FederationRank) {
        self.rank = rank
        super.init()
        mkSOID(.Rank)
    }

    class func randomRank() -> Rank {
        let pick1 = ssRandom(numEnterpriseCrew + numEnterpriseOfficers)
        var pickRank: Rank

        if pick1 < numEnterpriseOfficers {
            pickRank = randomOfficerRank()
        } else {
            pickRank = randomCrewRank()
        }

        return pickRank
    }

    class func randomOfficerRank() -> Rank {
        let pick1 = ssRandom(officers.count)
        var pickRank: FederationRank

        pickRank = officers[pick1]

        return Rank(rank: pickRank)
    }

    class func randomCrewRank() -> Rank {
        let pick1 = ssRandom(crew.count)
        var pickRank: FederationRank

        pickRank = crew[pick1]

        // 10% of crew are "RedShirts" and doomed on any away mission!
        if ssRandom(10) == 0 {
            pickRank = .RedShirt
        }

        return Rank(rank: pickRank)
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return Rank(rank: rank)
    }

    override func isEqual(other: AnyObject?) -> Bool {
        if let oRank = other as? Rank {
            return self == oRank
        } else {
            return false
        }
    }

    func compare(other: Rank) -> NSComparisonResult {
            return FederationRankOrder[rank]!.compare(FederationRankOrder[other.rank]!)
    }

    override var hash: Int {return hashValue}

    override var hashValue: Int {return rank.rawValue.hashValue}
}

func ==(lhs: Rank, rhs: Rank) -> Bool {
    return lhs == rhs
}

func <(lhs: Rank, rhs: Rank) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}