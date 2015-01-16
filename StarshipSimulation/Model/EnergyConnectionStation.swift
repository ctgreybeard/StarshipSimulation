//
//  EnergyConnectionStation.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

enum EnergyConnectionSystem: Int {
    case PhotonTorpedoTubes = 1
    case PhaserStations
    case DeflectorShields
    case SpaceWarpEngines
    case ImpulseEngines
    case NavigationComputer
    case ResearchLab
    case IntensiveCareUnit
    case MedicalComputer
    case TurboElelvatorComputer
    case Transporters
    case TractorBeam
    case OxygenDistributionSystem
    case OxygenRecycleSystem
    case WaterDistributionSystem
    case WaterRecycleSystem
    case CommunicationsComputer
    case Security
    case RadiationSensor
    case GravitySensor
    case LifeFormsSensor
    case AtmosphericSensor
}

class EnergyConnectionStation: SystemStatus {
    let system: EnergyConnectionSystem
    var energySupply: Int
    var F4: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var F5: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var F6: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var F7: Int {
        get {return energySupply}
        set {energySupply = newValue}
    }

    init(system: EnergyConnectionSystem, energySupply: Int) {
        self.system = system
        self.energySupply = energySupply
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}