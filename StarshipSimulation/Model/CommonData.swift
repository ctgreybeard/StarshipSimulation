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
        // It's a cubical world ...
        xMax = max
        xMin = -xMax
        yMax = xMax
        yMin = xMin
        zMax = xMax
        zMin = xMin

        // Things Celestial
        celestialObjects = SystemArray()

        AH = SystemArrayAccess(source: celestialObjects, member: "AH")  // classification enum 7
        AI = SystemArrayAccess(source: celestialObjects, member: "AI")  // name
        JV = SystemArrayAccess(source: celestialObjects, member: "JV")  // charted bool
        // Location
        AJ = SystemArrayAccess(source: celestialObjects, member: "AJ")  // coordinate
        AK = SystemArrayAccess(source: celestialObjects, member: "AK")  // coordinate
        AL = SystemArrayAccess(source: celestialObjects, member: "AL")  // coordinate
        // Velocity
        AM = SystemArrayAccess(source: celestialObjects, member: "AM")  // direction
        AN = SystemArrayAccess(source: celestialObjects, member: "AN")  // direction
        AO = SystemArrayAccess(source: celestialObjects, member: "AO")  // speed
        AP = SystemArrayAccess(source: celestialObjects, member: "AP")  // radius
        // Radiation
        AQ = SystemArrayAccess(source: celestialObjects, member: "AQ")  // radiationtype enum 2
        AR = SystemArrayAccess(source: celestialObjects, member: "AR")  // radiationintensity int
        AS = SystemArrayAccess(source: celestialObjects, member: "AS")  // mass
        // Life Forms
        AT = SystemArrayAccess(source: celestialObjects, member: "AT")  // quantity int
        AU = SystemArrayAccess(source: celestialObjects, member: "AU")  // lifeformclassification enum 4
        AV = SystemArrayAccess(source: celestialObjects, member: "AV")  // iq int
        // Defensive Weapons
        AW = SystemArrayAccess(source: celestialObjects, member: "AW", readOnly: true) // quantity int
        AX = SystemArrayAccess(source: celestialObjects, members: ["defensiveWeapons", "AX"])   // weapontype enum 1
        AY = SystemArrayAccess(source: celestialObjects, members: ["defensiveWeapons", "AY"])   // functionalstatus
        AZ = SystemArrayAccess(source: celestialObjects, members: ["defensiveWeapons", "AZ"])   // operationalstatus
        A1 = SystemArrayAccess(source: celestialObjects, members: ["defensiveWeapons", "A1"])   // reliabilityfactor
        A2 = SystemArrayAccess(source: celestialObjects, members: ["defensiveWeapons", "A2"])   // energyrequirement
        // Offensive Weapons
        A3 = SystemArrayAccess(source: celestialObjects, member: "A3", readOnly: true) // quantity int
        A4 = SystemArrayAccess(source: celestialObjects, members: ["offensiveWeapons", "A4"])   // weapontype enum 4
        A5 = SystemArrayAccess(source: celestialObjects, members: ["offensiveWeapons", "A5"])   // functionalstatus
        A6 = SystemArrayAccess(source: celestialObjects, members: ["offensiveWeapons", "A6"])   // operationalstatus
        A7 = SystemArrayAccess(source: celestialObjects, members: ["offensiveWeapons", "A7"])   // reliabilityfactor
        A8 = SystemArrayAccess(source: celestialObjects, members: ["offensiveWeapons", "A8"])   // energyrequirement
        A9 = SystemArrayAccess(source: celestialObjects, member: "A9")
        BA = SystemArrayAccess(source: celestialObjects, member: "BA")
        BB = SystemArrayAccess(source: celestialObjects, member: "BB")

        // Empire locations
        romulanEmpire = SpatialVolume()
        klingonEmpire = SpatialVolume()

        // Enterprise Data

        // Enterprise Personnel
        let defaultNumEnterprisePersons = 43 + 387
        enterprisePersonnel = SystemArray(num: defaultNumEnterprisePersons, withType: EnterprisePerson.self)

        BL = SystemArrayAccess(source: enterprisePersonnel, member: "BL")   // Name
        BLid = SystemArrayAccess(source: enterprisePersonnel, member: "BLid", readOnly: true)   // soID.description
        BM = SystemArrayAccess(source: enterprisePersonnel, member: "BM")   // Rank
        BN = SystemArrayAccess(source: enterprisePersonnel, member: "BN")   // IQ
        BO = SystemArrayAccess(source: enterprisePersonnel, member: "BO")   // Location
        BOd = SystemArrayAccess(source: enterprisePersonnel, member: "BOd") // Location description
        BP = SystemArrayAccess(source: enterprisePersonnel, member: "BP")   // X-coordinate
        BQ = SystemArrayAccess(source: enterprisePersonnel, member: "BQ")   // Y-coordinate
        BR = SystemArrayAccess(source: enterprisePersonnel, member: "BR")   // Z-coordinate
        BS = SystemArrayAccess(source: enterprisePersonnel, member: "BS")   // Destination
        BSd = SystemArrayAccess(source: enterprisePersonnel, member: "BSd") // Destination description
        BT = SystemArrayAccess(source: enterprisePersonnel, member: "BT")   // functionalstatus
        BU = SystemArrayAccess(source: enterprisePersonnel, member: "BU")
        enterprisePersonsArrayAccessList = [BL, BM, BN, BO, BP, BQ, BR, BS, BT, BU]

        foodConsumption = 1.0       // kg/hr
        waterConsumption = 1.0      // l/hr
        oxygenConsumption = 1.0     // l/hr

        // Enterprise Offensive Weapons Data

        // Photon Tubes
        let defaultNumPhotonTubes = 6
        photonTubes = SystemArray(num: defaultNumPhotonTubes, withType: PhotonTube.self)

        // Set the torpedo locations
        let numTorps = (photonTubes[0] as PhotonTube).torpedos.count
        for p in 0..<photonTubes.count {
            let tube = photonTubes[p] as PhotonTube
            for t in 0..<numTorps {
                tube.B3[t] = LocationCode.PhotonTorpedoTubeStation.rawValue + p
            }
        }
        BY = SystemArrayAccess(source: photonTubes, member: "BY")   // functionalstatus
        BZ = SystemArrayAccess(source: photonTubes, member: "BZ")   // reliabilityfactor
        B1 = SystemArrayAccess(source: photonTubes, member: "B1")   // energyrequirement
        B2 = SystemArrayAccess(source: photonTubes, member: "B2", readOnly: true)
        B3 = SystemArrayAccess(source: photonTubes, members: ["torpedos", "B3"])
        B4 = SystemArrayAccess(source: photonTubes, members: ["torpedos", "B4"])
        photonTubesArrayAccessList = [BY, BZ, B1, B2, B3, B4]

        // Phaser Stations
        let defaultNumPhaserStations = 6
        phaserStations = SystemArray(num: defaultNumPhaserStations, withType: PhaserStation.self)
        B5 = SystemArrayAccess(source: photonTubes, member: "B5")   // functionalstatus
        B6 = SystemArrayAccess(source: photonTubes, member: "B6")   // operationalstatus
        B7 = SystemArrayAccess(source: photonTubes, member: "B7")   // reliabilityfactor
        B8 = SystemArrayAccess(source: photonTubes, member: "B8")   // energyrequirement
        phaserStationsArrayAccessList = [B5, B6, B7, B8]

        // Enterprise Defensive Weapons Data

        // Deflector Shields
        let defaultNumDeflectorShields = 6
        deflectorShields = SystemArray(num: defaultNumDeflectorShields, withType: DeflectorShield.self)
        B9 = SystemArrayAccess(source: deflectorShields, member: "B9")   // functionalstatus
        CA = SystemArrayAccess(source: deflectorShields, member: "CA")   // operationalstatus
        CB = SystemArrayAccess(source: deflectorShields, member: "CB")   // reliabilityfactor
        CD = SystemArrayAccess(source: deflectorShields, member: "CD")   // energyrequirement
        deflectorShieldsArrayAccessList = [B9, CA, CB, CD]

        // Cloaking Device
        cloakingDevice = CloakingDevice()

        // Enterprise Propulsion Data

        // Warp Engines
        let defaultNumWarpEngines = 2
        warpEngines = SystemArray(num: defaultNumWarpEngines, withType: WarpEngine.self)
        CH = SystemArrayAccess(source: warpEngines, member: "CH")   // functionalstatus
        CI = SystemArrayAccess(source: warpEngines, member: "CI")   // operationalstatus
        CJ = SystemArrayAccess(source: warpEngines, member: "CJ")   // reliabilityfactor
        CK = SystemArrayAccess(source: warpEngines, member: "CK")   // energyrequirement
        warpEnginesArrayAccessList = [CH, CI, CJ, CK]

        // Impulse Engines
        let defaultNumImpulseEngines = 2
        impulseEngines = SystemArray(num: defaultNumImpulseEngines, withType: ImpulseEngine.self)
        CL = SystemArrayAccess(source: impulseEngines, member: "CL")   // functionalstatus
        CM = SystemArrayAccess(source: impulseEngines, member: "CM")   // operationalstatus
        CN = SystemArrayAccess(source: impulseEngines, member: "CN")   // reliabilityfactor
        CO = SystemArrayAccess(source: impulseEngines, member: "CO")   // energyrequirement
        impulseEnginesArrayAccessList = [CL, CM, CN, CO]

        // Enterprise Navigation Data

        // Location
        enterprisePosition = SpatialPosition()

        // Velocity Vector
        enterpriseVelocity = Velocity()

        // Destination
        enterpriseDestination = Location()

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

        let defaultNumShuttleCraft = 6
        shuttleCraft = SystemArray(num: defaultNumShuttleCraft, withType: ShuttleCraft.self)
        DI = SystemArrayAccess(source: shuttleCraft, member: "DI")

        // Location
        DJ = SystemArrayAccess(source: shuttleCraft, member: "DJ")
        DK = SystemArrayAccess(source: shuttleCraft, member: "DK")
        DL = SystemArrayAccess(source: shuttleCraft, member: "DL")

        // Velocity
        DM = SystemArrayAccess(source: shuttleCraft, member: "DM")
        DN = SystemArrayAccess(source: shuttleCraft, member: "DN")
        DO = SystemArrayAccess(source: shuttleCraft, member: "DO")

        // Mission
        DP = SystemArrayAccess(source: shuttleCraft, member: "DP")

        // Destination
        DQ = SystemArrayAccess(source: shuttleCraft, member: "DQ")

        // Propulsion Tubes
        DR = SystemArrayAccess(source: shuttleCraft, members: ["propulsionTubes", "DR"])   // functionalstatus
        DS = SystemArrayAccess(source: shuttleCraft, members: ["propulsionTubes", "DS"])   // operationalstatus
        DT = SystemArrayAccess(source: shuttleCraft, members: ["propulsionTubes", "DT"])   // reliabilityfactor
        DU = SystemArrayAccess(source: shuttleCraft, members: ["propulsionTubes", "DU"])   // energyrequirement

        // Cargo
        DV = SystemArrayAccess(source: shuttleCraft, member: "DV")

        // Sensor Array
        DW = SystemArrayAccess(source: shuttleCraft, member: "DW")   // functionalstatus
        DX = SystemArrayAccess(source: shuttleCraft, member: "DX")   // operationalstatus
        DY = SystemArrayAccess(source: shuttleCraft, member: "DY")   // reliabilityfactor
        DZ = SystemArrayAccess(source: shuttleCraft, member: "DZ")   // energyrequirement

        // Defensive Weapons

        // Shield
        D1 = SystemArrayAccess(source: shuttleCraft, member: "D1")   // functionalstatus
        D2 = SystemArrayAccess(source: shuttleCraft, member: "D2")   // operationalstatus
        D3 = SystemArrayAccess(source: shuttleCraft, member: "D3")   // reliabilityfactor
        D4 = SystemArrayAccess(source: shuttleCraft, member: "D4")   // energyrequirement

        // Offensive Weapons

        // Phaser
        D5 = SystemArrayAccess(source: shuttleCraft, member: "D5")   // functionalstatus
        D6 = SystemArrayAccess(source: shuttleCraft, member: "D6")   // operationalstatus
        D7 = SystemArrayAccess(source: shuttleCraft, member: "D7")   // reliabilityfactor
        D8 = SystemArrayAccess(source: shuttleCraft, member: "D8")   // energyrequirement
        shuttleCraftArrayAccessList = [DI, DJ, DK, DL, DM, DN, DO, DP, DQ, DR, DS, DT, DU, DV, DW, DX, DY, DZ, D1, D2, D3, D4, D5, D6, D7, D8]

        // Enterprise Intra-ship Transportation Data

        // Turbo-Elevator Stations
        let defaultNumTurboElevatorStations = 10
        turboElevatorStations = SystemArray(num: defaultNumTurboElevatorStations, withType: TurboElevatorStation.self)
        D9 = SystemArrayAccess(source: turboElevatorStations, member: "D9")   // functionalstatus
        EA = SystemArrayAccess(source: turboElevatorStations, member: "EA")   // operationalstatus
        EB = SystemArrayAccess(source: turboElevatorStations, member: "EB")   // reliabilityfactor
        turboElevatorStationsArrayAccessList = [D9, EA, EB]

        // Turbo-elevator Cars
        let defaultNumTurboElevatorCars = 6
        turboElevatorCars = SystemArray(num: defaultNumTurboElevatorCars, withType: TurboElevatorCar.self)
        EC = SystemArrayAccess(source: turboElevatorCars, member: "EC")   // functionalstatus
        ED = SystemArrayAccess(source: turboElevatorCars, member: "ED")
        EF = SystemArrayAccess(source: turboElevatorCars, member: "EF")
        EG = SystemArrayAccess(source: turboElevatorCars, member: "EG")
        turboElevatorCarsArrayAccessList = [EC, ED, EF, EG]

        // Turbo-Elevator Computer
        turboElevatorComputer = TurboElevatorComputer()

        // Enterprise Transporter Data

        // Transporter Stations
        let defaultNumTransporterStations = 10
        transporterStations = SystemArray(num: defaultNumTransporterStations, withType: TransporterStation.self)
        EL = SystemArrayAccess(source: transporterStations, member: "EL")   // functionalstatus
        EM = SystemArrayAccess(source: transporterStations, member: "EM")   // operationalstatus
        EN = SystemArrayAccess(source: transporterStations, member: "EN")   // reliabilityfactor
        EO = SystemArrayAccess(source: transporterStations, member: "EO")   // energyrequirement
        transporterStationsArrayAccessList = [EL, EM, EN, EO]

        // Enterprise Tractor Beam Data

        tractorBeam = TractorBeam()

        lifeSupportSystem = LifeSupport()

        // Enterprise Communication Data

        // Intra- and Inter-Ship Communications Data

        // Messages
        let defaultNumCommunicationsStations = 10
        communicationsStations = SystemArray(num: defaultNumCommunicationsStations, withType: CommunicationsStation.self)
        FQ = SystemArrayAccess(source: communicationsStations, member: "FQ")
        FR = SystemArrayAccess(source: communicationsStations, member: "FR")
        hasMessages = SystemArrayAccess(source: communicationsStations, member: "hasMessages")
        communicationsStationsArrayAccessList = [FQ, FR, hasMessages]

        // Inter-celestial Communications Data
        communicationsComputer = CommunicationsComputer()

        // Enterprise Security Data

        // Detention Cell
        detentionCell = DetentionCell()

        // Enterprise Energy Supply Data

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
        energyStations = SystemArray(with: initArray)
        F4 = SystemArrayAccess(source: energyStations, member: "F4")   // functionalstatus
        F5 = SystemArrayAccess(source: energyStations, member: "F5")   // operationalstatus
        F6 = SystemArrayAccess(source: energyStations, member: "F6")   // reliabilityfactor
        F7 = SystemArrayAccess(source: energyStations, member: "F7")    // energysupply
        energyStationsArrayAccessList = [F4, F5, F6, F7]

        // Enterprise Sensor Array Data

        // Radiation Sensor
        radiationSensor = RadiationSensor()

        // Gravity Sensor
        gravitySensor = GravitySensor()

        // Life Forms Sensor
        lifeFormsSensor = LifeFormsSensor()

        // Atmospheric Sensor
        atmosphericSensor = AtmosphericSensor()

        // Enterprise Cargo Data

        cargo = SystemArray()
        GP = SystemArrayAccess(source: cargo, member: "GP") // cargotype enum 4
        GQ = SystemArrayAccess(source: cargo, member: "GQ") // quantity int
        GR = SystemArrayAccess(source: cargo, member: "GR") // location enum 4000
        cargoArrayAccessList = [GP, GQ, GR]

        // Enterprise General Data
        alertStatus = AlertStatus.Normal

        // Data Associated with Enemy Ships


        enemyShips = SystemArray()
        GU = SystemArrayAccess(source: enemyShips, member: "GU")    // name string
        GV = SystemArrayAccess(source: enemyShips, member: "GV")    // existnce bool

        // Weapons Data

        // Defensive Weapons
        GW = SystemArrayAccess(source: enemyShips, member: "GW")
        GX = SystemArrayAccess(source: enemyShips, member: "GX")
        GY = SystemArrayAccess(source: enemyShips, member: "GY")   // functionalstatus
        GZ = SystemArrayAccess(source: enemyShips, member: "GZ")   // operationalstatus
        G1 = SystemArrayAccess(source: enemyShips, member: "G1")   // reliabilityfactor
        G2 = SystemArrayAccess(source: enemyShips, member: "G2")   // energyrequirement

        // Offensive Weapons
        G3 = SystemArrayAccess(source: enemyShips, member: "G3")
        G4 = SystemArrayAccess(source: enemyShips, member: "G4")
        G5 = SystemArrayAccess(source: enemyShips, member: "G5")   // functionalstatus
        G6 = SystemArrayAccess(source: enemyShips, member: "G6")   // operationalstatus
        G7 = SystemArrayAccess(source: enemyShips, member: "G7")   // reliabilityfactor
        G8 = SystemArrayAccess(source: enemyShips, member: "G8")   // energyrequirement
        G9 = SystemArrayAccess(source: enemyShips, member: "G9")

        // Life Forms Data
        HA = SystemArrayAccess(source: enemyShips, member: "HA")
        HB = SystemArrayAccess(source: enemyShips, member: "HB")
        HC = SystemArrayAccess(source: enemyShips, member: "HC")
        HD = SystemArrayAccess(source: enemyShips, member: "HD")   // functionalstatus
        HE = SystemArrayAccess(source: enemyShips, member: "HE")   // operationalstatus
        HF = SystemArrayAccess(source: enemyShips, member: "HF")   // reliabilityfactor
        HG = SystemArrayAccess(source: enemyShips, member: "HG")

        // Enemy Ships Navigation Data

        // Location
        HH = SystemArrayAccess(source: enemyShips, member: "HH")
        HI = SystemArrayAccess(source: enemyShips, member: "HI")
        HJ = SystemArrayAccess(source: enemyShips, member: "HJ")

        // Velocity
        HK = SystemArrayAccess(source: enemyShips, member: "HK")
        HL = SystemArrayAccess(source: enemyShips, member: "HL")
        HM = SystemArrayAccess(source: enemyShips, member: "HM")
        HN = SystemArrayAccess(source: enemyShips, member: "HN")

        // Destination
        HO = SystemArrayAccess(source: enemyShips, member: "HO")
        HP = SystemArrayAccess(source: enemyShips, member: "HP")
        HQ = SystemArrayAccess(source: enemyShips, member: "HQ")
        HR = SystemArrayAccess(source: enemyShips, member: "HR")

        // Navigation Computer
        HS = SystemArrayAccess(source: enemyShips, member: "HS")   // functionalstatus
        HT = SystemArrayAccess(source: enemyShips, member: "HT")   // operationalstatus
        HU = SystemArrayAccess(source: enemyShips, member: "HU")   // reliabilityfactor
        HV = SystemArrayAccess(source: enemyShips, member: "HV")   // energyrequirement

        // Mission
        HW = SystemArrayAccess(source: enemyShips, member: "HW")

        // Cargo
        HX = SystemArrayAccess(source: enemyShips, member: "HX")
        HY = SystemArrayAccess(source: enemyShips, member: "HY")
        HZ = SystemArrayAccess(source: enemyShips, member: "HZ")
        H1 = SystemArrayAccess(source: enemyShips, member: "H1")
        H2 = SystemArrayAccess(source: enemyShips, member: "H2")
        H3 = SystemArrayAccess(source: enemyShips, member: "H3")
        H4 = SystemArrayAccess(source: enemyShips, member: "H4")

        // Peace Treaty Offered
        H5 = SystemArrayAccess(source: enemyShips, member: "H5")

        // Peace Treaty Request
        H6 = SystemArrayAccess(source: enemyShips, member: "H6")

        // Enemy Ship Energy Supply
        H7 = SystemArrayAccess(source: enemyShips, member: "H7")

        // Fired Upon Flag
        H8 = SystemArrayAccess(source: enemyShips, member: "H8")

        // Data Associated with Federation Ships

        federationShips = SystemArray()
        IA = SystemArrayAccess(source: federationShips, member: "IA")   // name string
        IB = SystemArrayAccess(source: federationShips, member: "IB")   // existence bool

        // Federation Ships Weapons Data

        // Defensive Weapons
        IC = SystemArrayAccess(source: federationShips, member: "IC")   // quantity int
        ID = SystemArrayAccess(source: federationShips, member: "ID")   // type enum 2
        IE = SystemArrayAccess(source: federationShips, member: "IE")   // functionalstatus
        IF = SystemArrayAccess(source: federationShips, member: "IF")   // operationalstatus
        IG = SystemArrayAccess(source: federationShips, member: "IG")   // reliabilityfactor
        IH = SystemArrayAccess(source: federationShips, member: "IH")   // energyrequirement

        // Offensive Weapons
        IJ = SystemArrayAccess(source: federationShips, member: "IJ")
        IK = SystemArrayAccess(source: federationShips, member: "IK")
        IL = SystemArrayAccess(source: federationShips, member: "IL")   // functionalstatus
        IM = SystemArrayAccess(source: federationShips, member: "IM")   // operationalstatus
        IN = SystemArrayAccess(source: federationShips, member: "IN")   // reliabilityfactor
        IO = SystemArrayAccess(source: federationShips, member: "IO")   // energyrequirement

        // Federation Ships Life Forms Data

        IP = SystemArrayAccess(source: federationShips, member: "IP")   // number int
        IQ = SystemArrayAccess(source: federationShips, member: "IQ")   // iq int
        IR = SystemArrayAccess(source: federationShips, member: "IR")
        IS = SystemArrayAccess(source: federationShips, member: "IS")   // operationalstatus
        IT = SystemArrayAccess(source: federationShips, member: "IT")   // reliabilityfactor
        IU = SystemArrayAccess(source: federationShips, member: "IU")   // haalthstatus

        // Federation Ships Navigation Data

        // Location
        IV = SystemArrayAccess(source: federationShips, member: "IV")
        IW = SystemArrayAccess(source: federationShips, member: "IW")
        IX = SystemArrayAccess(source: federationShips, member: "IX")

        // Velocity
        IY = SystemArrayAccess(source: federationShips, member: "IY")
        IZ = SystemArrayAccess(source: federationShips, member: "IZ")
        I1 = SystemArrayAccess(source: federationShips, member: "I1")
        I2 = SystemArrayAccess(source: federationShips, member: "I2")

        // Destination
        I3 = SystemArrayAccess(source: federationShips, member: "I3")
        I4 = SystemArrayAccess(source: federationShips, member: "I4")
        I5 = SystemArrayAccess(source: federationShips, member: "I5")
        I6 = SystemArrayAccess(source: federationShips, member: "I6")

        // Navigation Computer
        I7 = SystemArrayAccess(source: federationShips, member: "I7")   // functionalstatus
        I8 = SystemArrayAccess(source: federationShips, member: "I8")   // operationalstatus
        I9 = SystemArrayAccess(source: federationShips, member: "I9")   // reliabilityfactor
        JA = SystemArrayAccess(source: federationShips, member: "JA")   // energyrequirement

        // Mission
        JB = SystemArrayAccess(source: federationShips, member: "JB")

        // Cargo
        JC = SystemArrayAccess(source: federationShips, member: "JC")
        JD = SystemArrayAccess(source: federationShips, member: "JD")
        JE = SystemArrayAccess(source: federationShips, member: "JE")
        JI = SystemArrayAccess(source: federationShips, member: "JI")
        JK = SystemArrayAccess(source: federationShips, member: "JK")
        JL = SystemArrayAccess(source: federationShips, member: "JL")
        JM = SystemArrayAccess(source: federationShips, member: "JM")

        // Peace Treaty Offer
        JN = SystemArrayAccess(source: federationShips, member: "JN")

        // Peace Treaty Request
        JO = SystemArrayAccess(source: federationShips, member: "JO")

        // Federation Ship Power Supply

        // Energy
        JP = SystemArrayAccess(source: federationShips, member: "JP")   // quantity double

        // Fired Upon Flag
        JQ = SystemArrayAccess(source: federationShips, member: "JQ")

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
    var AA: BigNum {
        set {
            xMax = newValue
        }
        get {
            return xMax
        }
    }
    var AB: BigNum {
        set {
            xMin = newValue
        }
        get {
            return xMin
        }
    }
    var AC: BigNum {
        set {
            yMax = newValue
        }
        get {
            return yMax
        }
    }
    var AD: BigNum {
        set {
            yMin = newValue
        }
        get {
            return yMin
        }
    }
    var AE: BigNum {
        set {
            zMax = newValue
        }
        get {
            return zMax
        }
    }
    var AF: BigNum {
        set {
            zMin = newValue
        }
        get {
            return zMin
        }
    }

    /// Celestial Objects

    dynamic var celestialObjects: SystemArray

    var AG: Int {return celestialObjects.count}

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

    var numEnterprisePersons: Int {return enterprisePersonnel.count}
    var enterprisePersonnel: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: enterprisePersonnel, accessList: enterprisePersonsArrayAccessList)
        }
    }
    var BK: Int {return enterprisePersonnel.count}
    var BL: SystemArrayAccess
    var BLid: SystemArrayAccess
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

    var foodConsumption: Float      // kg/hr
    dynamic var BV: Float {
        get {return foodConsumption}
        set {foodConsumption = newValue}
    }

    var waterConsumption: Float     // l/hr
    dynamic var BW: Float {
        get {return waterConsumption}
        set {waterConsumption = newValue}
    }

    var oxygenConsumption: Float    // l/hr
    dynamic var BX: Float {
        get {return oxygenConsumption}
        set {oxygenConsumption = newValue}
    }

    /// Enterprise Weapons Data

    /// Offensive Weapons

    // Photon torpedo tubes (6)
    var numPhotonTubes: Int {return photonTubes.count}
    var photonTubes: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: photonTubes, accessList: photonTubesArrayAccessList)
        }
    }

    let BY: SystemArrayAccess
    let BZ: SystemArrayAccess
    let B1: SystemArrayAccess
    let B2: SystemArrayAccess
    let B3: SystemArrayAccess
    let B4: SystemArrayAccess
    let photonTubesArrayAccessList: [SystemArrayAccess]

    // Phaser Stations (status only)
    var numPhaserStations: Int {return phaserStations.count}
    var phaserStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: phaserStations, accessList: phaserStationsArrayAccessList)
        }
    }
    let B5: SystemArrayAccess
    let B6: SystemArrayAccess
    let B7: SystemArrayAccess
    let B8: SystemArrayAccess
    let phaserStationsArrayAccessList: [SystemArrayAccess]

    /// Defensive Weapons

    // Deflector Shields
    var numDeflectorShields: Int {return deflectorShields.count}
    var deflectorShields: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: deflectorShields, accessList: deflectorShieldsArrayAccessList)
        }
    }
    let B9: SystemArrayAccess
    let CA: SystemArrayAccess
    let CB: SystemArrayAccess
    // CC unaccounted for in the book?
    let CD: SystemArrayAccess
    let deflectorShieldsArrayAccessList: [SystemArrayAccess]

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
    var warpEngines: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: warpEngines, accessList: warpEnginesArrayAccessList)
        }
    }
    let CH: SystemArrayAccess
    let CI: SystemArrayAccess
    let CJ: SystemArrayAccess
    let CK: SystemArrayAccess
    let warpEnginesArrayAccessList: [SystemArrayAccess]

    // Impulse Engines
    var numImpulseEngines: Int {return impulseEngines.count}
    var impulseEngines: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: impulseEngines, accessList: impulseEnginesArrayAccessList)
        }
    }
    let CL: SystemArrayAccess
    let CM: SystemArrayAccess
    let CN: SystemArrayAccess
    let CO: SystemArrayAccess
    let impulseEnginesArrayAccessList: [SystemArrayAccess]

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
    var shuttleCraft: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: shuttleCraft, accessList: shuttleCraftArrayAccessList)
        }
    }
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
    let shuttleCraftArrayAccessList: [SystemArrayAccess]

    // Enterprise intra-ship transportation system

    // Turbo Elevator Stations

    var turboElevatorStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: turboElevatorStations, accessList: turboElevatorStationsArrayAccessList)
        }
    }
    let D9: SystemArrayAccess   // Functional Status[n]
    let EA: SystemArrayAccess   // Operational Status[n]
    let EB: SystemArrayAccess   // Reliability Factor[n]
    let turboElevatorStationsArrayAccessList: [SystemArrayAccess]

    // Turbo Eleevator Cars

    var turboElevatorCars: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: turboElevatorCars, accessList: turboElevatorCarsArrayAccessList)
        }
    }
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

    var transporterStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: transporterStations, accessList: transporterStationsArrayAccessList)
        }
    }
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

    let communicationsStations: SystemArray
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

    var energyStations: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: energyStations, accessList: energyStationsArrayAccessList)
        }
    }
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

    var cargo: SystemArray {
        didSet {
            setSystemArrayAccessFor(array: cargo, accessList: cargoArrayAccessList)
        }
    }
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

    let enemyShips: SystemArray
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

    // Federation Ships

    let federationShips: SystemArray
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
}
