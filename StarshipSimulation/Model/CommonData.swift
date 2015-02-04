//
//  CommonData.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation
//import XCGLogger

/// Global logger object
//let logger = XCGLogger()

/// Global function to reset source array value for SystemArrayAccess objects
func setSystemArrayAccessFor(#array: SystemArray, accessList list: [SystemArrayAccess]) {
    for a in list {
        a.setSource(array)
    }
}

/// This is "The Big One" that holds all the simulation variables as described (variations noted) in the book.
///
/// Generally, each data item has two names: the "normal" Swiftian name and the two-letter name from the book.
/// Some liberties have been taken to take advantage of object-oriented capabilities. We are not stuck in a
/// Basic or Fortran world after all.
///
/// An example of this is the AH (Celestial Object Classification [page 45]) variable. In this implementation AH refers
/// to the raw value (an Int) of CelestialObjectClassification enum. AH is the raw value if the coClass variable in the CelestialObject instance.
/// So where in the book AH is a number and coClass is the enum.
/// AH[0] would be the class number of the first CO referenced from CommonData. AH would the class number referenced from the CelestialObject instance itself.
///
/// Note that SystemArrayAccess subscript() returns AnyObject? and the returned value should be cast appropriately.
///
/// This convention is used throughout this implementation where it makes sense.
class CommonData: NSObject {
    /// Initializers

    /// For convenience, supplies a reasonable Universe Size (I think)
    convenience override init() {
        self.init(max: 10.0e12)
    }

