//
//  Sensors.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 1/5/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

class Sensor: SystemStatus {
    required init() {
        super.init()
        mkSOID(.Sensor)
    }
}

class RadiationSensor: Sensor {
    var F8: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var F9: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var GA: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var GB: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    required init() {
        super.init()
        mkSOID(.RadiationSensor)
    }
}

class GravitySensor: Sensor {
    var GC: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var GD: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var GE: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var GF: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    required init() {
        super.init()
        mkSOID(.GravitySensor)
    }
}

class LifeFormsSensor: Sensor {
    var GH: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var GI: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var GJ: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var GK: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    required init() {
        super.init()
        mkSOID(.LifeFormsSensor)
    }
}

class AtmosphericSensor: Sensor {
    var GL: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var GM: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var GN: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var GO: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    required init() {
        super.init()
        mkSOID(.AtmosphericSensor)
    }
}