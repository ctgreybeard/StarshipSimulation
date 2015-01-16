//
//  TractorBeam.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

class TractorBeam: SystemStatus {
    var EP: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var EQ: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var ER: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var ES: Int {
        get {return object.num}
        set {object.num = newValue}
    }
    var EScode: LocationCode {  // Read-only
        get {return object.code}
    }
    var ET: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    let object: Location

    required init() {
        object = Location()
        super.init()
    }
}