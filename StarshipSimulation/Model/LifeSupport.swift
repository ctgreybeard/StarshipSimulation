//
//  LifeSupport.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

/// Encapsulates all Life Support systms and functions
class LifeSupport: SystemObject {
    // Food Supply
    var foodQuantity: Int   // kg
    var EU: Int {
        get {return foodQuantity}
        set {foodQuantity = newValue}
    }
    var foodNutritionLevel: Percent
    var EV: Percent {
        get {return foodNutritionLevel}
        set {foodNutritionLevel = newValue}
    }
    var foodMaximumQuantity: Int
    var EW: Int {
        get {return foodMaximumQuantity}
        set {foodMaximumQuantity = newValue}
    }
    var foodPollutionLevel: Percent
    var EX: Percent {
        get {return foodPollutionLevel}
        set {foodPollutionLevel = newValue}
    }

    // Food Recycle System
    var foodRecycleSystemMaximumCapacity: Int
    var EY: Int {
        get {return foodRecycleSystemMaximumCapacity}
        set {foodRecycleSystemMaximumCapacity = newValue}
    }
    let foodRecycleSystem: SystemStatus
    var EZ: Int {
        get {return foodRecycleSystem.functionalStatus}
        set {foodRecycleSystem.functionalStatus = newValue}
    }
    var E1: Int {
        get {return foodRecycleSystem.operationalStatus}
        set {foodRecycleSystem.operationalStatus = newValue}
    }
    var E2: Int {
        get {return foodRecycleSystem.reliabilityFactor}
        set {foodRecycleSystem.reliabilityFactor = newValue}
    }
    var E3: EnergyRequirement {
        get {return foodRecycleSystem.energyRequirement}
        set {foodRecycleSystem.energyRequirement = newValue}
    }

    // Oxygen
    var oxygenQuantity: Int
    var E4: Int {
        get {return oxygenQuantity}
        set {oxygenQuantity = newValue}
    }
    var oxygenMaximumQuantity: Int
    var E5: Int {
        get {return oxygenMaximumQuantity}
        set {oxygenMaximumQuantity = newValue}
    }
    var oxygenPollutionLevel: Percent
    var E6: Percent {
        get {return oxygenPollutionLevel}
        set {oxygenPollutionLevel = newValue}
    }

    // Oxygen Distribution System
    let oxygenDistributionSystem: SystemStatus
    var E7: Int {
        get {return oxygenDistributionSystem.functionalStatus}
        set {oxygenDistributionSystem.functionalStatus = newValue}
    }
    var E8: Int {
        get {return oxygenDistributionSystem.operationalStatus}
        set {oxygenDistributionSystem.operationalStatus = newValue}
    }
    var E9: Int {
        get {return oxygenDistributionSystem.reliabilityFactor}
        set {oxygenDistributionSystem.reliabilityFactor = newValue}
    }
    var FA: EnergyRequirement {
        get {return oxygenDistributionSystem.energyRequirement}
        set {oxygenDistributionSystem.energyRequirement = newValue}
    }

    // Oxygen Recycle System
    let oxygenRecycleSystem: SystemStatus
    var FB: Int {
        get {return oxygenRecycleSystem.functionalStatus}
        set {oxygenRecycleSystem.functionalStatus = newValue}
    }
    var FC: Int {
        get {return oxygenRecycleSystem.operationalStatus}
        set {oxygenRecycleSystem.operationalStatus = newValue}
    }
    var FD: Int {
        get {return oxygenRecycleSystem.reliabilityFactor}
        set {oxygenRecycleSystem.reliabilityFactor = newValue}
    }
    var FE: EnergyRequirement {
        get {return oxygenRecycleSystem.energyRequirement}
        set {oxygenRecycleSystem.energyRequirement = newValue}
    }

    // Water
    var waterQuantity: Int  // kl
    var FF: Int {
        get {return waterQuantity}
        set {waterQuantity = newValue}
    }
    var waterMaximumQuantity: Int
    var FG: Int {
        get {return waterMaximumQuantity}
        set {waterMaximumQuantity = newValue}
    }
    var waterPollutionLevel: Percent
    var FH: Percent {
        get {return waterPollutionLevel}
        set {waterPollutionLevel = newValue}
    }

    // Water Distribution System
    let waterDistributionSystem: SystemStatus
    var FI: Int {
        get {return waterDistributionSystem.functionalStatus}
        set {waterDistributionSystem.functionalStatus = newValue}
    }
    var FJ: Int {
        get {return waterDistributionSystem.operationalStatus}
        set {waterDistributionSystem.operationalStatus = newValue}
    }
    var FK: Int {
        get {return waterDistributionSystem.reliabilityFactor}
        set {waterDistributionSystem.reliabilityFactor = newValue}
    }
    var FL: EnergyRequirement {
        get {return waterDistributionSystem.energyRequirement}
        set {waterDistributionSystem.energyRequirement = newValue}
    }

    // Water Recycle System
    let waterRecycleSystem: SystemStatus
    var FM: Int {
        get {return waterRecycleSystem.functionalStatus}
        set {waterRecycleSystem.functionalStatus = newValue}
    }
    var FN: Int {
        get {return waterRecycleSystem.operationalStatus}
        set {waterRecycleSystem.operationalStatus = newValue}
    }
    var FO: Int {
        get {return waterRecycleSystem.reliabilityFactor}
        set {waterRecycleSystem.reliabilityFactor = newValue}
    }
    var FP: EnergyRequirement {
        get {return waterRecycleSystem.energyRequirement}
        set {waterRecycleSystem.energyRequirement = newValue}
    }

    required init() {
        foodQuantity = 100000
        foodNutritionLevel = 100
        foodMaximumQuantity = foodQuantity
        foodPollutionLevel = 0

        foodRecycleSystemMaximumCapacity = foodMaximumQuantity * 2
        foodRecycleSystem = SystemStatus()

        oxygenQuantity = 1000000000
        oxygenMaximumQuantity = oxygenQuantity
        oxygenPollutionLevel = 0

        oxygenDistributionSystem = SystemStatus()
        oxygenRecycleSystem = SystemStatus()

        waterQuantity = 1000000
        waterMaximumQuantity = waterQuantity
        waterPollutionLevel = 0

        waterDistributionSystem = SystemStatus()

        waterRecycleSystem = SystemStatus()

        super.init()
        mkSOID(.LifeSupport)
    }
}