    /// Designated initializer. The work happens here
    init(max: Coordinate) {
        logger.debug("Entry")
        // It's a cubical world ...
        xMax = max
        xMin = -xMax
        yMax = xMax
        yMin = xMin
        zMax = xMax
        zMin = xMin

        logger.debug("Init Celestial Objects")
        // Things Celestial
        _celestialObjects = SystemArray()
        celestialObjects = SystemArrayAccess(source: _celestialObjects)

        AH = SystemArrayAccess(source: _celestialObjects, member: "AH")  // classification enum 7
        AI = SystemArrayAccess(source: _celestialObjects, member: "AI")  // name
        JV = SystemArrayAccess(source: _celestialObjects, member: "JV")  // charted bool
        // Location
        AJ = SystemArrayAccess(source: _celestialObjects, member: "AJ")  // coordinate
        AK = SystemArrayAccess(source: _celestialObjects, member: "AK")  // coordinate
        AL = SystemArrayAccess(source: _celestialObjects, member: "AL")  // coordinate
        // Velocity
        AM = SystemArrayAccess(source: _celestialObjects, member: "AM")  // direction
        AN = SystemArrayAccess(source: _celestialObjects, member: "AN")  // direction
        AO = SystemArrayAccess(source: _celestialObjects, member: "AO")  // speed
        AP = SystemArrayAccess(source: _celestialObjects, member: "AP")  // radius
        // Radiation
        AQ = SystemArrayAccess(source: _celestialObjects, member: "AQ")  // radiationtype enum 2
        AR = SystemArrayAccess(source: _celestialObjects, member: "AR")  // radiationintensity int
        AS = SystemArrayAccess(source: _celestialObjects, member: "AS")  // mass
        // Life Forms
        AT = SystemArrayAccess(source: _celestialObjects, member: "AT")  // quantity int
        AU = SystemArrayAccess(source: _celestialObjects, member: "AU")  // lifeformclassification enum 4
        AV = SystemArrayAccess(source: _celestialObjects, member: "AV")  // iq int
        // Defensive Weapons
        AW = SystemArrayAccess(source: _celestialObjects, member: "AW", readOnly: true) // quantity int
        AX = SystemArrayAccess(source: _celestialObjects, members: ["defensiveWeapons", "AX"])   // weapontype enum 1
        AY = SystemArrayAccess(source: _celestialObjects, members: ["defensiveWeapons", "AY"])   // functionalstatus
        AZ = SystemArrayAccess(source: _celestialObjects, members: ["defensiveWeapons", "AZ"])   // operationalstatus
        A1 = SystemArrayAccess(source: _celestialObjects, members: ["defensiveWeapons", "A1"])   // reliabilityfactor
        A2 = SystemArrayAccess(source: _celestialObjects, members: ["defensiveWeapons", "A2"])   // energyrequirement
        // Offensive Weapons
        A3 = SystemArrayAccess(source: _celestialObjects, member: "A3", readOnly: true) // quantity int
        A4 = SystemArrayAccess(source: _celestialObjects, members: ["offensiveWeapons", "A4"])   // weapontype enum 4
        A5 = SystemArrayAccess(source: _celestialObjects, members: ["offensiveWeapons", "A5"])   // functionalstatus
        A6 = SystemArrayAccess(source: _celestialObjects, members: ["offensiveWeapons", "A6"])   // operationalstatus
        A7 = SystemArrayAccess(source: _celestialObjects, members: ["offensiveWeapons", "A7"])   // reliabilityfactor
        A8 = SystemArrayAccess(source: _celestialObjects, members: ["offensiveWeapons", "A8"])   // energyrequirement
        A9 = SystemArrayAccess(source: _celestialObjects, member: "A9")
        BA = SystemArrayAccess(source: _celestialObjects, member: "BA")
        BB = SystemArrayAccess(source: _celestialObjects, member: "BB")
        celestialObjectsAccessList = [celestialObjects, AH, AI, JV, AJ, AK, AL, AM, AN, AO, AP, AQ, AR, AS, AT, AU, AV, AW, AX, AY, AZ, A1, A2, A3, A4, A5, A6, A7, A8, A9, BA, BB]

        logger.debug("Init Empire Locations")
        // Empire locations
        romulanEmpire = SpatialVolume()
        klingonEmpire = SpatialVolume()

        // Enterprise Data

        logger.debug("Init Enterprise Personnel")
        // Enterprise Personnel
        let defaultNumEnterprisePersons = 43 + 387
        SSenterprisePersonnel = SSMakeSystemArray(count: defaultNumEnterprisePersons, withType: EnterprisePerson.self)
        enterprisePersonnelSAA = SystemArrayAccess(source: SSenterprisePersonnel, readOnly: false)

        BL = SystemArrayAccess(source: SSenterprisePersonnel, member: "BL")   // Name
        BLid = SystemArrayAccess(source: SSenterprisePersonnel, member: "BLid", readOnly: true)   // soID.description
        BLgiven = SystemArrayAccess(source: SSenterprisePersonnel, member: "BLgiven", readOnly: true)
        BLsurname = SystemArrayAccess(source: SSenterprisePersonnel, member: "BLsurname", readOnly: true)
        BM = SystemArrayAccess(source: SSenterprisePersonnel, member: "BM")   // Rank
        BN = SystemArrayAccess(source: SSenterprisePersonnel, member: "BN")   // IQ
        BO = SystemArrayAccess(source: SSenterprisePersonnel, member: "BO")   // Location
        BOd = SystemArrayAccess(source: SSenterprisePersonnel, member: "BOd") // Location description
        BP = SystemArrayAccess(source: SSenterprisePersonnel, member: "BP")   // X-coordinate
        BQ = SystemArrayAccess(source: SSenterprisePersonnel, member: "BQ")   // Y-coordinate
        BR = SystemArrayAccess(source: SSenterprisePersonnel, member: "BR")   // Z-coordinate
        BS = SystemArrayAccess(source: SSenterprisePersonnel, member: "BS")   // Destination
        BSd = SystemArrayAccess(source: SSenterprisePersonnel, member: "BSd") // Destination description
        BT = SystemArrayAccess(source: SSenterprisePersonnel, member: "BT")   // functionalstatus
        BU = SystemArrayAccess(source: SSenterprisePersonnel, member: "BU")
        enterprisePersonsArrayAccessList = [enterprisePersonnelSAA, BL, BM, BN, BO, BP, BQ, BR, BS, BT, BU]

        foodConsumption = 1.0       // kg/hr
        waterConsumption = 1.0      // l/hr
        oxygenConsumption = 1.0     // l/hr
        logger.debug("Init Enterprise Personnel complete. \(SSenterprisePersonnel.count) created")

        // Enterprise Offensive Weapons Data

        logger.debug("Init Photon Tubes")
        // Photon Tubes
        let defaultNumPhotonTubes = 6
        SSPhotonTubes = SSMakeSystemArray(count: defaultNumPhotonTubes, withType: PhotonTube.self)
        photonTubes = SystemArrayAccess(source: SSPhotonTubes)
        // Set the torpedo locations
        let numTorps = (photonTubes[0] as PhotonTube).torpedos.count
        for p in 0..<photonTubes.count {
            let tube = photonTubes[p] as PhotonTube
            tube.location = ShipLocation(rawValue: p) ?? ShipLocation.None
            for t in 0..<numTorps {
                tube.B3[t] = LocationCode.PhotonTorpedoTubeStation.rawValue + p
            }
        }
        BY = SystemArrayAccess(source: SSPhotonTubes, member: "BY")   // functionalstatus
        BZ = SystemArrayAccess(source: SSPhotonTubes, member: "BZ")   // reliabilityfactor
        B1 = SystemArrayAccess(source: SSPhotonTubes, member: "B1")   // energyrequirement
        B2 = SystemArrayAccess(source: SSPhotonTubes, member: "B2", readOnly: true)
        B3 = SystemArrayAccess(source: SSPhotonTubes, members: ["torpedos", "B3"])
        B4 = SystemArrayAccess(source: SSPhotonTubes, members: ["torpedos", "B4"])
        photonTubesArrayAccessList = [photonTubes, BY, BZ, B1, B2, B3, B4]
        logger.debug("Init Photon Tubes complete. \(SSPhotonTubes.count) created")

        logger.debug("Init Phaser Stations")
        // Phaser Stations
        let defaultNumPhaserStations = 6
        SSphaserStations = SSMakeSystemArray(count: defaultNumPhaserStations, withType: PhaserStation.self)
        phaserStations = SystemArrayAccess(source: SSphaserStations)
        B5 = SystemArrayAccess(source: SSphaserStations, member: "B5")   // functionalstatus
        B6 = SystemArrayAccess(source: SSphaserStations, member: "B6")   // operationalstatus
        B7 = SystemArrayAccess(source: SSphaserStations, member: "B7")   // reliabilityfactor
        B8 = SystemArrayAccess(source: SSphaserStations, member: "B8")   // energyrequirement
        phaserStationsArrayAccessList = [phaserStations, B5, B6, B7, B8]
        logger.debug("Init Phaser Stations complete. \(SSphaserStations.count) created")

        // Enterprise Defensive Weapons Data

        logger.debug("Init Deflector Shields")
        // Deflector Shields
        let defaultNumDeflectorShields = 6
        SSdeflectorShields = SSMakeSystemArray(count: defaultNumDeflectorShields, withType: DeflectorShield.self)
        deflectorShields = SystemArrayAccess(source: SSdeflectorShields)
        B9 = SystemArrayAccess(source: SSdeflectorShields, member: "B9")   // functionalstatus
        CA = SystemArrayAccess(source: SSdeflectorShields, member: "CA")   // operationalstatus
        CB = SystemArrayAccess(source: SSdeflectorShields, member: "CB")   // reliabilityfactor
        CD = SystemArrayAccess(source: SSdeflectorShields, member: "CD")   // energyrequirement
        deflectorShieldsArrayAccessList = [deflectorShields, B9, CA, CB, CD]

        logger.debug("Init Cloaking Device")
        // Cloaking Device
        cloakingDevice = CloakingDevice()

        // Enterprise Propulsion Data

        logger.debug("Init Warp Engines")
        // Warp Engines
        let defaultNumWarpEngines = 2
        SSwarpEngines = SSMakeSystemArray(count: defaultNumWarpEngines, withType: WarpEngine.self)
        warpEngines = SystemArrayAccess(source: SSwarpEngines)
        CH = SystemArrayAccess(source: SSwarpEngines, member: "CH")   // functionalstatus
        CI = SystemArrayAccess(source: SSwarpEngines, member: "CI")   // operationalstatus
        CJ = SystemArrayAccess(source: SSwarpEngines, member: "CJ")   // reliabilityfactor
        CK = SystemArrayAccess(source: SSwarpEngines, member: "CK")   // energyrequirement
        warpEnginesArrayAccessList = [warpEngines, CH, CI, CJ, CK]

        logger.debug("Init Impulse Engines")
        // Impulse Engines
        let defaultNumImpulseEngines = 2
        SSimpulseEngines = SSMakeSystemArray(count: defaultNumImpulseEngines, withType: ImpulseEngine.self)
        impulseEngines = SystemArrayAccess(source: SSimpulseEngines)
        CL = SystemArrayAccess(source: SSimpulseEngines, member: "CL")   // functionalstatus
        CM = SystemArrayAccess(source: SSimpulseEngines, member: "CM")   // operationalstatus
        CN = SystemArrayAccess(source: SSimpulseEngines, member: "CN")   // reliabilityfactor
        CO = SystemArrayAccess(source: SSimpulseEngines, member: "CO")   // energyrequirement
        impulseEnginesArrayAccessList = [impulseEngines, CL, CM, CN, CO]

        // Enterprise Navigation Data

        logger.debug("Init Enterprise Navigation Data")
        // Location
        enterprisePosition = SpatialPosition()

        // Velocity Vector
        enterpriseVelocity = Velocity()

        // Destination
        enterpriseDestination = Location()

        logger.debug("Init Enterprise Computer Systems")
        // Navigation Computer
        navigationComputer = NavigationComputer()

        // Enterprise Medical Section Data

        // Medical Research Lab
        medicalResearchLab = MedicalResearchLab()

        // Intensive Care Unit
        intensiveCareUnit = IntensiveCareUnit()

        // Medical Computer
        medicalComputer = MedicalComputer()

        // Medical Supplies Quantity
        medicalSuppliesQuantity = 300       /// MARK: TBD

        // Enterprise ShuttleCraft Data

        logger.debug("Init Shuttlecraft")
        let defaultNumShuttleCraft = 6
        _shuttleCraft = SSMakeSystemArray(count: defaultNumShuttleCraft, withType: ShuttleCraft.self)
        shuttleCraft = SystemArrayAccess(source: _shuttleCraft)
        DI = SystemArrayAccess(source: _shuttleCraft, member: "DI")

        // Location
        DJ = SystemArrayAccess(source: _shuttleCraft, member: "DJ")
        DK = SystemArrayAccess(source: _shuttleCraft, member: "DK")
        DL = SystemArrayAccess(source: _shuttleCraft, member: "DL")

        // Velocity
        DM = SystemArrayAccess(source: _shuttleCraft, member: "DM")
        DN = SystemArrayAccess(source: _shuttleCraft, member: "DN")
        DO = SystemArrayAccess(source: _shuttleCraft, member: "DO")

        // Mission
        DP = SystemArrayAccess(source: _shuttleCraft, member: "DP")

        // Destination
        DQ = SystemArrayAccess(source: _shuttleCraft, member: "DQ")

        // Propulsion Tubes
        DR = SystemArrayAccess(source: _shuttleCraft, members: ["propulsionTubes", "DR"])   // functionalstatus
        DS = SystemArrayAccess(source: _shuttleCraft, members: ["propulsionTubes", "DS"])   // operationalstatus
        DT = SystemArrayAccess(source: _shuttleCraft, members: ["propulsionTubes", "DT"])   // reliabilityfactor
        DU = SystemArrayAccess(source: _shuttleCraft, members: ["propulsionTubes", "DU"])   // energyrequirement

        // Cargo
        DV = SystemArrayAccess(source: _shuttleCraft, member: "DV")

        // Sensor Array
        DW = SystemArrayAccess(source: _shuttleCraft, member: "DW")   // functionalstatus
        DX = SystemArrayAccess(source: _shuttleCraft, member: "DX")   // operationalstatus
        DY = SystemArrayAccess(source: _shuttleCraft, member: "DY")   // reliabilityfactor
        DZ = SystemArrayAccess(source: _shuttleCraft, member: "DZ")   // energyrequirement

        // Defensive Weapons

        // Shield
        D1 = SystemArrayAccess(source: _shuttleCraft, member: "D1")   // functionalstatus
        D2 = SystemArrayAccess(source: _shuttleCraft, member: "D2")   // operationalstatus
        D3 = SystemArrayAccess(source: _shuttleCraft, member: "D3")   // reliabilityfactor
        D4 = SystemArrayAccess(source: _shuttleCraft, member: "D4")   // energyrequirement

        // Offensive Weapons

        // Phaser
        D5 = SystemArrayAccess(source: _shuttleCraft, member: "D5")   // functionalstatus
        D6 = SystemArrayAccess(source: _shuttleCraft, member: "D6")   // operationalstatus
        D7 = SystemArrayAccess(source: _shuttleCraft, member: "D7")   // reliabilityfactor
        D8 = SystemArrayAccess(source: _shuttleCraft, member: "D8")   // energyrequirement
        shuttleCraftArrayAccessList = [shuttleCraft, DI, DJ, DK, DL, DM, DN, DO, DP, DQ, DR, DS, DT, DU, DV, DW, DX, DY, DZ, D1, D2, D3, D4, D5, D6, D7, D8]

        // Enterprise Intra-ship Transportation Data

        logger.debug("Init Turbo-Elevator Systems")
        // Turbo-Elevator Stations
        let defaultNumTurboElevatorStations = 10
        _turboElevatorStations = SSMakeSystemArray(count: defaultNumTurboElevatorStations, withType: TurboElevatorStation.self)
        turboElevatorStations = SystemArrayAccess(source: _turboElevatorStations)
        D9 = SystemArrayAccess(source: _turboElevatorStations, member: "D9")   // functionalstatus
        EA = SystemArrayAccess(source: _turboElevatorStations, member: "EA")   // operationalstatus
        EB = SystemArrayAccess(source: _turboElevatorStations, member: "EB")   // reliabilityfactor
        turboElevatorStationsArrayAccessList = [turboElevatorStations, D9, EA, EB]

        // Turbo-elevator Cars
        let defaultNumTurboElevatorCars = 6
        _turboElevatorCars = SSMakeSystemArray(count: defaultNumTurboElevatorCars, withType: TurboElevatorCar.self)
        turboElevatorCars = SystemArrayAccess(source: _turboElevatorCars)
        EC = SystemArrayAccess(source: _turboElevatorCars, member: "EC")   // functionalstatus
        ED = SystemArrayAccess(source: _turboElevatorCars, member: "ED")
        EF = SystemArrayAccess(source: _turboElevatorCars, member: "EF")
        EG = SystemArrayAccess(source: _turboElevatorCars, member: "EG")
        turboElevatorCarsArrayAccessList = [turboElevatorCars, EC, ED, EF, EG]

        // Turbo-Elevator Computer
        turboElevatorComputer = TurboElevatorComputer()

        // Enterprise Transporter Data

        logger.debug("Init Transporter Systems")
        // Transporter Stations
        let defaultNumTransporterStations = 10
        _transporterStations = SSMakeSystemArray(count: defaultNumTransporterStations, withType: TransporterStation.self)
        transporterStations = SystemArrayAccess(source: _transporterStations)
        EL = SystemArrayAccess(source: _transporterStations, member: "EL")   // functionalstatus
        EM = SystemArrayAccess(source: _transporterStations, member: "EM")   // operationalstatus
        EN = SystemArrayAccess(source: _transporterStations, member: "EN")   // reliabilityfactor
        EO = SystemArrayAccess(source: _transporterStations, member: "EO")   // energyrequirement
        transporterStationsArrayAccessList = [transporterStations, EL, EM, EN, EO]

        logger.debug("Init Tractor Beam")
        // Enterprise Tractor Beam Data

        tractorBeam = TractorBeam()

        logger.debug("Init Life Support")
        lifeSupportSystem = LifeSupport()

        // Enterprise Communication Data

        // Intra- and Inter-Ship Communications Data

        logger.debug("Init Communications Systems")
        // Messages
        let defaultNumCommunicationsStations = 10
        _communicationsStations = SSMakeSystemArray(count: defaultNumCommunicationsStations, withType: CommunicationsStation.self)
        communicationsStations = SystemArrayAccess(source: _communicationsStations)
        FQ = SystemArrayAccess(source: _communicationsStations, member: "FQ")
        FR = SystemArrayAccess(source: _communicationsStations, member: "FR")
        hasMessages = SystemArrayAccess(source: _communicationsStations, member: "hasMessages")
        communicationsStationsArrayAccessList = [communicationsStations, FQ, FR, hasMessages]

        // Inter-celestial Communications Data
        communicationsComputer = CommunicationsComputer()

        // Enterprise Security Data

        logger.debug("Init Security Systems")
        // Detention Cell
        detentionCell = DetentionCell()

        // Enterprise Energy Supply Data

        logger.debug("Init Energy Systems")
        // Energy
        let defaultEnergyQuantity = 20000000000
        maximumEnergyQuantity = defaultEnergyQuantity * 2

        // Energy Supply Interconnect System
        let defaultNumEnergyConnectionSystems = 22     // NOTE: MUST be the same number as in EnergyConnectionSystem
        energyQuantity = defaultEnergyQuantity / defaultNumEnergyConnectionSystems

        var initArray = [EnergyConnectionStation]()
        for n in 1...defaultNumEnergyConnectionSystems {
            initArray.append(EnergyConnectionStation(system: EnergyConnectionSystem(rawValue: n)!, energySupply: energyQuantity / defaultNumEnergyConnectionSystems))
        }
        _energyStations = SSMakeSystemArray(withArray: initArray)
        energyStations = SystemArrayAccess(source: _energyStations)
        F4 = SystemArrayAccess(source: _energyStations, member: "F4")   // functionalstatus
        F5 = SystemArrayAccess(source: _energyStations, member: "F5")   // operationalstatus
        F6 = SystemArrayAccess(source: _energyStations, member: "F6")   // reliabilityfactor
        F7 = SystemArrayAccess(source: _energyStations, member: "F7")    // energysupply
        energyStationsArrayAccessList = [energyStations, F4, F5, F6, F7]

        // Enterprise Sensor Array Data

        logger.debug("Init Sensor Systems")
        // Radiation Sensor
        radiationSensor = RadiationSensor()

        // Gravity Sensor
        gravitySensor = GravitySensor()

        // Life Forms Sensor
        lifeFormsSensor = LifeFormsSensor()

        // Atmospheric Sensor
        atmosphericSensor = AtmosphericSensor()

        // Enterprise Cargo Data

        logger.debug("Init Cargo")
        _cargo = SystemArray()
        cargo = SystemArrayAccess(source: _cargo)
        GP = SystemArrayAccess(source: _cargo, member: "GP") // cargotype enum 4
        GQ = SystemArrayAccess(source: _cargo, member: "GQ") // quantity int
        GR = SystemArrayAccess(source: _cargo, member: "GR") // location enum 4000
        cargoArrayAccessList = [cargo, GP, GQ, GR]

        // Enterprise General Data
        alertStatus = AlertStatus.Normal

        // Data Associated with Enemy Ships


        logger.debug("Init Enemy Ships")
        _enemyShips = SystemArray()
        enemyShips = SystemArrayAccess(source: _enemyShips)
        GU = SystemArrayAccess(source: _enemyShips, member: "GU")    // name string
        GV = SystemArrayAccess(source: _enemyShips, member: "GV")    // existnce bool

        // Weapons Data

        // Defensive Weapons
        GW = SystemArrayAccess(source: _enemyShips, member: "GW")
        GX = SystemArrayAccess(source: _enemyShips, member: "GX")
        GY = SystemArrayAccess(source: _enemyShips, member: "GY")   // functionalstatus
        GZ = SystemArrayAccess(source: _enemyShips, member: "GZ")   // operationalstatus
        G1 = SystemArrayAccess(source: _enemyShips, member: "G1")   // reliabilityfactor
        G2 = SystemArrayAccess(source: _enemyShips, member: "G2")   // energyrequirement

        // Offensive Weapons
        G3 = SystemArrayAccess(source: _enemyShips, member: "G3")
        G4 = SystemArrayAccess(source: _enemyShips, member: "G4")
        G5 = SystemArrayAccess(source: _enemyShips, member: "G5")   // functionalstatus
        G6 = SystemArrayAccess(source: _enemyShips, member: "G6")   // operationalstatus
        G7 = SystemArrayAccess(source: _enemyShips, member: "G7")   // reliabilityfactor
        G8 = SystemArrayAccess(source: _enemyShips, member: "G8")   // energyrequirement
        G9 = SystemArrayAccess(source: _enemyShips, member: "G9")

        // Life Forms Data
        HA = SystemArrayAccess(source: _enemyShips, member: "HA")
        HB = SystemArrayAccess(source: _enemyShips, member: "HB")
        HC = SystemArrayAccess(source: _enemyShips, member: "HC")
        HD = SystemArrayAccess(source: _enemyShips, member: "HD")   // functionalstatus
        HE = SystemArrayAccess(source: _enemyShips, member: "HE")   // operationalstatus
        HF = SystemArrayAccess(source: _enemyShips, member: "HF")   // reliabilityfactor
        HG = SystemArrayAccess(source: _enemyShips, member: "HG")

        // Enemy Ships Navigation Data

        // Location
        HH = SystemArrayAccess(source: _enemyShips, member: "HH")
        HI = SystemArrayAccess(source: _enemyShips, member: "HI")
        HJ = SystemArrayAccess(source: _enemyShips, member: "HJ")

        // Velocity
        HK = SystemArrayAccess(source: _enemyShips, member: "HK")
        HL = SystemArrayAccess(source: _enemyShips, member: "HL")
        HM = SystemArrayAccess(source: _enemyShips, member: "HM")
        HN = SystemArrayAccess(source: _enemyShips, member: "HN")

        // Destination
        HO = SystemArrayAccess(source: _enemyShips, member: "HO")
        HP = SystemArrayAccess(source: _enemyShips, member: "HP")
        HQ = SystemArrayAccess(source: _enemyShips, member: "HQ")
        HR = SystemArrayAccess(source: _enemyShips, member: "HR")

        // Navigation Computer
        HS = SystemArrayAccess(source: _enemyShips, member: "HS")   // functionalstatus
        HT = SystemArrayAccess(source: _enemyShips, member: "HT")   // operationalstatus
        HU = SystemArrayAccess(source: _enemyShips, member: "HU")   // reliabilityfactor
        HV = SystemArrayAccess(source: _enemyShips, member: "HV")   // energyrequirement

        // Mission
        HW = SystemArrayAccess(source: _enemyShips, member: "HW")

        // Cargo
        HX = SystemArrayAccess(source: _enemyShips, member: "HX")
        HY = SystemArrayAccess(source: _enemyShips, member: "HY")
        HZ = SystemArrayAccess(source: _enemyShips, member: "HZ")
        H1 = SystemArrayAccess(source: _enemyShips, member: "H1")
        H2 = SystemArrayAccess(source: _enemyShips, member: "H2")
        H3 = SystemArrayAccess(source: _enemyShips, member: "H3")
        H4 = SystemArrayAccess(source: _enemyShips, member: "H4")

        // Peace Treaty Offered
        H5 = SystemArrayAccess(source: _enemyShips, member: "H5")

        // Peace Treaty Request
        H6 = SystemArrayAccess(source: _enemyShips, member: "H6")

        // Enemy Ship Energy Supply
        H7 = SystemArrayAccess(source: _enemyShips, member: "H7")

        // Fired Upon Flag
        H8 = SystemArrayAccess(source: _enemyShips, member: "H8")
        enemyShipsAccessList = [enemyShips, GU, GV, GW, GX, GY, GZ, G1, G2, G3, G4, G5, G6, G7, G8, G9, HA, HB, HC, HD, HE, HF, HG, HH, HI, HJ, HK, HL, HM, HN, HO, HP, HQ, HR, HS, HT, HU, HV, HW, HX, HY, HZ, H1, H2, H3, H4, H5, H6, H7, H8]

        // Data Associated with Federation Ships

        logger.debug("Init Federation Ships")
        _federationShips = SystemArray()
        federationShips = SystemArrayAccess(source: _federationShips)
        IA = SystemArrayAccess(source: _federationShips, member: "IA")   // name string
        IB = SystemArrayAccess(source: _federationShips, member: "IB")   // existence bool

        // Federation Ships Weapons Data

        // Defensive Weapons
        IC = SystemArrayAccess(source: _federationShips, member: "IC")   // quantity int
        ID = SystemArrayAccess(source: _federationShips, member: "ID")   // type enum 2
        IE = SystemArrayAccess(source: _federationShips, member: "IE")   // functionalstatus
        IF = SystemArrayAccess(source: _federationShips, member: "IF")   // operationalstatus
        IG = SystemArrayAccess(source: _federationShips, member: "IG")   // reliabilityfactor
        IH = SystemArrayAccess(source: _federationShips, member: "IH")   // energyrequirement

        // Offensive Weapons
        IJ = SystemArrayAccess(source: _federationShips, member: "IJ")
        IK = SystemArrayAccess(source: _federationShips, member: "IK")
        IL = SystemArrayAccess(source: _federationShips, member: "IL")   // functionalstatus
        IM = SystemArrayAccess(source: _federationShips, member: "IM")   // operationalstatus
        IN = SystemArrayAccess(source: _federationShips, member: "IN")   // reliabilityfactor
        IO = SystemArrayAccess(source: _federationShips, member: "IO")   // energyrequirement

        // Federation Ships Life Forms Data

        IP = SystemArrayAccess(source: _federationShips, member: "IP")   // number int
        IQ = SystemArrayAccess(source: _federationShips, member: "IQ")   // iq int
        IR = SystemArrayAccess(source: _federationShips, member: "IR")
        IS = SystemArrayAccess(source: _federationShips, member: "IS")   // operationalstatus
        IT = SystemArrayAccess(source: _federationShips, member: "IT")   // reliabilityfactor
        IU = SystemArrayAccess(source: _federationShips, member: "IU")   // haalthstatus

        // Federation Ships Navigation Data

        // Location
        IV = SystemArrayAccess(source: _federationShips, member: "IV")
        IW = SystemArrayAccess(source: _federationShips, member: "IW")
        IX = SystemArrayAccess(source: _federationShips, member: "IX")

        // Velocity
        IY = SystemArrayAccess(source: _federationShips, member: "IY")
        IZ = SystemArrayAccess(source: _federationShips, member: "IZ")
        I1 = SystemArrayAccess(source: _federationShips, member: "I1")
        I2 = SystemArrayAccess(source: _federationShips, member: "I2")

        // Destination
        I3 = SystemArrayAccess(source: _federationShips, member: "I3")
        I4 = SystemArrayAccess(source: _federationShips, member: "I4")
        I5 = SystemArrayAccess(source: _federationShips, member: "I5")
        I6 = SystemArrayAccess(source: _federationShips, member: "I6")

        // Navigation Computer
        I7 = SystemArrayAccess(source: _federationShips, member: "I7")   // functionalstatus
        I8 = SystemArrayAccess(source: _federationShips, member: "I8")   // operationalstatus
        I9 = SystemArrayAccess(source: _federationShips, member: "I9")   // reliabilityfactor
        JA = SystemArrayAccess(source: _federationShips, member: "JA")   // energyrequirement

        // Mission
        JB = SystemArrayAccess(source: _federationShips, member: "JB")

        // Cargo
        JC = SystemArrayAccess(source: _federationShips, member: "JC")
        JD = SystemArrayAccess(source: _federationShips, member: "JD")
        JE = SystemArrayAccess(source: _federationShips, member: "JE")
        JI = SystemArrayAccess(source: _federationShips, member: "JI")
        JK = SystemArrayAccess(source: _federationShips, member: "JK")
        JL = SystemArrayAccess(source: _federationShips, member: "JL")
        JM = SystemArrayAccess(source: _federationShips, member: "JM")

        // Peace Treaty Offer
        JN = SystemArrayAccess(source: _federationShips, member: "JN")

        // Peace Treaty Request
        JO = SystemArrayAccess(source: _federationShips, member: "JO")

        // Federation Ship Power Supply

        // Energy
        JP = SystemArrayAccess(source: _federationShips, member: "JP")   // quantity double

        // Fired Upon Flag
        JQ = SystemArrayAccess(source: _federationShips, member: "JQ")
        federationShipsAccessList = [federationShips, IA, IB, IC, ID, IE, IF, IG, IH, IJ, IK, IL, IM, IN, IO, IP, IQ, IR, IS, IT, IU, IV, IW, IX, IY, IZ, I1, I2, I3, I4, I5, I6, I7, I8, I9, JA, JB, JC, JD, JE, JI, JK, JL, JM, JN, JO, JP, JQ]

        // The epoch is the number of seconds from Jan 1, 2001 to Jan 1, 2201
        epoch2201 = 6311347200.0

        // Call the Big Guy
        super.init()
    }

