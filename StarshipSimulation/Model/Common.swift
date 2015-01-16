//
//  Common.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 12/8/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

// General purpose data structures, enums, protocols and the like shared across the simulator

import Foundation

/// For holding really large numbers. A Double maybe? Or Float80 for REALLY big numbers
typealias BigNum = Double

/// For spatial coordinates
typealias Coordinate = Double

/// Percentages as Int I think ...
typealias Percent = Int

/// System Array Access List
typealias SystemArrayAccessList = [SystemArrayAccess]

/// System Statuses
typealias FunctionalStatus = Int
typealias OperationalStatus = Int
typealias ReliabilityFactor = Int
typealias EnergyRequirement = Double

enum RadiationType: Int {
    case None = 0, Light, Radioactive
}

struct Radiation {
    var type: RadiationType = .None
    var intensity = 0
}

enum LifeFormClassification: Int {
    case None = 0, Humanoid, Vegitation, Aquatic, SelfIntelligent
}

enum AlertStatus: Int {
    case Normal = 0
    case Yellow
    case Green
    case Red
}

