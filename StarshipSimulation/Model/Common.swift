//
//  Common.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/8/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

// General purpose data structures, enums, protocols and the like shared across the simulator

import Foundation

let logger = XCGLogger()

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

enum ShipLocation: Int {
    case None = -1, Port = 0, Starboard, Top, Bottom, Fore, Aft
}

let ShipLocationName: [ShipLocation: String] = [
    .None: "None",
    .Port: "Port",
    .Starboard: "Starboard",
    .Top: "Top",
    .Bottom: "Bottom",
    .Fore: "Foreward",
    .Aft: "Aft"
]

/// Returns an Int in 0..<limit
func ssRandom(limit: Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)))
}

/// Returns a Double in 0..<1.0
func ssRandom() -> Double {
    let divisor = 1000000000
    return Double(ssRandom(divisor)) / Double(divisor)
}

/// Returns a Double with the requested mean and Std Dev
func ssRandomSND(mean: Double, stdDev: Double) -> Double {
    return (ssRandom() * 2 + ssRandom() * 2 + ssRandom() * 2 - 3 ) * stdDev + mean
}