    /// Celestial Data

    /// Universe Size

    dynamic var xMax: Coordinate
    dynamic var xMin: Coordinate
    dynamic var yMax: Coordinate
    dynamic var yMin: Coordinate
    dynamic var zMax: Coordinate
    dynamic var zMin: Coordinate

    // Var names as defined in the book
    dynamic var AA: BigNum {
        set {
            xMax = newValue
        }
        get {
            return xMax
        }
    }
    dynamic var AB: BigNum {
        set {
            xMin = newValue
        }
        get {
            return xMin
        }
    }
    dynamic var AC: BigNum {
        set {
            yMax = newValue
        }
        get {
            return yMax
        }
    }
    dynamic var AD: BigNum {
        set {
            yMin = newValue
        }
        get {
            return yMin
        }
    }
    dynamic var AE: BigNum {
        set {
            zMax = newValue
        }
        get {
            return zMax
        }
    }
    dynamic var AF: BigNum {
        set {
            zMin = newValue
        }
        get {
            return zMin
        }
    }

    /// Celestial Objects

    dynamic var _celestialObjects: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _celestialObjects, accessList: celestialObjectsAccessList)
        }
    }

    var AG: Int {return celestialObjects.count}

    let celestialObjects: SystemArrayAccess
    let AH: SystemArrayAccess
    let AI: SystemArrayAccess
    let JV: SystemArrayAccess
    let AJ: SystemArrayAccess
    let AK: SystemArrayAccess
    let AL: SystemArrayAccess
    let AM: SystemArrayAccess
    let AN: SystemArrayAccess
    let AO: SystemArrayAccess
    let AP: SystemArrayAccess
    let AQ: SystemArrayAccess
    let AR: SystemArrayAccess
    let AS: SystemArrayAccess
    let AT: SystemArrayAccess
    let AU: SystemArrayAccess
    let AV: SystemArrayAccess
    let AW: SystemArrayAccess
    let AX: SystemArrayAccess
    let AY: SystemArrayAccess
    let AZ: SystemArrayAccess
    let A1: SystemArrayAccess
    let A2: SystemArrayAccess
    let A3: SystemArrayAccess
    let A4: SystemArrayAccess
    let A5: SystemArrayAccess
    let A6: SystemArrayAccess
    let A7: SystemArrayAccess
    let A8: SystemArrayAccess
    let A9: SystemArrayAccess
    let BA: SystemArrayAccess
    let BB: SystemArrayAccess
    let celestialObjectsAccessList: SystemArrayAccessList



    /// Romulan Empire Location

    let romulanEmpire: SpatialVolume

    dynamic var BC: BigNum {
        set {
            romulanEmpire.x = newValue
        }
        get {
            return romulanEmpire.x
        }
    }
    dynamic var BD: BigNum {
        set {
            romulanEmpire.y = newValue
        }
        get {
            return romulanEmpire.y
        }
    }
    dynamic var BE: BigNum {
        set {
            romulanEmpire.z = newValue
        }
        get {
            return romulanEmpire.z
        }
    }
    dynamic var BF: BigNum {
        set {
            romulanEmpire.radius = newValue
        }
        get {
            return romulanEmpire.radius
        }
    }

    /// Klingon Empire Location

    let klingonEmpire: SpatialVolume

    dynamic var BG: BigNum {
        set {
            klingonEmpire.x = newValue
        }
        get {
            return klingonEmpire.x
        }
    }
    dynamic var BH: BigNum {
        set {
            klingonEmpire.y = newValue
        }
        get {
            return klingonEmpire.y
        }
    }
    dynamic var BI: BigNum {
        set {
            klingonEmpire.z = newValue
        }
        get {
            return klingonEmpire.z
        }
    }
    dynamic var BJ: BigNum {
        set {
            klingonEmpire.radius = newValue
        }
        get {
            return klingonEmpire.radius
        }
    }

    /// ### Enterprise Data

    /// Enterprise personnel

    dynamic var SSenterprisePersonnel: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSenterprisePersonnel, accessList: enterprisePersonsArrayAccessList)
        }
    }
    let enterprisePersonnelSAA: SystemArrayAccess
    var BK: Int {return SSenterprisePersonnel.count}
    let BL: SystemArrayAccess
    let BLid: SystemArrayAccess
    let BLgiven: SystemArrayAccess
    let BLsurname: SystemArrayAccess
    let BM: SystemArrayAccess
    let BN: SystemArrayAccess
    let BO: SystemArrayAccess
    let BOd: SystemArrayAccess
    let BP: SystemArrayAccess
    let BQ: SystemArrayAccess
    let BR: SystemArrayAccess
    let BS: SystemArrayAccess
    let BSd: SystemArrayAccess
    let BT: SystemArrayAccess
    let BU: SystemArrayAccess
    let enterprisePersonsArrayAccessList: [SystemArrayAccess]

    dynamic var foodConsumption: Float      // kg/hr
    dynamic var BV: Float {
        get {return foodConsumption}
        set {foodConsumption = newValue}
    }
    class func keyPathsForValuesAffectingBV() -> NSSet {
        return NSSet(array: ["foodConsumption"])
    }

    dynamic var waterConsumption: Float     // l/hr
    dynamic var BW: Float {
        get {return waterConsumption}
        set {waterConsumption = newValue}
    }
    class func keyPathsForValuesAffectingBW() -> NSSet {
        return NSSet(array: ["waterConsumption"])
    }

    dynamic var oxygenConsumption: Float    // l/hr
    dynamic var BX: Float {
        get {return oxygenConsumption}
        set {oxygenConsumption = newValue}
    }
    class func keyPathsForValuesAffectingBX() -> NSSet {
        return NSSet(array: ["oxygenConsumption"])
    }

    // KVC methods https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html
    func countOfEnterprisePersonnel() -> Int {
        logger.verbose("Entry")
        bumpCount()
        return SSenterprisePersonnel.count
    }

    func objectInEnterprisePersonnelAtIndex(index: Int) -> AnyObject {
        logger.verbose("Entry")
        bumpCount()
        return SSenterprisePersonnel[index]
    }

    func enterprisePersonnelAtIndexes(indexes: NSIndexSet) -> [AnyObject] {
        logger.verbose("Entry")
        bumpCount()
        return SSenterprisePersonnel.objectsAtIndexes(indexes)
    }

    func getEnterprisePersonnel(buffer: AutoreleasingUnsafeMutablePointer<AnyObject?>, inRange: NSRange) {
        logger.verbose("Entry")
        bumpCount()
        SSenterprisePersonnel.getObjects(buffer, range: inRange)
    }

    func insertObject(object: AnyObject, inEnterprisePersonnelAtIndex index: Int) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
        SSenterprisePersonnel.insertObject(object, atIndex: index)
        didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
    }

    func insertEnterprisePersonnel(enterprisePersonnelArray: NSArray, atIndexes indexes: NSIndexSet) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Insertion, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
        SSenterprisePersonnel.insertObjects(enterprisePersonnelArray, atIndexes: indexes)
        didChange(.Insertion, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
    }

    func removeObjectFromEnterprisePersonnelAtIndex(index: Int) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
        SSenterprisePersonnel.removeObjectAtIndex(index)
        didChange(.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
    }

    func removeEnterprisePersonnelAtIndexes(indexes: NSIndexSet) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Removal, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
        SSenterprisePersonnel.removeObjectsAtIndexes(indexes)
        didChange(.Removal, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
    }

    func replaceObjectInEnterprisePersonnelAtIndex(index: Int, withObject object: AnyObject) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Replacement, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
        SSenterprisePersonnel.replaceObjectAtIndex(index, withObject: object)
        didChange(.Replacement, valuesAtIndexes: NSIndexSet(index: index), forKey: "enterprisePersonnel")
    }

    func replaceEnterprisePersonnelAtIndexes(indexes: NSIndexSet, withEnterprisePersonnel objects: NSArray) {
        logger.verbose("Entry")
        bumpCount()
        willChange(.Replacement, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
        SSenterprisePersonnel.replaceObjectsAtIndexes(indexes, withObjects: objects)
        didChange(.Replacement, valuesAtIndexes: indexes, forKey: "enterprisePersonnel")
    }


    /// Enterprise Weapons Data

    /// Offensive Weapons

    // Photon torpedo tubes (6)
    var numPhotonTubes: Int {return photonTubes.count}
    dynamic var SSPhotonTubes: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSPhotonTubes, accessList: photonTubesArrayAccessList)
        }
    }

    var SSPhotonTubesCount: Int {return SSPhotonTubes.count}
    let photonTubes: SystemArrayAccess
    let BY: SystemArrayAccess
    let BZ: SystemArrayAccess
    let B1: SystemArrayAccess
    let B2: SystemArrayAccess
    let B3: SystemArrayAccess
    let B4: SystemArrayAccess
    let photonTubesArrayAccessList: SystemArrayAccessList

    // Phaser Stations (status only)
    var numPhaserStations: Int {return phaserStations.count}
    var SSphaserStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSphaserStations, accessList: phaserStationsArrayAccessList)
        }
    }
    let phaserStations: SystemArrayAccess
    let B5: SystemArrayAccess
    let B6: SystemArrayAccess
    let B7: SystemArrayAccess
    let B8: SystemArrayAccess
    let phaserStationsArrayAccessList: SystemArrayAccessList

    /// Defensive Weapons

    // Deflector Shields
    var numDeflectorShields: Int {return deflectorShields.count}
    var SSdeflectorShields: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSdeflectorShields, accessList: deflectorShieldsArrayAccessList)
        }
    }
    let deflectorShields: SystemArrayAccess
    let B9: SystemArrayAccess
    let CA: SystemArrayAccess
    let CB: SystemArrayAccess
    // CC unaccounted for in the book?
    let CD: SystemArrayAccess
    let deflectorShieldsArrayAccessList: SystemArrayAccessList

    // Cloaking Device
    let cloakingDevice: CloakingDevice
    var CE: FunctionalStatus {
        get {return cloakingDevice.CE}
        set {cloakingDevice.CE = newValue}
    }
    var CF: OperationalStatus {
        get {return cloakingDevice.CF}
        set {cloakingDevice.CF = newValue}
    }
    var CG: Int {
        get {return cloakingDevice.CG}
        set {cloakingDevice.CG = newValue}
    }

    /// Enterprise Propulsion Data

    // Space/Warp engine
    var numWarpEngines: Int {return warpEngines.count}
    var SSwarpEngines: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSwarpEngines, accessList: warpEnginesArrayAccessList)
        }
    }
    var warpEngines: SystemArrayAccess
    let CH: SystemArrayAccess
    let CI: SystemArrayAccess
    let CJ: SystemArrayAccess
    let CK: SystemArrayAccess
    let warpEnginesArrayAccessList: SystemArrayAccessList

    // Impulse Engines
    var numImpulseEngines: Int {return impulseEngines.count}
    var SSimpulseEngines: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: SSimpulseEngines, accessList: impulseEnginesArrayAccessList)
        }
    }
    let impulseEngines: SystemArrayAccess
    let CL: SystemArrayAccess
    let CM: SystemArrayAccess
    let CN: SystemArrayAccess
    let CO: SystemArrayAccess
    let impulseEnginesArrayAccessList: SystemArrayAccessList

    /// Enterprise location and velocity
    var enterprisePosition: SpatialPosition
    var CP: BigNum {
        get {return enterprisePosition.x}
        set {enterprisePosition.x = newValue}
    }
    var CQ: BigNum {
        get {return enterprisePosition.y}
        set {enterprisePosition.y = newValue}
    }
    var CR: BigNum {
        get {return enterprisePosition.z}
        set {enterprisePosition.z = newValue}
    }

    var enterpriseVelocity: Velocity
    var CS: BigNum {
        get {return enterpriseVelocity.xy}
        set {enterpriseVelocity.xy = newValue}
    }
    var CT: BigNum {
        get {return enterpriseVelocity.xz}
        set {enterpriseVelocity.xz = newValue}
    }
    var CU: BigNum {
        get {return enterpriseVelocity.speed}
        set {enterpriseVelocity.speed = newValue}
    }

    /// Enterprise destination
    var enterpriseDestination: Location
    var CV: Int {
        get {return enterpriseDestination.num}
        set {enterpriseDestination.num = newValue}
    }

    /// Navigation Computer
    let navigationComputer: NavigationComputer
    var CZ: FunctionalStatus {
        get {return navigationComputer.CZ}
        set {navigationComputer.CZ = newValue}
    }
    var C1: OperationalStatus {
        get {return navigationComputer.C1}
        set {navigationComputer.C1 = newValue}
    }
    var C2: ReliabilityFactor {
        get {return navigationComputer.C2}
        set {navigationComputer.C2 = newValue}
    }
    var C3: EnergyRequirement {
        get {return navigationComputer.C3}
        set {navigationComputer.C3 = newValue}
    }

    /// Enterprise Medical Section

    /// Medical Research Lab
    let medicalResearchLab: MedicalResearchLab
    var C4: FunctionalStatus {
        get {return medicalResearchLab.C4}
        set {medicalResearchLab.C4 = newValue}
    }
    var C5: OperationalStatus {
        get {return medicalResearchLab.C5}
        set {medicalResearchLab.C5 = newValue}
    }
    var C6: ReliabilityFactor {
        get {return medicalResearchLab.C6}
        set {medicalResearchLab.C6 = newValue}
    }
    var C7: EnergyRequirement {
        get {return medicalResearchLab.C7}
        set {medicalResearchLab.C7 = newValue}
    }

    /// Intensive Care Unit
    let intensiveCareUnit: IntensiveCareUnit
    var C8: FunctionalStatus {
        get {return intensiveCareUnit.C8}
        set {intensiveCareUnit.C8 = newValue}
    }
    var C9: OperationalStatus {
        get {return intensiveCareUnit.C9}
        set {intensiveCareUnit.C9 = newValue}
    }
    var DA: ReliabilityFactor {
        get {return intensiveCareUnit.DA}
        set {intensiveCareUnit.DA = newValue}
    }
    var DB: EnergyRequirement {
        get {return intensiveCareUnit.DB}
        set {intensiveCareUnit.DB = newValue}
    }

    /// Medical Computer
    let medicalComputer: MedicalComputer
    var DD: FunctionalStatus {
        get {return medicalComputer.DD}
        set {medicalComputer.DD = newValue}
    }
    var DE: OperationalStatus {
        get {return medicalComputer.DE}
        set {medicalComputer.DE = newValue}
    }
    var DF: ReliabilityFactor {
        get {return medicalComputer.DF}
        set {medicalComputer.DF = newValue}
    }
    var DG: EnergyRequirement {
        get {return medicalComputer.DG}
        set {medicalComputer.DG = newValue}
    }

    // Medical Supplies Quantity
    var medicalSuppliesQuantity: Int
    var DH: Int {
        get {return medicalSuppliesQuantity}
        set {medicalSuppliesQuantity = newValue}
    }

    // ShuttleCraft
    var _shuttleCraft: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _shuttleCraft, accessList: shuttleCraftArrayAccessList)
        }
    }
    let shuttleCraft: SystemArrayAccess
    let DI: SystemArrayAccess   // Operational Status[n]
    let DJ: SystemArrayAccess   // X-coordinate[n]
    let DK: SystemArrayAccess   // Y-coordinate[n]
    let DL: SystemArrayAccess   // Z-coordinate[n]
    let DM: SystemArrayAccess   // XY-direction[n]
    let DN: SystemArrayAccess   // XZ-direction[n]
    let DO: SystemArrayAccess   // Speed[n]
    let DP: SystemArrayAccess   // Mission[n]
    let DQ: SystemArrayAccess   // Destination[n]
    let DR: SystemArrayAccess   // Propultion Tube Functional Status[n,m]
    let DS: SystemArrayAccess   // Propultion Tube Operational Status[n,m]
    let DT: SystemArrayAccess   // Propultion Tube Reliability Factor[n,m]
    let DU: SystemArrayAccess   // Propultion Tube Energy Requirement[n,m]
    let DV: SystemArrayAccess   // [n]Cargo
    let DW: SystemArrayAccess   // Sensor Array Functional Status[n]
    let DX: SystemArrayAccess   // Sensor Array Operational Status[n]
    let DY: SystemArrayAccess   // Sensor Array Reliability Factor[n]
    let DZ: SystemArrayAccess   // Sensor Array Energy Requirement[n]
    let D1: SystemArrayAccess   // Shield Functional Status[n]
    let D2: SystemArrayAccess   // Shield Operational Status[n]
    let D3: SystemArrayAccess   // Shield Reliability Factor[n]
    let D4: SystemArrayAccess   // Shield Energy Requirement[n]
    let D5: SystemArrayAccess   // Phaser Functional Status[n]
    let D6: SystemArrayAccess   // Phaser Operational Status[n]
    let D7: SystemArrayAccess   // Phaser Reliability Factor[n]
    let D8: SystemArrayAccess   // Phaser Energy Requirement[n]
    let shuttleCraftArrayAccessList: SystemArrayAccessList

    // Enterprise intra-ship transportation system

    // Turbo Elevator Stations

    var _turboElevatorStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _turboElevatorStations, accessList: turboElevatorStationsArrayAccessList)
        }
    }
    let turboElevatorStations: SystemArrayAccess
    let D9: SystemArrayAccess   // Functional Status[n]
    let EA: SystemArrayAccess   // Operational Status[n]
    let EB: SystemArrayAccess   // Reliability Factor[n]
    let turboElevatorStationsArrayAccessList: SystemArrayAccessList

    // Turbo Eleevator Cars

    var _turboElevatorCars: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _turboElevatorCars, accessList: turboElevatorCarsArrayAccessList)
        }
    }
    let turboElevatorCars: SystemArrayAccess
    let EC: SystemArrayAccess   // Functional Status[n]
    let ED: SystemArrayAccess   // Location[n]
    // EE unaccounted for in book
    let EF: SystemArrayAccess   // Destination[n]
    let EG: SystemArrayAccess   // ArrivalTime[n]
    let turboElevatorCarsArrayAccessList: SystemArrayAccessList

    // Turbo Elevator Computer

    var turboElevatorComputer: TurboElevatorComputer
    var EH: FunctionalStatus {
        get {return turboElevatorComputer.EH}
        set {turboElevatorComputer.EH = newValue}
    }
    var EI: OperationalStatus {
        get {return turboElevatorComputer.EI}
        set {turboElevatorComputer.EI = newValue}
    }
    var EJ: ReliabilityFactor {
        get {return turboElevatorComputer.EJ}
        set {turboElevatorComputer.EJ = newValue}
    }
    var EK: EnergyRequirement {
        get {return turboElevatorComputer.EK}
        set {turboElevatorComputer.EK = newValue}
    }

    // Enterprise transporter data

    // Transporter Stations

    var _transporterStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _transporterStations, accessList: transporterStationsArrayAccessList)
        }
    }
    let transporterStations: SystemArrayAccess
    let EL: SystemArrayAccess
    let EM: SystemArrayAccess
    let EN: SystemArrayAccess
    let EO: SystemArrayAccess
    let transporterStationsArrayAccessList: SystemArrayAccessList

    // Enterprise Tractor Beam Data

    // Tracor Beam

    var tractorBeam: TractorBeam
    var EP: FunctionalStatus {
        get {return tractorBeam.EP}
        set {tractorBeam.EP = newValue}
    }
    var EQ: OperationalStatus {
        get {return tractorBeam.EQ}
        set {tractorBeam.EQ = newValue}
    }
    var ER: ReliabilityFactor {
        get {return tractorBeam.ER}
        set {tractorBeam.ER = newValue}
    }
    var ES: Int {
        get {return tractorBeam.ES}
        set {tractorBeam.ES = newValue}
    }
    var EScode: LocationCode {  // Read-only
        get {return tractorBeam.EScode}
    }
    var ET: EnergyRequirement {
        get {return tractorBeam.ET}
        set {tractorBeam.ET = newValue}
    }

    // Enterprise Life Support System

    var lifeSupportSystem: LifeSupport
    // Food Supply
    var EU: Int {
        get {return lifeSupportSystem.EU}
        set {lifeSupportSystem.EU = newValue}
    }
    var EV: Percent {
        get {return lifeSupportSystem.EV}
        set {lifeSupportSystem.EV = newValue}
    }
    var EW: Int {
        get {return lifeSupportSystem.EW}
        set {lifeSupportSystem.EW = newValue}
    }
    var EX: Percent {
        get {return lifeSupportSystem.EX}
        set {lifeSupportSystem.EX = newValue}
    }

    // Food Recycle System
    var EY: Int {
        get {return lifeSupportSystem.EY}
        set {lifeSupportSystem.EY = newValue}
    }
    var EZ: Int {
        get {return lifeSupportSystem.EZ}
        set {lifeSupportSystem.EZ = newValue}
    }
    var E1: Int {
        get {return lifeSupportSystem.E1}
        set {lifeSupportSystem.E1 = newValue}
    }
    var E2: Int {
        get {return lifeSupportSystem.E2}
        set {lifeSupportSystem.E2 = newValue}
    }
    var E3: EnergyRequirement {
        get {return lifeSupportSystem.E3}
        set {lifeSupportSystem.E3 = newValue}
    }

    // Oxygen
    var E4: Int {
        get {return lifeSupportSystem.E4}
        set {lifeSupportSystem.E4 = newValue}
    }
    var E5: Int {
        get {return lifeSupportSystem.E5}
        set {lifeSupportSystem.E5 = newValue}
    }
    var E6: Percent {
        get {return lifeSupportSystem.E6}
        set {lifeSupportSystem.E6 = newValue}
    }

    // Oxygen Distribution System
    var E7: FunctionalStatus {
        get {return lifeSupportSystem.E7}
        set {lifeSupportSystem.E7 = newValue}
    }
    var E8: OperationalStatus {
        get {return lifeSupportSystem.E8}
        set {lifeSupportSystem.E8 = newValue}
    }
    var E9: ReliabilityFactor {
        get {return lifeSupportSystem.E9}
        set {lifeSupportSystem.E9 = newValue}
    }
    var FA: EnergyRequirement {
        get {return lifeSupportSystem.FA}
        set {lifeSupportSystem.FA = newValue}
    }

    // Oxygen Recycle System
    var FB: FunctionalStatus {
        get {return lifeSupportSystem.FB}
        set {lifeSupportSystem.FB = newValue}
    }
    var FC: OperationalStatus {
        get {return lifeSupportSystem.FC}
        set {lifeSupportSystem.FC = newValue}
    }
    var FD: ReliabilityFactor {
        get {return lifeSupportSystem.FD}
        set {lifeSupportSystem.FD = newValue}
    }
    var FE: EnergyRequirement {
        get {return lifeSupportSystem.FE}
        set {lifeSupportSystem.FE = newValue}
    }

    // Water
    var FF: Int {
        get {return lifeSupportSystem.FF}
        set {lifeSupportSystem.FF = newValue}
    }
    var FG: Int {
        get {return lifeSupportSystem.FG}
        set {lifeSupportSystem.FG = newValue}
    }
    var FH: Percent {
        get {return lifeSupportSystem.FH}
        set {lifeSupportSystem.FH = newValue}
    }

    // Water Distribution System
    var FI: FunctionalStatus {
        get {return lifeSupportSystem.FI}
        set {lifeSupportSystem.FI = newValue}
    }
    var FJ: OperationalStatus {
        get {return lifeSupportSystem.FJ}
        set {lifeSupportSystem.FJ = newValue}
    }
    var FK: ReliabilityFactor {
        get {return lifeSupportSystem.FK}
        set {lifeSupportSystem.FK = newValue}
    }
    var FL: EnergyRequirement {
        get {return lifeSupportSystem.FL}
        set {lifeSupportSystem.FL = newValue}
    }

    // Water Recycle System
    var FM: FunctionalStatus {
        get {return lifeSupportSystem.FM}
        set {lifeSupportSystem.FM = newValue}
    }
    var FN: OperationalStatus {
        get {return lifeSupportSystem.FN}
        set {lifeSupportSystem.FN = newValue}
    }
    var FO: ReliabilityFactor {
        get {return lifeSupportSystem.FO}
        set {lifeSupportSystem.FO = newValue}
    }
    var FP: EnergyRequirement {
        get {return lifeSupportSystem.FP}
        set {lifeSupportSystem.FP = newValue}
    }

    // Enterprise Cummunications Data

    var _communicationsStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _communicationsStations, accessList: communicationsStationsArrayAccessList)
        }
    }
    let communicationsStations: SystemArrayAccess
    let FQ: SystemArrayAccess
    let FR: SystemArrayAccess
    let hasMessages: SystemArrayAccess
    let communicationsStationsArrayAccessList: SystemArrayAccessList

    // Enterprise Inter-Celestial Communications Data

    // Enterprise Communications Computer

    let communicationsComputer: CommunicationsComputer
    var FS: FunctionalStatus {
        get {return communicationsComputer.FS}
        set {communicationsComputer.FS = newValue}
    }
    var FT: OperationalStatus {
        get {return communicationsComputer.FT}
        set {communicationsComputer.FT = newValue}
    }
    var FU: ReliabilityFactor {
        get {return communicationsComputer.FU}
        set {communicationsComputer.FU = newValue}
    }
    var FV: EnergyRequirement {
        get {return communicationsComputer.FV}
        set {communicationsComputer.FV = newValue}
    }

    // Enterprise Security Data
    let detentionCell: DetentionCell
    var FW: FunctionalStatus {
        get {return detentionCell.FW}
        set {detentionCell.FW = newValue}
    }
    var FX: OperationalStatus {
        get {return detentionCell.FX}
        set {detentionCell.FX = newValue}
    }
    var FY: ReliabilityFactor {
        get {return detentionCell.FY}
        set {detentionCell.FY = newValue}
    }
    var FZ: EnergyRequirement {
        get {return detentionCell.FZ}
        set {detentionCell.FZ = newValue}
    }
    var F1: Int {
        get {return detentionCell.F1}
        set {detentionCell.F1 = newValue}
    }

    // Enterprise Energy

    var energyQuantity: Int
    var F2: Int {
        get {return energyQuantity}
        set {energyQuantity = newValue}
    }

    var maximumEnergyQuantity: Int
    var F3: Int {
        get {return maximumEnergyQuantity}
        set {maximumEnergyQuantity = newValue}
    }

    var _energyStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _energyStations, accessList: energyStationsArrayAccessList)
        }
    }
    let energyStations: SystemArrayAccess
    let F4: SystemArrayAccess
    let F5: SystemArrayAccess
    let F6: SystemArrayAccess
    let F7: SystemArrayAccess
    let energyStationsArrayAccessList: SystemArrayAccessList

    // Enterprise Sensor Array Data

    let radiationSensor: RadiationSensor
    var F8: FunctionalStatus {
        get {return radiationSensor.F8}
        set {radiationSensor.F8 = newValue}
    }
    var F9: OperationalStatus {
        get {return radiationSensor.F9}
        set {radiationSensor.F9 = newValue}
    }
    var GA: ReliabilityFactor {
        get {return radiationSensor.GA}
        set {radiationSensor.GA = newValue}
    }
    var GB: EnergyRequirement {
        get {return radiationSensor.GB}
        set {radiationSensor.GB = newValue}
    }

    let gravitySensor: GravitySensor
    var GC: FunctionalStatus {
        get {return gravitySensor.GC}
        set {gravitySensor.GC = newValue}
    }
    var GD: OperationalStatus {
        get {return gravitySensor.GD}
        set {gravitySensor.GD = newValue}
    }
    var GE: ReliabilityFactor {
        get {return gravitySensor.GE}
        set {gravitySensor.GE = newValue}
    }
    var GF: EnergyRequirement {
        get {return gravitySensor.GF}
        set {gravitySensor.GF = newValue}
    }

    let lifeFormsSensor: LifeFormsSensor
    var GH: FunctionalStatus {
        get {return lifeFormsSensor.GH}
        set {lifeFormsSensor.GH = newValue}
    }
    var GI: OperationalStatus {
        get {return lifeFormsSensor.GI}
        set {lifeFormsSensor.GI = newValue}
    }
    var GJ: ReliabilityFactor {
        get {return lifeFormsSensor.GJ}
        set {lifeFormsSensor.GJ = newValue}
    }
    var GK: EnergyRequirement {
        get {return lifeFormsSensor.GK}
        set {lifeFormsSensor.GK = newValue}
    }

    let atmosphericSensor: AtmosphericSensor
    var GL: FunctionalStatus {
        get {return atmosphericSensor.GL}
        set {atmosphericSensor.GL = newValue}
    }
    var GM: OperationalStatus {
        get {return atmosphericSensor.GM}
        set {atmosphericSensor.GM = newValue}
    }
    var GN: ReliabilityFactor {
        get {return atmosphericSensor.GN}
        set {atmosphericSensor.GN = newValue}
    }
    var GO: EnergyRequirement {
        get {return atmosphericSensor.GO}
        set {atmosphericSensor.GO = newValue}
    }

    // Enterprise Cargo

    var _cargo: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _cargo, accessList: cargoArrayAccessList)
        }
    }
    let cargo: SystemArrayAccess
    let GP: SystemArrayAccess
    let GQ: SystemArrayAccess
    let GR: SystemArrayAccess
    let cargoArrayAccessList: SystemArrayAccessList

    // Alert Status
    var alertStatus: AlertStatus
    var GS: Int {
        get {return alertStatus.rawValue}
        set {
            if newValue >= 0 && newValue <= 3 {
                alertStatus = AlertStatus(rawValue: newValue)!
            }
        }
    }

    // Enemy Ships

    var _enemyShips: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _enemyShips, accessList: enemyShipsAccessList)
        }
    }
    let enemyShips: SystemArrayAccess
    let GU: SystemArrayAccess
    let GV: SystemArrayAccess
    let GW: SystemArrayAccess
    let GX: SystemArrayAccess
    let GY: SystemArrayAccess
    let GZ: SystemArrayAccess
    let G1: SystemArrayAccess
    let G2: SystemArrayAccess
    let G3: SystemArrayAccess
    let G4: SystemArrayAccess
    let G5: SystemArrayAccess
    let G6: SystemArrayAccess
    let G7: SystemArrayAccess
    let G8: SystemArrayAccess
    let G9: SystemArrayAccess
    let HA: SystemArrayAccess
    let HB: SystemArrayAccess
    let HC: SystemArrayAccess
    let HD: SystemArrayAccess
    let HE: SystemArrayAccess
    let HF: SystemArrayAccess
    let HG: SystemArrayAccess
    let HH: SystemArrayAccess
    let HI: SystemArrayAccess
    let HJ: SystemArrayAccess
    let HK: SystemArrayAccess
    let HL: SystemArrayAccess
    let HM: SystemArrayAccess
    let HN: SystemArrayAccess
    let HO: SystemArrayAccess
    let HP: SystemArrayAccess
    let HQ: SystemArrayAccess
    let HR: SystemArrayAccess
    let HS: SystemArrayAccess
    let HT: SystemArrayAccess
    let HU: SystemArrayAccess
    let HV: SystemArrayAccess
    let HW: SystemArrayAccess
    let HX: SystemArrayAccess
    let HY: SystemArrayAccess
    let HZ: SystemArrayAccess
    let H1: SystemArrayAccess
    let H2: SystemArrayAccess
    let H3: SystemArrayAccess
    let H4: SystemArrayAccess
    let H5: SystemArrayAccess
    let H6: SystemArrayAccess
    let H7: SystemArrayAccess
    let H8: SystemArrayAccess
    let enemyShipsAccessList: SystemArrayAccessList

    // Federation Ships

    var _federationShips: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: _federationShips, accessList: federationShipsAccessList)
        }
    }
    let federationShips: SystemArrayAccess
    let IA: SystemArrayAccess
    let IB: SystemArrayAccess
    let IC: SystemArrayAccess
    let ID: SystemArrayAccess
    let IE: SystemArrayAccess
    let IF: SystemArrayAccess
    let IG: SystemArrayAccess
    let IH: SystemArrayAccess
    let IJ: SystemArrayAccess
    let IK: SystemArrayAccess
    let IL: SystemArrayAccess
    let IM: SystemArrayAccess
    let IN: SystemArrayAccess
    let IO: SystemArrayAccess
    let IP: SystemArrayAccess
    let IQ: SystemArrayAccess
    let IR: SystemArrayAccess
    let IS: SystemArrayAccess
    let IT: SystemArrayAccess
    let IU: SystemArrayAccess
    let IV: SystemArrayAccess
    let IW: SystemArrayAccess
    let IX: SystemArrayAccess
    let IY: SystemArrayAccess
    let IZ: SystemArrayAccess
    let I1: SystemArrayAccess
    let I2: SystemArrayAccess
    let I3: SystemArrayAccess
    let I4: SystemArrayAccess
    let I5: SystemArrayAccess
    let I6: SystemArrayAccess
    let I7: SystemArrayAccess
    let I8: SystemArrayAccess
    let I9: SystemArrayAccess
    let JA: SystemArrayAccess
    let JB: SystemArrayAccess
    let JC: SystemArrayAccess
    let JD: SystemArrayAccess
    let JE: SystemArrayAccess
    let JI: SystemArrayAccess
    let JK: SystemArrayAccess
    let JL: SystemArrayAccess
    let JM: SystemArrayAccess
    let JN: SystemArrayAccess
    let JO: SystemArrayAccess
    let JP: SystemArrayAccess
    let JQ: SystemArrayAccess
    let federationShipsAccessList: SystemArrayAccessList

    // Time and run reference information

    let epoch2201: NSTimeInterval
    var masterRS: RunningState!         // Set by the Master controller during its initialization

    var JT: NSDate {
        var retDate = NSDate().dateByAddingTimeInterval(epoch2201)  // Now adjusted into 2201 - 2001
        if let mRS = masterRS {
            if let st = mRS.startTime {
                retDate = st.dateByAddingTimeInterval(epoch2201 + mRS.elapsedTime)
            }
        }
        return retDate
    }

    // Possibly overkill in compliance but we can gather info on which methods are actually used

    /// Function entry counters
    var entryCounts: [String: Int] = [:]

    /// Initiate or increment function counter
    func bumpCount(funcName: String = __FUNCTION__) {
        if entryCounts[funcName] != nil {
            entryCounts[funcName]!++
        } else {
            entryCounts[funcName] = 1
        }
    }

    func dumpCounts() {
        logger.debug("KVC counts")

        for k in Array(entryCounts.keys).sorted({ $0 < $1 }) {
            logger.debug("\(k): \(entryCounts[k]!)")
        }
    }
    
}
