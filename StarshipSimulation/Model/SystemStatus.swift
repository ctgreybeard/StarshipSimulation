//
//  SystemStatus.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/30/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

var numSS = 0

class SystemStatus: SystemArrayObject {
    dynamic var functionalStatus: FunctionalStatus
    dynamic var operationalStatus: OperationalStatus
    dynamic var reliabilityFactor: ReliabilityFactor
    dynamic var energyRequirement: EnergyRequirement


    /// Init with standard values (100, 100, 100, 1.0)
    required init() {
        functionalStatus = 100
        operationalStatus = 100
        reliabilityFactor = 100
        energyRequirement = 1.0
        super.init()
        setID()
    }

    /// Init as a copy of the supplied SystemStatus
    convenience init(status: SystemStatus) {
        self.init(f: status.functionalStatus, o: status.operationalStatus, r: status.reliabilityFactor, e: status.energyRequirement)
    }

    /// Init with supplied values
    init(f: FunctionalStatus, o: OperationalStatus, r: ReliabilityFactor, e: EnergyRequirement) {
        self.functionalStatus = f
        self.operationalStatus = o
        self.reliabilityFactor = r
        self.energyRequirement = e
        super.init()
        setID()
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        return SystemStatus(status: self)
    }

    func setID() {
        mkSOID(.SystemStatus)
    }
}


// Below are some common systems that only hold status
// If they become more complex they should be moved to their own file

class PhaserStation: SystemStatus {
    var B5: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var B6: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var B7: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var B8: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return PhaserStation(status: self)
    }
}

class DeflectorShield: SystemStatus {
    var B9: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var CA: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var CB: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    // CC skipped?
    var CD: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return DeflectorShield(status: self)
    }
}

class CloakingDevice: SystemStatus {
    var CE: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var CF: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var CG: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    // Energy Requirement not referenced
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return CloakingDevice(status: self)
    }
}

class WarpEngine: SystemStatus {
    var CH: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var CI: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var CJ: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var CK: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return WarpEngine(status: self)
    }
}

class ImpulseEngine: SystemStatus {
    var CL: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var CM: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var CN: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var CO: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return ImpulseEngine(status: self)
    }
}

class NavigationComputer: SystemStatus {
    // Enterprise Data
    var CZ: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var C1: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var C2: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var C3: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return NavigationComputer(status: self)
    }
}

class MedicalResearchLab: SystemStatus {
    var C4: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var C5: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var C6: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var C7: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return MedicalResearchLab(status: self)
    }
}

class IntensiveCareUnit: SystemStatus {
    var C8: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var C9: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var DA: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var DB: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    var DC: Int {
        get {return patientCapacity}
        set {patientCapacity = newValue}
    }

    var patientCapacity: Int

    required init() {
        patientCapacity = 10
        super.init()
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = IntensiveCareUnit()
        newOne.functionalStatus = functionalStatus
        newOne.operationalStatus = operationalStatus
        newOne.reliabilityFactor = reliabilityFactor
        newOne.energyRequirement = energyRequirement
        newOne.patientCapacity = patientCapacity
        return newOne
    }
}

class MedicalComputer: SystemStatus {
    var DD: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var DE: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var DF: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var DG: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return MedicalComputer(status: self)
    }
}

class TurboElevatorStation: SystemStatus {
    var D9: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var EA: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var EB: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    // Energy Requirement not referenced
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return TurboElevatorStation(status: self)
    }
}

class TurboElevatorComputer: SystemStatus {
    var EH: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var EI: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var EJ: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var EK: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return TurboElevatorComputer(status: self)
    }
}

class TransporterStation: SystemStatus {
    var EL: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var EM: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var EN: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var EO: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return TransporterStation(status: self)
    }
}

class CommunicationsComputer: SystemStatus {
    var FS: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var FT: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var FU: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var FV: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return CommunicationsComputer(status: self)
    }
}

class DetentionCell: SystemStatus {
    var FW: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var FX: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var FY: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var FZ: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }

    var maximumPrisonerCapacity: Int
    var F1: Int {
        get {return maximumPrisonerCapacity}
        set {maximumPrisonerCapacity = newValue}
    }

    required init() {
        maximumPrisonerCapacity = 30
        super.init()
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = DetentionCell()
        newOne.functionalStatus = functionalStatus
        newOne.operationalStatus = operationalStatus
        newOne.reliabilityFactor = reliabilityFactor
        newOne.energyRequirement = energyRequirement
        newOne.maximumPrisonerCapacity = maximumPrisonerCapacity
        return newOne
    }
}

class ShuttleCraftPropulsionTube: SystemStatus {
    var DR: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var DS: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var DT: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var DU: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return ShuttleCraftPropulsionTube(status: self)
    }
}

class ShuttleCraftSensorArray: SystemStatus {
    var DW: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var DX: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var DY: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var DZ: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return ShuttleCraftSensorArray(status: self)
    }
}

class ShuttleCraftDefensiveWeapons: SystemStatus {
    var D1: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var D2: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var D3: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var D4: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return ShuttleCraftDefensiveWeapons(status: self)
    }
}

class ShuttleCraftOffensiveWeapons: SystemStatus {
    var D5: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var D6: OperationalStatus {
        get {return operationalStatus}
        set {operationalStatus = newValue}
    }
    var D7: ReliabilityFactor {
        get {return reliabilityFactor}
        set {reliabilityFactor = newValue}
    }
    var D8: EnergyRequirement {
        get {return energyRequirement}
        set {energyRequirement = newValue}
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return ShuttleCraftOffensiveWeapons(status: self)
    }
}
